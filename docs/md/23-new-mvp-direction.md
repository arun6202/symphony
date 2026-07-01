# New MVP Direction

The new MVP direction should be:

```text
One unified codebase
  -> SQLite miniature proves every concept cheaply
  -> Oracle end-to-end repeats the same path at production seriousness
```

SQLite is not the product. SQLite is the scale model.

Oracle is not a separate rewrite. Oracle is the same architecture with a stronger source harvester, stronger type fidelity, and operational-grade extraction.

## MVP Thesis

Build one path first:

```text
source schema
  -> source catalog
  -> projection spec
  -> extract/stage
  -> transform/project
  -> Elasticsearch mapping + bulk
  -> validation
  -> catalog/docs/tests/run ledger
```

SQLite proves the path with Northwind.

Oracle proves the path with enterprise source truth.

Greenfield functional DDD and brownfield database-first both feed the same middle:

```text
Brownfield database-first       Greenfield functional DDD
DDL / constraints / comments    DUs / records / workflows
             \                  /
              v                v
              SourceCatalog / DomainSpec
                       |
                       v
                ProjectionSpec
                       |
                       v
       Elasticsearch + docs + tests + contracts + polyglot models
```

## What Changes From The Earlier MVP

Earlier thinking had several promising islands:

- Symphony projection engine.
- Helios query/product layer.
- Oracle plan.
- Elastic F# DSL.
- Semantic catalog.
- Docs.

The new MVP unifies them around a single repeatable path.

The product claim becomes:

> Given a source system or a domain model, generate a governed search/read model with executable evidence and portable client models.

That is stronger than "Oracle to Elasticsearch" and more practical than pure DDD tooling.

## MVP Boundary

The first MVP should include:

- SQLite source catalog.
- Northwind order-line projection.
- TSV staging format.
- DuckDB staging/query step.
- Elasticsearch mapping and bulk generation.
- Validation and run ledger.
- Markdown/HTML documentation output.
- Initial TypeScript model export.

The second MVP repeats the same pipeline with Oracle:

- Oracle source catalog.
- Oracle type fidelity.
- Oracle extract to TSV.
- DuckDB staging.
- Projection.
- Elasticsearch validation.
- Run ledger.

## Why TSV Matters

TSV is not glamorous, but it is useful:

- Human-inspectable.
- Streamable.
- Easy to diff.
- Easy for DuckDB to load.
- Good boundary between source extraction and projection.
- Useful for replay and debugging.

The TSV path gives the pipeline a durable, simple staging artifact before Parquet or direct streaming is introduced.

## What Not To Do Yet

Do not start with:

- Full CDC.
- Full UI workbench.
- Full multi-language business logic transpiler.
- Full OpenMetadata API integration.
- Full Oracle complexity before SQLite path is clean.

The MVP should prove the compiler path before adding platform breadth.

## The Core MVP Loop

```text
harvest
  -> compile
  -> extract
  -> stage
  -> project
  -> bulk
  -> validate
  -> document
  -> export client models
```

Each command should emit evidence.

Each evidence artifact should have a hash.

Each run should be replayable.

