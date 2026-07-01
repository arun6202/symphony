# Canonflow Human Handoff

## One Paragraph

Canonflow is becoming a type-driven data product compiler. Symphony is the brutal F# compiler core. Helios is the human/product/query surface. The current Northwind SQLite slice is the miniature: it already generates strict Elasticsearch mappings, bulk chunks, lineage, OKF docs, and OpenMetadata-style draft output. The new MVP direction is to reshape that miniature into the future production pipeline: `SourceCatalog -> ProjectionSpec -> TSV -> DuckDB -> ETL -> Elasticsearch -> validation -> run ledger -> docs/catalog -> polyglot model export`. Oracle should then repeat the same path end-to-end.

## What To Read First

- `README.md`
- `birds-eye.md`
- `docs/md/01-vision.md`
- `docs/md/23-new-mvp-direction.md`
- `docs/md/26-unified-codebase-architecture.md`
- `docs/md/24-oracle-tsv-duckdb-etl-elasticsearch.md`
- `docs/md/25-polyglot-domain-export.md`
- `docs/md/28-brutal-fsharp-core-csharp-oneof.md`
- `docs/md/29-canonflow-brand.md`
- `docs/md/03-unified-architecture.md`
- `docs/md/04-symphony-deep-dive.md`
- `docs/md/05-helios-deep-dive.md`
- `references/oracle-es-bridge-comprehensive-plan.md`

## Current Code Anchors

- `Symphony/Bridge.Spec/Spec.fs`
- `Symphony/Bridge.Folds/Folds.fs`
- `Symphony/Bridge.Cli/Program.fs`
- `Symphony/validate-elasticsearch.ps1`
- `references/helios/Elastic.FSharp.Query`
- `references/helios/PlatformApi`
- `references/helios/Frontend`
- `references/helios/semantic-models`

## Best Next Engineering Slice

Implement the SQLite miniature pipeline shape without changing the business projection yet:

- Add `SourceCatalog` and `ProjectionSpec` draft types.
- Emit a SQLite/Northwind source catalog artifact.
- Add typed TSV staging and a TSV manifest.
- Load staged TSV into DuckDB before projection.
- Emit a run ledger tying source catalog, projection spec, mapping, bulk manifest, and validation.

In parallel, keep artifact tests for the current generated output:

- Mapping JSON parses.
- Dynamic strict is present.
- Bulk chunks are valid NDJSON action/source pairs.
- Manifest count equals generated documents.
- OpenMetadata bundle has expected files.
- `Opaque` lineage is blocked.

This gives the team confidence before bigger Oracle, polyglot export, and CDC work.

## Questions To Ask The Owner

- Is OpenMetadata an eventual API integration or mainly a compatible export?
- Is the first production source definitely Oracle?
- Is TSV the first durable stage for Oracle, with Parquet later?
- What should the first generated TypeScript/C# consumer package include?
- Is CDC required for the first product milestone, or can batch rebuilds serve first?
- Should `Opaque` lineage be banned for all target fields or only governed fields?
- Is Helios intended to become the main UI/product shell?
- Should Propulsion.Net be used only after Debezium emits events, or also for batch pipelines?
