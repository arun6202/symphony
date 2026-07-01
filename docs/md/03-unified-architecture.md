# Unified Architecture

The combined architecture treats Symphony and Helios as two sides of one product.

The updated center is:

```text
SourceCatalog / DomainIR -> ProjectionSpec -> folds -> evidence-backed outputs
```

SQLite and Oracle are source adapters. Elasticsearch, OpenMetadata, docs, query handles, and polyglot packages are output folds.

```text
                          Human and Product Layer
        docs, catalog, frontend, API, dashboards, search experiences
                                      |
                         Helios query and semantic layer
       typed Elastic DSL, provider compilers, semantic catalog, UI metadata
                                      |
                           Symphony compiler layer
       SourceCatalog, DomainIR, ProjectionSpec, folds, evidence, run ledger
                                      |
                              Source truth layer
       SQLite miniature, Oracle production, future CDC, source constraints, comments
```

## Core Boundary

The pure core should contain:

- Source column witnesses.
- Target field specs.
- Expression algebra.
- Projection specs.
- Source catalog model.
- Domain IR model.
- Constraint model.
- Lineage lattice.
- Lossiness model.
- Enforcement model.
- Folds to mappings, lineage, quality, contracts, catalog, tests.

The pure core should not contain:

- File writes.
- Network calls.
- Database connections.
- Elasticsearch client calls.
- Kafka consumers.
- API controllers.

## Shell Boundary

The shell owns:

- Oracle data dictionary reads.
- SQLite and DuckDB extraction.
- TSV staging.
- Debezium or GoldenGate source events.
- Propulsion.Net stream processing.
- Elasticsearch client calls.
- File emission.
- OpenMetadata API push.
- Web API endpoints.
- Frontend delivery.

## Key Architectural Contract

The same typed spec must drive:

- How data is extracted.
- How documents are shaped.
- How IDs are derived.
- How mappings are generated.
- How quality rules are generated.
- How lineage is emitted.
- How catalog entities are described.
- How query schema handles are generated.
- How polyglot models and validators are generated.
- How run evidence is captured.

If two outputs need the same fact, that fact should live in the spec or a generated semantic artifact, not in two hand-written modules.

## Integrated Flow

```text
1. Choose ingress
   Database-first harvest or greenfield F# domain model.

2. Build common inputs
   `SourceCatalog` for database-first, `DomainIR` for domain-first.

3. Author or generate `ProjectionSpec`
   Business document grain, joins, denormalization, target fields, lineage.

4. Extract and stage
   SQLite/Oracle to typed TSV, DuckDB load, reconciliation checks.

5. Fold into artifacts
   ES mapping, bulk manifest, OpenMetadata, OKF, quality, contract, docs, polyglot models.

6. Load and validate
   Versioned concrete index, bulk load, count checks, strict mapping rejection, alias swap.

7. Query and operate
   Helios typed query DSL, API, frontend, semantic catalog, run ledger.
```

## What Belongs Where

Symphony should own:

- `SourceCatalog`, `DomainIR`, and `ProjectionSpec`.
- Source-to-target lineage.
- TSV/DuckDB staging contracts.
- Generated mappings and bulk files.
- Data quality contracts.
- OpenMetadata and OKF emission.
- Load validation and run evidence.

Helios should own:

- Type-safe query authoring.
- Search and analytics API.
- UI/runtime schema.
- Semantic catalog loading.
- User-facing exploration workflows.
- Query lowering and validation.

Shared domain should own:

- Document DTOs.
- Semantic field names.
- Contract names.
- Run identifiers.
- Schema/version identities.
- Common error shapes.
- Portable model definitions for TypeScript, JavaScript, Kotlin, Swift, and C# adapters.
