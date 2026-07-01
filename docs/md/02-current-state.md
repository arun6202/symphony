# Current State

This repository already has a real vertical slice. The current implementation starts with Northwind SQLite and produces Elasticsearch and metadata artifacts.

The strategic interpretation has shifted:

```text
Current Northwind path = SQLite miniature.
Next MVP target = make this miniature follow the same shape as the future Oracle path.
```

That means introducing explicit `SourceCatalog`, `ProjectionSpec`, TSV staging, DuckDB staging, run ledger, and eventually polyglot export around the existing working slice.

## Working Symphony Slice

Current flow:

```text
Northwind SQLite
  -> DuckDB extraction
  -> typed Symphony spec
  -> strict Elasticsearch mapping
  -> order-line documents
  -> chunked bulk NDJSON
  -> Elasticsearch validation
  -> OKF lineage catalog
  -> OpenMetadata-style draft bundle
```

Target miniature flow:

```text
Northwind SQLite
  -> SQLite SourceCatalog
  -> ProjectionSpec
  -> typed TSV staging
  -> DuckDB load/reconciliation
  -> ETL projection
  -> strict Elasticsearch mapping + bulk
  -> validation
  -> run ledger + docs + catalog
  -> generated TypeScript/C# model adapters
```

Generated artifacts live under `Symphony/output/`:

- `mapping.json`
- `catalog.md`
- `bulk-manifest.json`
- `bulk/order-lines-*.ndjson`
- `openmetadata/database-service.json`
- `openmetadata/database.json`
- `openmetadata/schema.json`
- `openmetadata/tables/*.json`
- `openmetadata/search/*.json`
- `openmetadata/pipelines/*.json`
- `openmetadata/lineage/*.json`
- `openmetadata/quality/*.json`
- `openmetadata/contracts/*.json`

Known current facts from the repo docs:

- 609,283 order-line documents.
- 6 bulk chunks.
- 50 MiB chunk budget.
- Strict Elasticsearch mapping.
- Tested against Elasticsearch 8.19.17 and 9.0.0.
- OpenMetadata draft bundle emits multiple entity categories.
- Lineage blocks Opaque serving fields for the current OpenMetadata MVP.

## Core Projects

`Symphony/Bridge.Spec`

- Owns the current typed model.
- Defines `Column<'row,'value>`.
- Defines typed expression wrapper `Expr<'row,'value>`.
- Defines raw expression cases such as `RCol`, `RConcat`, `RApply`, `RLit`, `RRaw`.
- Defines lineage grades: `Exact`, `Declared`, `Opaque`.
- Defines `Refined<'T,'P>` and predicate witnesses.
- Defines `FieldSpec<'row>` and `TableSpec`.
- Should evolve toward `SourceCatalog`, `DomainIR`, and `ProjectionSpec`.

`Symphony/Bridge.Folds`

- Compiles strict Elasticsearch mappings.
- Computes lineage from raw expressions.
- Emits OKF-style Markdown.
- Emits OpenMetadata-style JSON bundle.
- Computes a simple spec hash and lineage coverage.

`Symphony/Bridge.Cli`

- Builds the Northwind order-line spec.
- Reads data through DuckDB's SQLite extension.
- Writes mapping, catalog, bulk chunks, manifest, and OpenMetadata output.
- Should split into explicit commands: `harvest`, `compile`, `extract`, `stage`, `project`, `validate`, `export`.

`Symphony/validate-elasticsearch.ps1`

- Validates generated mapping and bulk chunks against a live Elasticsearch endpoint.
- Checks count and strict mapping behavior.

## Reference Material Already Present

`references/oracle-es-bridge-comprehensive-plan.md`

- Strong architecture plan for Oracle to Elasticsearch.
- Introduces SCN, CDC, tombstones, alias lifecycle, and coverage gates.

`references/symphony-openmetadata-alignment.md`

- Maps Symphony concepts to OpenMetadata-style entities.

`references/helios`

- Reference implementation and research area for Elastic DSL, API, frontend, semantic catalog, and quality rules.

`references/ai-skills`

- F#, ETL, Oracle, Elasticsearch, and quality guidance that can steer future work.

## Current Gaps

- Constraint parsing is still too string-oriented.
- OpenMetadata output is draft-shaped and needs schema validation.
- Bulk generation currently materializes documents in memory.
- TSV staging and run ledger are not yet first-class.
- `ProjectionSpec` and `DomainIR` are not yet implemented.
- Polyglot model export is documented but not built.
- Oracle harvesting is not yet implemented.
- CDC is architectural, not built.
- Helios query DSL is promising but incomplete and has runtime `failwith` paths.
- The semantic catalog work needs tests, automation, and integration into the main Symphony path.
- Dependency warning exists around `SQLitePCLRaw.lib.e_sqlite3`.
