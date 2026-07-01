# Unified Codebase Architecture

The codebase should be organized around one compiler pipeline with two ingress paths and several output folds.

## Proposed Project Layout

```text
Symphony.Core
  DomainIR
  SourceCatalog
  ProjectionSpec
  Lineage
  Constraints
  Lossiness
  RunLedger model

Symphony.Source.Sqlite
  SQLite schema harvest
  SQLite extraction
  Northwind miniature support

Symphony.Source.Oracle
  Oracle dictionary harvest
  Oracle extract
  SCN support
  Oracle type fidelity

Symphony.Stage.Tsv
  typed TSV schema
  TSV writer
  TSV reader
  manifest/checksum

Symphony.Stage.DuckDb
  DuckDB load
  staging queries
  reconciliation SQL

Symphony.Projector
  row parsing
  refinement checks
  document construction
  deterministic IDs

Symphony.Elasticsearch
  mapping compiler
  bulk writer
  validation
  alias lifecycle

Symphony.Catalog
  OpenMetadata bundle
  OKF docs
  semantic model seed

Symphony.Polyglot
  Domain IR emit
  TypeScript/JavaScript/Kotlin/Swift generators
  JSON schema/JTD/OpenAPI components

Symphony.Cli
  harvest
  compile
  extract
  stage
  project
  validate
  export
```

## Two Ingress Paths

### Ingress 1: Brownfield Database

```text
SQLite / Oracle
  -> SourceCatalog
  -> draft ProjectionSpec
  -> human enrichment
  -> compiled artifacts
```

### Ingress 2: Greenfield Domain

```text
F# bounded context
  -> DomainIR
  -> DomainProjection
  -> ProjectionSpec
  -> compiled artifacts
```

## Shared Middle

The shared middle is `ProjectionSpec`.

It should include:

- source inputs
- document grain
- identity policy
- transforms
- target fields
- lineage
- constraints
- lossiness
- quality rules
- semantic metadata
- serving policy
- export policy

## Output Folds

Every output should be a fold:

- `compileEsMapping`
- `writeBulk`
- `emitOpenMetadata`
- `emitOkf`
- `emitQuality`
- `emitContract`
- `emitRunLedger`
- `emitDomainIr`
- `emitTypeScript`
- `emitKotlin`
- `emitSwift`
- `emitDocs`

## CLI Shape

Recommended commands:

```powershell
symphony harvest sqlite --db northwind.db
symphony compile --projection northwind-order-lines.proj.yaml
symphony extract sqlite --to-tsv out/stage
symphony stage duckdb --from-tsv out/stage
symphony project --to-bulk out/bulk
symphony validate elastic --url http://localhost:9208
symphony export polyglot --target typescript
symphony docs build
```

For Oracle:

```powershell
symphony harvest oracle --schema SALES
symphony extract oracle --schema SALES --as-of-scn 123456 --to-tsv out/stage
```

## MVP Implementation Order

1. Keep current Northwind projection working.
2. Add `SourceCatalog` and `ProjectionSpec` types beside current `TableSpec`.
3. Add TSV staging for SQLite.
4. Load TSV into DuckDB.
5. Generate Elasticsearch artifacts from staged data.
6. Emit run ledger.
7. Emit TypeScript models from the projection/domain IR.
8. Add Oracle harvester.
9. Add Oracle extract to TSV.
10. Repeat the same validation path.

## Design Constraint

The source-specific modules should not know Elasticsearch.

The Elasticsearch module should not know Oracle.

The polyglot module should not know DuckDB.

`ProjectionSpec` and `DomainIR` are the translators.

