# Symphony

Symphony is a typed metadata and projection system for building trustworthy search
surfaces from relational truth.

The current MVP starts with Northwind SQLite and Elasticsearch, but the intended
production direction is Oracle to Elasticsearch:

```text
Source database truth
  -> typed F# spec
  -> constraints and refinements
  -> Elasticsearch mapping and bulk/load artifacts
  -> lineage, quality, contracts, catalog metadata
  -> OpenMetadata/OKF/semantic exports
```

The guiding idea is:

> One score, many performances.

The typed F# spec is the score. Elasticsearch mappings, bulk files, OKF docs,
OpenMetadata-compatible metadata, lineage graphs, validation checks, and future RDF/JSON-LD
exports are all performances of that same score.

## Why Symphony Exists

Elasticsearch is an excellent read surface, but it does not naturally enforce the same
rules as a relational source system. Oracle or SQLite can have primary keys, nullability,
foreign keys, check constraints, precision rules, and transactional semantics. Elasticsearch
mostly gives us fast indexed documents.

Symphony exists to close that gap:

- Carry source constraints into F# types and runtime checks.
- Generate strict Elasticsearch mappings instead of hand-writing drift-prone JSON.
- Produce deterministic bulk artifacts with stable document identity.
- Track field-level lineage from source columns to target fields.
- Turn constraints into quality checks and future data contracts.
- Emit catalog metadata so the projection is governable, not just operational.

## Current MVP

The current working slice is:

```text
Northwind SQLite
  -> DuckDB staging
  -> order-line Elasticsearch documents
  -> strict ES 8/9-compatible mapping
  -> chunked bulk NDJSON
  -> OKF/catalog lineage
  -> local ES 8 validation
```

Generated artifacts live under:

```text
Symphony/output/
  mapping.json
  catalog.md
  bulk-manifest.json
  bulk/
    order-lines-0001.ndjson
    ...
```

The generated order-line projection currently emits 609,283 documents split into
50 MiB bulk chunks. The smaller chunk budget is intentional: the first ES 8 live test
rejected larger requests because they crossed the coordinating-operation byte limit.

## What Works Today

- `Bridge.Spec` contains the core typed model: columns, expressions, lineage grades,
  Elasticsearch field types, field specs, table specs, and `Refined<'T,'P>`.
- `SqlHydra.Source` is embedded and modified so SQLite schema information can generate
  stronger F# types.
- SQLite primary keys and simple `CHECK` constraints can become F# refined types such as
  `Refined<decimal, GreaterThanOrEqualToZero>`.
- `Bridge.Folds` emits strict Elasticsearch mappings and OKF-style field lineage from the spec.
- `Bridge.Cli` extracts Northwind order-line data through DuckDB and generates Elasticsearch
  artifacts.
- `validate-elasticsearch.ps1` validates generated mapping and bulk chunks against an
  Elasticsearch endpoint.
- A local Elasticsearch 8.19.17 Docker container was tested successfully on
  `http://localhost:9208`.

Validation result from the current ES 8 test:

```text
Version:      8.19.17
Documents:    609283
BulkChunks:   6
StrictReject: True
```

## Architecture

### Core

The pure core should own descriptions, not effects:

- Source/target fields
- Transform expressions
- Lineage grades: `Exact`, `Declared`, `Opaque`
- Constraint grades: future `Prevented`, `Inherited`, `Detected`
- Lossiness grades
- Mapping specs
- Quality and contract definitions

### Folds

Every output should be a fold over the same spec:

- `compileEs` -> Elasticsearch mapping
- `lineageOf` -> field dependency graph
- `emitOkf` -> human-readable catalog docs
- future `emitOpenMetadata` -> OpenMetadata-compatible JSON bundle
- future `emitQuality` -> generated test suites/test cases
- future `emitContract` -> serving data contract
- future `emitSemanticGraph` -> JSON-LD/RDF/SHACL/PROV-O

### Shell

The shell owns I/O:

- DuckDB/SQLite extraction
- Future Oracle extraction
- Elasticsearch validation/load
- File emission
- Docker/local validation scripts
- Future catalog API push

## Project Layout

```text
Symphony/
  Bridge.Spec/          typed core model and generated Northwind records
  Bridge.Folds/         folds from spec to mapping/catalog/lineage artifacts
  Bridge.Cli/           local artifact generator and DuckDB extraction runner
  SqlHydra.DuckDb/      DuckDB schema helper spike
  SqlHydra.Source/      embedded modified SqlHydra source
  output/               generated ES/OKF artifacts

docs/                   static documentation site notes/assets
references/
  oracle-es-bridge-comprehensive-plan.md
  symphony-openmetadata-alignment.md
  helios/               reference implementation and ES/DSL material
  ai-skills/            F#/ETL/reference skills and notes
```

## OpenMetadata Alignment

OpenMetadata Standards gives Symphony an external vocabulary for catalog, quality,
lineage, contracts, governance, teams, events, and semantic export.

Symphony should not replace its typed F# spec with OpenMetadata schemas. Instead:

```text
Symphony typed spec
  -> OpenMetadata-compatible bundle
```

Initial OpenMetadata-aligned entities:

- `DatabaseService`
- `Database`
- `DatabaseSchema`
- `Table`
- `Column`
- `SearchService`
- `SearchIndex`
- `Pipeline`
- `Task`
- `Lineage`
- `TestSuite`
- `TestCase`
- `DataContract`

See:

[references/symphony-openmetadata-alignment.md](references/symphony-openmetadata-alignment.md)

## Elasticsearch

Current target:

- Elasticsearch 8.x: tested with Docker image `docker.elastic.co/elasticsearch/elasticsearch:8.19.17`
- Elasticsearch 9.x: planned, same artifact contract should be validated next

