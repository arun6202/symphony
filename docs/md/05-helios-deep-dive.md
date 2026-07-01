# Helios Deep Dive

Helios is a reference implementation and design laboratory for the richer product surface around Symphony.

It contains:

- `Elastic.FSharp.Query` - type-safe F# Elasticsearch query DSL.
- `Elastic.FSharp.Query.Tests` - unit, serialization, property, nested, aggregation, and edge tests.
- `PlatformApi` - API layer for query providers and catalog.
- `Frontend` - Fable/Elmish UI.
- `SharedDomain` - DTO and domain-sharing layer.
- `DataSync` - SQLite to Elasticsearch ingestion reference.
- `semantic-models` - OSI-aligned domain artifacts.
- `quality-rules` - governance and reconciliation rules.
- `instructions` - agent/workflow/rule material.
- `output/reference` - generated fsdocs for the Elastic query library.

## What Helios Teaches Symphony

Helios shows what the serving side wants from the projection engine:

- Strong field kind information.
- Stable document schemas.
- Semantic field names.
- Provider-independent query intent.
- Catalog-backed UI metadata.
- Testable lowering from logical query to Elasticsearch JSON.
- Golden samples and quality evidence.

Symphony should therefore emit enough metadata for Helios to generate or validate:

- F# field handles.
- Query schema marker types.
- Text vs keyword vs numeric vs date capabilities.
- Nested path metadata.
- Metric definitions.
- Human labels, descriptions, synonyms, and ownership.

## Elastic F# Query DSL

Helios currently uses phantom field kinds:

- `Keyword`
- `Text`
- `TextWithKeyword`
- `Date`
- `Numeric`
- `Bool`
- `Nested`
- `EdgeNgram`
- `SearchAsYouType`

This is exactly the direction a serious Elasticsearch authoring layer should take. Elasticsearch's JSON surface is too permissive. The F# API should make common ES mistakes hard or impossible:

- Term query on analyzed text.
- Range query on text.
- Aggregation on non-aggregatable fields.
- Nested cross-object contamination.
- Missing `minimum_should_match` semantics.
- Date math as unvalidated strings.
- Unit mismatch for measurements.

## API and Frontend Direction

The API should remain provider-driven:

```text
ClientPredicate / ClientAggregation
  -> provider compiler
  -> Elasticsearch, SQLite, or future engines
```

The frontend should not care whether a field is backed by SQLite, Elasticsearch, or Oracle-derived documents. It should consume domain and field capability metadata.

## Semantic Catalog Direction

The OSI notes are important:

```text
semantic-models/
  -> catalog loader
  -> DomainConfig
  -> UI + provider validation
```

Business meaning should live in artifacts, not scattered F# pattern matches.

Recommended future integration:

```text
Symphony TableSpec
  -> semantic model seed
  -> human enriches labels, owners, metrics, synonyms
  -> Helios loads catalog
  -> API and frontend become catalog-driven
```

## Helios Gaps

- Some DSL lowering paths still use `failwith`.
- Compile-time invariants are partially modeled but need stricter field-specific APIs.
- Negative compilation tests are not yet first-class.
- Semantic catalog unit tests are incomplete.
- Runtime provider errors need a unified typed error model.
- Generated query docs are present but should be connected to Symphony output.

## Helios Product Potential

Helios can become:

- A search workbench for generated serving indices.
- A semantic catalog browser.
- A quality and lineage explorer.
- A test case authoring surface.
- A query DSL playground with live ES validation.
- A handoff console for product, data, and engineering conversations.

