namespace Symphony.Bridge.Folds

open Symphony.Bridge.Spec
open System.Text.Json
open System.Text.Json.Nodes

module CompileEs =
    let private mapEsType (t: EsType) =
        match t with
        | Text -> "text"
        | Keyword -> "keyword"
        | Long -> "long"
        | Double -> "double"
        | Date -> "date"
        | Boolean -> "boolean"
        | Nested -> "nested"

    let private getOrAddObject (name: string) (parent: JsonObject) =
        match parent[name] with
        | null ->
            let child = JsonObject()
            parent.Add(name, child)
            child
        | node -> node.AsObject()

    let private getOrAddProperties (fieldObj: JsonObject) =
        match fieldObj["properties"] with
        | null ->
            let props = JsonObject()
            fieldObj.Add("dynamic", JsonValue.Create("strict"))
            fieldObj.Add("properties", props)
            props
        | node -> node.AsObject()

    let private leafMapping (t: EsType) =
        let fieldObj = JsonObject()
        fieldObj.Add("type", JsonValue.Create(mapEsType t))

        if t = Text then
            let fields = JsonObject()
            let keyword = JsonObject()
            keyword.Add("type", JsonValue.Create("keyword"))
            keyword.Add("ignore_above", JsonValue.Create(256))
            fields.Add("keyword", keyword)
            fieldObj.Add("fields", fields)

        fieldObj

    let private addFieldMapping (props: JsonObject) (field: FieldSpec<'row>) =
        let parts =
            field.Target.Split('.', System.StringSplitOptions.RemoveEmptyEntries)
            |> Array.toList

        let rec addAt (current: JsonObject) (remaining: string list) =
            match remaining with
            | [] -> ()
            | [ leaf ] -> current.Add(leaf, leafMapping field.EsType)
            | segment :: rest ->
                let childProps =
                    current
                    |> getOrAddObject segment
                    |> getOrAddProperties

                addAt childProps rest

        addAt props parts

    let compileMapping (spec: TableSpec) : string =
        let props = JsonObject()
        spec.Fields |> List.iter (addFieldMapping props)

        let mapping = JsonObject()
        mapping.Add("dynamic", JsonValue.Create("strict"))
        mapping.Add("properties", props)

        let root = JsonObject()
        root.Add("mappings", mapping)

        root.ToJsonString(JsonSerializerOptions(WriteIndented = true))

module LineageOf =
    let rec foldRaw (raw: Raw) : Lineage =
        match raw with
        | RCol n -> Exact (Set.singleton n)
        | RConcat(a, b) -> Lineage.combine (foldRaw a) (foldRaw b)
        | RApply(_, args) -> 
            args 
            |> List.map foldRaw 
            |> List.fold Lineage.combine (Exact Set.empty)
        | RLit _ -> Exact Set.empty
        | RRaw(_, lin) -> lin

    let fieldLineage (f: FieldSpec<'row>) : Lineage =
        foldRaw f.Expr

module CompileOkf =
    let compileBundle (spec: TableSpec) : string =
        let sb = System.Text.StringBuilder()
        sb.AppendLine($"# OKF Bundle for {spec.Index}") |> ignore
        sb.AppendLine($"Source: {spec.Source}") |> ignore
        sb.AppendLine("## Fields") |> ignore
        for f in spec.Fields do
            let linStr =
                match LineageOf.fieldLineage f with
                | Exact s -> $"Exact {s}"
                | Declared s -> $"Declared {s}"
                | Opaque -> "Opaque"
            sb.AppendLine($"- **{f.Target}**: {f.EsType} (Lineage: {linStr})") |> ignore
        sb.ToString()
