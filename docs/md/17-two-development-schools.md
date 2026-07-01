# Two Development Schools: Database-First And Functional DDD

Symphony and Helios should support two legitimate ways of building software:

1. Brownfield database-first development.
2. Greenfield functional domain-driven development.

The mistake would be choosing only one. Enterprise reality needs both.

## School 1: Brownfield Database-First

This is the common enterprise world:

```text
Existing Oracle / SQL Server / SQLite database
  -> tables, columns, constraints, comments, indexes
  -> generated F# types
  -> projection spec
  -> Elasticsearch and catalog artifacts
```

In this mode, the database is not just storage. It is the historical source of truth, often carrying years of business decisions:

- Primary keys and foreign keys.
- Check constraints.
- Nullability.
- Numeric precision and scale.
- Stored-procedure conventions.
- Table and column comments.
- Reporting views.
- Legacy naming and edge cases.

The job is not to pretend the database is clean. The job is to harvest it honestly, turn what is knowable into types, and make the unknown visible.

### Brownfield Strengths

- Fast path to real production data.
- Existing constraints can become generated evidence.
- Easier stakeholder trust because source truth already exists.
- Good fit for Oracle-to-Elasticsearch projection.
- Supports migration, modernization, and search enablement.

### Brownfield Risks

- Database constraints may be incomplete or misleading.
- Stored procedures and ad hoc SQL may hide business rules.
- Names may not match domain language.
- Nullability and type fidelity can be tricky.
- Generated models can become anemic if not enriched.

### Symphony Role

For brownfield, Symphony should be a harvester and truth-preserving compiler:

```text
DDL + data dictionary + comments + constraints
  -> source model
  -> typed F# witnesses
  -> projection specs
  -> lineage, quality, contracts, catalog, search index
```

The internal policy should be:

- Preserve source facts.
- Classify confidence.
- Generate what can be generated.
- Ask humans to enrich what the database cannot explain.

## School 2: Greenfield Functional DDD

This is the functional-first world:

```text
Domain language
  -> bounded contexts
  -> records, discriminated unions, constrained types
  -> workflows as functions
  -> persistence and search projections
```

In this mode, the model starts with the business, not the database. You design illegal states out of existence with F# types before choosing tables or indices.

Examples:

```fsharp
type OrderLine =
    { ProductId: ProductId
      Quantity: PositiveQuantity
      UnitPrice: NonNegativeMoney
      Discount: DiscountRate }

type OrderStatus =
    | Draft
    | Submitted of SubmittedAt: Instant
    | Fulfilled of FulfilledAt: Instant
    | Cancelled of CancelledAt: Instant * Reason: CancellationReason
```

The database becomes one boundary among many. DTOs translate between persistence shape and domain shape. Search documents are projections, not the core model.

### Greenfield Strengths

- Domain language is clean and explicit.
- Business workflows are easier to reason about.
- Illegal states are harder to represent.
- Tests can target pure functions.
- Persistence choices stay flexible longer.

### Greenfield Risks

- Can ignore operational realities too long.
- Can over-model before learning the domain.
- Database schema may lag behind domain needs.
- Integration with legacy systems becomes a boundary problem.
- Search and reporting projections can be forgotten until late.

### Symphony Role

For greenfield, Symphony should compile from domain intent toward persistence and search:

```text
Domain model + workflow outputs + projection declarations
  -> persistence DTOs
  -> search document specs
  -> generated mappings, quality, contracts, and docs
```

The internal policy should be:

- Keep domain pure.
- Put DTOs at boundaries.
- Generate search projections explicitly.
- Make read models first-class.

## The Unifying Move

Both schools should meet at the same intermediate model:

```text
                 Brownfield database-first
                 DDL / constraints / comments
                           |
                           v
Domain model  ->  Symphony typed spec  ->  Elasticsearch / OpenMetadata / OKF / tests
                           ^
                           |
             Greenfield functional DDD
             DUs / records / workflows
```

The typed spec is the bridge.

Brownfield starts from what exists.

Greenfield starts from what should exist.

Both produce governed projections and executable evidence.

## Recommended Product Positioning

Symphony should say:

> We support both database-first modernization and greenfield functional domain modeling. Either way, the output is a typed, governed, testable data product.

This matters because teams are mixed. A serious platform must meet them where they are:

- Legacy Oracle teams need harvesting and safety.
- New F# teams need domain-first modeling.
- Product teams need semantic language and docs.
- Data teams need lineage and quality.
- Search teams need mappings and operational runbooks.

## Design Rule

Do not let database-first collapse the domain into tables.

Do not let domain-first ignore the database.

The platform should make the translation explicit.

## Practical Architecture

Add two ingress paths:

### Ingress A: Database-First

```text
Oracle harvester
  -> SourceCatalog
  -> generated F# source types
  -> generated draft projection spec
  -> human enrichment
  -> compiled artifacts
```

### Ingress B: Domain-First

```text
F# bounded context
  -> domain events / read-model declarations
  -> projection spec
  -> persistence/search adapters
  -> compiled artifacts
```

Shared outputs:

- Elasticsearch mapping.
- Bulk/load pipeline.
- Query schema handles.
- OpenMetadata bundle.
- OKF docs.
- Quality tests.
- Contract.
- Run ledger.

## What To Build Next

Short-term:

- Document which current Symphony artifacts are database-first.
- Add a sample greenfield bounded context in docs only.
- Define `SourceCatalog` and `DomainProjection` as separate concepts.
- Keep `TableSpec` as the current MVP, but plan a more general `ProjectionSpec`.

Medium-term:

- Add Oracle harvester for brownfield.
- Add domain-first projection examples for greenfield.
- Generate semantic catalog seeds from both.

Long-term:

- Let teams choose an entry point:
  - "Harvest my database."
  - "Model my domain."
  - "Project this domain to search."
  - "Explain and test this existing index."

