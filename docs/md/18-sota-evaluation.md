# SOTA Evaluation: How This Fares

The core idea fares well because it sits between categories that are usually separate:

```text
database schema intelligence
  + functional domain modeling
  + Elasticsearch projection
  + lineage and catalog
  + quality and contract generation
  + human-readable documentation
```

Most tools are strong in one or two of those areas. Symphony and Helios become interesting if they connect all of them through one typed spec and one evidence loop.

## The Honest Category

Do not position this as only:

- An ETL tool.
- An ORM.
- A query DSL.
- A metadata catalog.
- A data quality tool.
- A CDC pipeline.
- A documentation generator.

The stronger category is:

> A type-driven data product compiler for governed search and semantic read models.

That phrase is worth protecting. It makes clear that the platform is about compilation, evidence, and governed read surfaces.

## Compared With Common Tool Families

### Against ORMs

ORMs help applications read and write tables. Symphony is different:

- It treats the database as a source of constraints and evidence.
- It compiles projections, mappings, catalogs, and tests.
- It is focused on trustworthy read models, not transactional app persistence.

ORMs usually stop at application data access. Symphony should continue into lineage, quality, and serving contracts.

### Against ETL/ELT Tools

ETL tools move and transform data. Symphony should do more:

- Make field lineage first-class.
- Preserve type and constraint intent.
- Generate Elasticsearch mappings and query handles.
- Emit testable contracts and documentation.
- Classify lossiness and confidence.

ETL says "the data moved." Symphony should say "the data moved, here is what it means, here is the proof, here is the contract, and here is how to query it safely."

### Against dbt-Style Modeling

dbt-style modeling is strong for SQL transformation, documentation, and tests. Symphony's angle is different:

- Strong F# type system.
- Non-SQL target surfaces like Elasticsearch.
- Constraint witnesses and projection specs.
- Search-index lifecycle and typed query DSL.
- Brownfield database-first plus greenfield domain-first ingress.

The lesson to borrow is not SQL. The lesson is the developer experience: lineage graph, docs, tests, diffs, and reviewable models.

### Against Metadata Catalogs

Catalogs describe assets. Symphony should generate catalog evidence from executable specs.

The distinction:

- Catalog-first: humans document what exists.
- Symphony-first: typed specs generate artifacts; humans enrich meaning and ownership.

This is stronger because docs and metadata are tied to the build and validation loop.

### Against Elasticsearch Client Libraries

Official clients are good for transport and admin APIs. Helios should own the safer authoring layer:

- Field-kind-aware predicates.
- Nested-safe query construction.
- Query/filter separation.
- Date math and analyzer safety.
- Golden tests and `_validate/query` checks.

The correct move is layered, not replacement-oriented:

```text
Helios typed query DSL
  -> ES JSON
  -> official client transport
```

### Against CDC Platforms

CDC platforms move events. They do not decide what a denormalized search document means.

Symphony's value is the semantic projection layer:

- Which source changes affect which documents?
- What is historical versus current?
- What is the version guard?
- What is a tombstone?
- What gets reconciled?

Debezium or GoldenGate can feed the stream. Symphony owns the document semantics.

## Current Maturity Score

| Axis | Current | Target |
|---|---:|---:|
| Typed projection core | 6/10 | 9/10 |
| Elasticsearch artifact generation | 7/10 | 9/10 |
| OpenMetadata/OKF emission | 5/10 | 8/10 |
| Quality evidence | 3/10 | 9/10 |
| Oracle production readiness | 2/10 | 8/10 |
| Streaming/CDC readiness | 1/10 | 7/10 |
| Helios query DSL readiness | 4/10 | 8/10 |
| Human product surface | 3/10 | 8/10 |

The shape is strong. The proof loop is still young.

## Best Strategic Wedge

The wedge should be:

> Turn an existing relational system into a governed Elasticsearch search surface with generated mappings, lineage, quality checks, contracts, and docs.

That is specific enough to build and valuable enough to matter.

Greenfield DDD support becomes the second entry point, not the first sales pitch.

