# Canonflow Overall Vision

Canonflow is the umbrella platform for trustworthy search and semantic data products.

```text
Canonflow
  Symphony -> brutal F# compiler core
  Helios   -> workbench, query, catalog, and product surface
```

The direction has now sharpened into a concrete MVP path:

```text
SQLite miniature first
  -> prove the unified compiler pipeline cheaply
  -> repeat the same path with Oracle end-to-end
  -> generate governed Elasticsearch read models
  -> emit evidence, docs, catalog, quality, contracts
  -> export portable domain/model contracts to other languages
```

The short version:

```text
Brownfield relational truth or greenfield F# domain truth
  -> SourceCatalog / DomainIR
  -> ProjectionSpec
  -> TSV / DuckDB / ETL staging path
  -> Elasticsearch mappings and documents
  -> typed query DSL, catalog, docs, quality, contracts
  -> TypeScript / JavaScript / Kotlin / Swift / C# consumer models
```

The product idea is not only "move data to Elasticsearch." The deeper idea is to make every derived serving index explainable, testable, reproducible, governable, and consumable across languages.

## The North Star

One typed source of truth should produce many outputs:

- Elasticsearch mappings.
- Bulk load files.
- Query DSL schema handles.
- OpenMetadata-style entities.
- OKF or local Markdown catalog pages.
- Quality checks.
- Data contracts.
- Lineage graphs.
- Test cases.
- Human-readable docs.
- Polyglot domain/model exports.
- C# OneOf or sealed-record adapters.
- Future RDF/JSON-LD/SHACL/PROV-O semantic graph exports.

This keeps the project from becoming a collection of disconnected integrations. The "score" is the typed spec. Each generated artifact is a performance of that score.

## Product Shape

Symphony is the governed projection/compiler engine:

- Harvest source schemas and constraints.
- Build `SourceCatalog`, `DomainIR`, and `ProjectionSpec` artifacts.
- Stage extracts through transparent TSV and DuckDB paths.
- Generate Elasticsearch mapping and bulk artifacts.
- Emit lineage, quality, contract, and catalog metadata.
- Validate generated artifacts against live Elasticsearch.
- Prepare Oracle batch first, then CDC paths.

Helios is the exploratory product and library platform:

- Type-safe Elasticsearch query DSL in F#.
- REST API and frontend proof points.
- Semantic model artifacts.
- Catalog-driven UI/provider validation.
- Quality rules and run ledgers.
- Future user-facing search/analytics workbench.
- Polyglot generated client contracts.

Together they point to a unified system:

```text
Canonflow uses Symphony to build and prove the serving surface.
Canonflow uses Helios to let humans and applications query, understand, and evolve it.
```

## Design Principles

- Keep the core pure: types, specs, expressions, folds, and validation rules.
- Put I/O at the shell: Oracle, SQLite, DuckDB, Elasticsearch, files, Kafka, APIs.
- Keep the compiler core brutally idiomatic F#.
- Do not weaken the core for C# compatibility; generate C# adapters at the edge.
- Use SQLite as the scale model, not as a separate architecture.
- Make Oracle repeat the same path with stronger source truth and operational evidence.
- Prefer generated correctness over hand-written JSON.
- Make lineage honest: Exact, Declared, Opaque.
- Make constraint enforcement explicit: Prevented, Inherited, Detected.
- Make scale a design constraint now, even if MVP data is small.
- Keep OpenMetadata and OKF as exports, not the internal source of truth.
- Treat documentation as a product surface, not an afterthought.

## What SOTA Means Here

State of the art for this repository means:

- Type-driven F# modeling instead of runtime-only validation.
- Deterministic, replayable, content-addressed data movement.
- Compile-time and property-test protection for query construction.
- Provenance by construction wherever possible.
- Coverage dials for lineage, constraints, and lossiness.
- Alias-based Elasticsearch lifecycle and rollback.
- Run evidence captured as structured data.
- Human-readable docs generated from the same source as machine artifacts.
- A portable domain IR that emits model/contracts for multiple languages.

## Current MVP Bet

The MVP should be one repeatable compiler loop:

```text
harvest
  -> compile
  -> extract
  -> stage as TSV
  -> load/query in DuckDB
  -> project documents
  -> write Elasticsearch bulk
  -> validate
  -> emit run ledger/docs/catalog
  -> export client models
```

SQLite proves the loop. Oracle proves the loop matters.