The generated mapping uses:

- `dynamic: "strict"`
- explicit field mappings
- nested object structures for customer, employee, and product
- text fields with `.keyword` subfields
- alias-oriented bulk actions

Run local ES 8:

```powershell
docker run -d --name symphony-es8 `
  -p 9208:9200 `
  --env discovery.type=single-node `
  --env xpack.security.enabled=false `
  --env "ES_JAVA_OPTS=-Xms1g -Xmx1g" `
  -m 2g `
  docker.elastic.co/elasticsearch/elasticsearch:8.19.17
```

Validate generated artifacts:

```powershell
pwsh -NoProfile -File .\Symphony\validate-elasticsearch.ps1 `
  -ElasticsearchUrl http://localhost:9208
```

## Build And Generate

Build:

```powershell
dotnet build .\Symphony\Symphony.slnx --no-restore
```

Generate Elasticsearch and catalog artifacts:

```powershell
dotnet run --project .\Symphony\Bridge.Cli\Bridge.Cli.fsproj
```

Regenerate SqlHydra schema models:

```powershell
Push-Location .\Symphony\Bridge.Spec
dotnet run --project ..\SqlHydra.Source\src\SqlHydra.Cli\SqlHydra.Cli.fsproj --framework net8.0 -- sqlite
Pop-Location
```

## Known Warnings

- Builds currently report a high-severity advisory for `SQLitePCLRaw.lib.e_sqlite3`
  2.1.11 through the dependency graph. This needs dependency remediation.
- `SqlHydra.Source` is embedded and patched. That gives deep control, but it also means
  upstream SqlHydra fixes must be merged manually.
- The current SQLite `CHECK` handling is still too string-matching-heavy. It needs a closed
  constraint model.

## TODO

### Immediate

- Validate the same generated mapping and bulk chunks against Elasticsearch 9.x.
- Add a repeatable Docker script or compose file for ES 8 and ES 9 local validation.
- Move ES version/container details into a small documented test matrix.
- Fix or suppress the `SQLitePCLRaw.lib_e_sqlite3` dependency advisory properly.
- Add generated artifact sanity tests: mapping parses, bulk chunks end in newline, chunk
  sizes stay under budget, and action/source pairs are balanced.

### Spec And Lineage

- Remove remaining stringly areas from `TableSpec`, `FieldSpec`, and `RefineTag`.
- Make computed fields like `lineSales` first-class expressions where possible, not only
  declared raw expressions.
- Add coverage reporting: exact/declared/opaque lineage percentages.
- Fail the MVP build if any serving-index field has `Opaque` lineage.
- Track lossiness explicitly for numeric precision, timestamps, and binary/blob mappings.

### Constraint Harvesting

- Replace SQLite `CHECK` substring matching with a closed `CheckPred` model.
- Support string constraints: max length, non-empty, prefix, pattern/regex where safe.
- Support date/time boundary checks.
- Represent multi-column constraints as declared/detected instead of pretending they are
  single-column refinements.
- Add Oracle constraint harvesting for `ALL_CONSTRAINTS` and `ALL_CONS_COLUMNS`.

### Elasticsearch

- Add alias lifecycle helpers: create concrete index, attach write/read alias, validate,
  swap, rollback.
- Add generated smoke queries: term, match, range, aggregation.
- Capture validator output as structured run metadata.
- Add index version/spec hash into mapping `_meta`.
- Decide whether production writes should always use `require_alias=true`.

### Quality And Contracts

- Generate `TestSuite` and `TestCase` artifacts from constraints.
- Add quality checks for current Northwind order-line projection:
  `id` uniqueness, required fields, non-negative prices, positive quantities, discount
  range, source-vs-index document count.
- Generate a `DataContract` for `northwind_order_lines_alias`.
- Add freshness and SLA fields once Oracle/CDC is introduced.

### OpenMetadata And Catalog

- Emit the first OpenMetadata-compatible JSON bundle under
  `Symphony/output/openmetadata/`.
- Validate emitted bundle against OpenMetadata Standards JSON schemas.
- Keep OpenMetadata as an export target first; add an API sink later.
- Preserve OKF/Markdown output for human-readable local review.
- Consider a shared intermediate catalog model only after the first OMS bundle lands.

### Oracle Path

- After SQLite MVP is stable, import the same Northwind-style shape into Oracle.
- Replace SQLite/DuckDB snapshot assumptions with Oracle flashback/SCN concepts.
- Add Oracle type fidelity rules: NUMBER precision, DATE/TIMESTAMP/TZ, CLOB/BLOB.
- Add SCN-stamped `BulkOp` versioning and tombstones.
- Plan CDC with GoldenGate/Kafka only after the batch path and contract path are proven.

### Scale

- Avoid full in-memory materialization for billion-row paths.
- Keep bulk generation streaming and byte-budgeted.
- Use DuckDB only as staging/diff where appropriate, not as an accidental bottleneck.
- Add checkpoint/resume manifests.
- Add metrics for rows read, docs emitted, bytes written, chunks loaded, failures, retries.

### Governance

- Add owner/team metadata.
- Add PII/classification tags.
- Decide coverage gates: fail vs report for declared, opaque, detected, and lossy fields.
- Add spec diff classification: additive vs breaking.
- Document review rules for schema/spec changes.

## Design References

- [Oracle to Elasticsearch comprehensive plan](references/oracle-es-bridge-comprehensive-plan.md)
- [Symphony and OpenMetadata Standards alignment](references/symphony-openmetadata-alignment.md)
- [Helios reference material](references/helios)

## License

This project is licensed under the Apache License 2.0. See [LICENSE](LICENSE).
