#Requires -Version 7.0
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [uri[]] $ElasticsearchUrl = @('http://localhost:9208', 'http://localhost:9209'),

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string] $MappingPath = (Join-Path $PSScriptRoot 'output/mapping.json'),

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string] $BulkPath = (Join-Path $PSScriptRoot 'output/bulk'),

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string] $ArtifactAlias = 'northwind_order_lines_alias',

    [Parameter()]
    [pscredential] $Credential,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string] $ApiKey,

    [Parameter()]
    [switch] $InsecureSkipCertificateCheck,

    [Parameter()]
    [switch] $KeepIndex
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function New-ElasticRequestOptions {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('GET', 'POST', 'PUT', 'DELETE')]
        [string] $Method,

        [Parameter(Mandatory)]
        [uri] $Uri,

        [Parameter()]
        [string] $Body,

        [Parameter()]
        [string] $ContentType = 'application/json'
    )

    $headers = @{}
    if (-not [string]::IsNullOrWhiteSpace($ApiKey)) {
        $headers.Authorization = "ApiKey $ApiKey"
    }

    $options = @{
        Method      = $Method
        Uri         = $Uri
        Headers     = $headers
        ErrorAction = 'Stop'
    }

    if ($null -ne $Credential) {
        $options.Credential = $Credential
    }

    if ($PSBoundParameters.ContainsKey('Body')) {
        $options.Body = $Body
        $options.ContentType = $ContentType
    }

    if ($InsecureSkipCertificateCheck) {
        $options.SkipCertificateCheck = $true
    }

    $options
}

function Invoke-ElasticJson {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('GET', 'POST', 'PUT', 'DELETE')]
        [string] $Method,

        [Parameter(Mandatory)]
        [uri] $Uri,

        [Parameter()]
        [string] $Body,

        [Parameter()]
        [string] $ContentType = 'application/json'
    )

    $options = New-ElasticRequestOptions -Method $Method -Uri $Uri -ContentType $ContentType
    if ($PSBoundParameters.ContainsKey('Body')) {
        $options.Body = $Body
        $options.ContentType = $ContentType
    }

    Invoke-RestMethod @options
}

function ConvertTo-ValidationBulkFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
        [string] $SourcePath,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $ValidationAlias
    )

    $targetPath = Join-Path ([System.IO.Path]::GetTempPath()) ("symphony-es-bulk-{0}.ndjson" -f ([guid]::NewGuid()))
    $writer = [System.IO.StreamWriter]::new($targetPath, $false, [System.Text.UTF8Encoding]::new($false))

    try {
        $lineNumber = 0
        $resolvedSourcePath = (Resolve-Path -LiteralPath $SourcePath).ProviderPath
        foreach ($line in [System.IO.File]::ReadLines($resolvedSourcePath)) {
            if ([string]::IsNullOrWhiteSpace($line)) {
                continue
            }

            if ($lineNumber % 2 -eq 0) {
                $action = $line | ConvertFrom-Json -AsHashtable
                $operation = @($action.Keys)[0]
                $action[$operation]['_index'] = $ValidationAlias
                $writer.WriteLine(($action | ConvertTo-Json -Compress -Depth 20))
            }
            else {
                $writer.WriteLine($line)
            }

            $lineNumber++
        }
    }
    finally {
        $writer.Dispose()
    }

    $targetPath
}

function Get-BulkFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Path
    )

    if (Test-Path -LiteralPath $Path -PathType Container) {
        Get-ChildItem -LiteralPath $Path -Filter '*.ndjson' -File |
            Sort-Object Name |
            Select-Object -ExpandProperty FullName
    }
    elseif (Test-Path -LiteralPath $Path -PathType Leaf) {
        (Resolve-Path -LiteralPath $Path).Path
    }
    else {
        throw "Bulk path not found: $Path"
    }
}

function Test-StrictMappingRejectsUnknownField {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [uri] $BaseUrl,

        [Parameter(Mandatory)]
        [string] $Alias
    )

    $probeUri = [uri]::new($BaseUrl, "$Alias/_doc/strict-mapping-probe")
    $probe = @{ unknownFieldShouldFail = $true } | ConvertTo-Json -Compress

    try {
        Invoke-ElasticJson -Method PUT -Uri $probeUri -Body $probe | Out-Null
        $false
    }
    catch {
        $true
    }
}

$mapping = Get-Content -Raw -LiteralPath $MappingPath
$bulkFiles = @(Get-BulkFile -Path $BulkPath)

if ($bulkFiles.Count -eq 0) {
    throw "No NDJSON bulk files found at $BulkPath."
}

$timestamp = Get-Date -Format 'yyyyMMddHHmmss'
$results = foreach ($url in $ElasticsearchUrl) {
    $baseUrl = [uri] ($url.AbsoluteUri.TrimEnd('/') + '/')
    $root = Invoke-ElasticJson -Method GET -Uri $baseUrl
    $major = [int] ($root.version.number -split '\.')[0]

    if ($major -notin @(8, 9)) {
        throw "Expected Elasticsearch 8.x or 9.x at $baseUrl, got $($root.version.number)."
    }

    $indexName = "symphony-northwind-order-lines-es$major-$timestamp"
    $validationAlias = "$ArtifactAlias-validation-es$major-$timestamp"
    $indexUri = [uri]::new($baseUrl, $indexName)
    $aliasUri = [uri]::new($baseUrl, '_aliases')
    $bulkUri = [uri]::new($baseUrl, '_bulk?require_alias=true')
    $refreshUri = [uri]::new($baseUrl, "$validationAlias/_refresh")
    $countUri = [uri]::new($baseUrl, "$validationAlias/_count")
    $searchUri = [uri]::new($baseUrl, "$validationAlias/_search")
    $tempBulkPath = $null

    try {
        if ($PSCmdlet.ShouldProcess($baseUrl, "Validate $ArtifactAlias artifacts on Elasticsearch $($root.version.number)")) {
            Invoke-ElasticJson -Method PUT -Uri $indexUri -Body $mapping | Out-Null

            $aliasBody = @{
                actions = @(
                    @{
                        add = @{
                            index          = $indexName
                            alias          = $validationAlias
                            is_write_index = $true
                        }
                    }
                )
            } | ConvertTo-Json -Depth 10 -Compress

            Invoke-ElasticJson -Method POST -Uri $aliasUri -Body $aliasBody | Out-Null

            $loadedChunks = 0
            foreach ($bulkFile in $bulkFiles) {
                if ($null -ne $tempBulkPath -and (Test-Path -LiteralPath $tempBulkPath)) {
                    Remove-Item -LiteralPath $tempBulkPath -Force
                    $tempBulkPath = $null
                }

                $tempBulkPath = ConvertTo-ValidationBulkFile -SourcePath $bulkFile -ValidationAlias $validationAlias
                $bulkBody = Get-Content -Raw -LiteralPath $tempBulkPath
                $bulkResponse = Invoke-ElasticJson -Method POST -Uri $bulkUri -Body $bulkBody -ContentType 'application/x-ndjson'

                if ($bulkResponse.errors) {
                    $failedItems =
                        $bulkResponse.items |
                        Where-Object { $null -ne $_.index.error } |
                        Select-Object -First 5

                    throw "Bulk load failed on $baseUrl from $bulkFile. First failures: $($failedItems | ConvertTo-Json -Compress -Depth 10)"
                }

                $loadedChunks++
            }

            Invoke-ElasticJson -Method POST -Uri $refreshUri | Out-Null
            $count = Invoke-ElasticJson -Method GET -Uri $countUri

            if ($count.count -le 0) {
                throw "Bulk load succeeded but count was zero on $baseUrl."
            }

            $rangeQuery = @{
                size  = 0
                query = @{
                    range = @{
                        lineSales = @{
                            gt = 0
                        }
                    }
                }
            } | ConvertTo-Json -Depth 10 -Compress

            Invoke-ElasticJson -Method POST -Uri $searchUri -Body $rangeQuery | Out-Null

            $strictRejected = Test-StrictMappingRejectsUnknownField -BaseUrl $baseUrl -Alias $validationAlias
            if (-not $strictRejected) {
                throw "Strict mapping probe unexpectedly indexed an unknown field on $baseUrl."
            }

            [pscustomobject]@{
                Url          = $baseUrl.AbsoluteUri
                Version      = $root.version.number
                Major        = $major
                Index        = $indexName
                Alias        = $validationAlias
                Documents    = $count.count
                BulkChunks   = $loadedChunks
                StrictReject = $strictRejected
            }
        }
    }
    finally {
        if ($null -ne $tempBulkPath -and (Test-Path -LiteralPath $tempBulkPath)) {
            Remove-Item -LiteralPath $tempBulkPath -Force
        }

        if (-not $KeepIndex -and $PSCmdlet.ShouldProcess($baseUrl, "Delete validation index $indexName")) {
            try {
                Invoke-ElasticJson -Method DELETE -Uri $indexUri | Out-Null
            }
            catch {
                Write-Warning "Could not delete validation index $indexName on ${baseUrl}: $($_.Exception.Message)"
            }
        }
    }
}

$results
