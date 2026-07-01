# Elastic F# Query Library Direction

The Helios Elastic F# query library should become a typed authoring layer over the official Elasticsearch transport/client.

## Why Build It

The official Elasticsearch .NET client is useful for transport, admin APIs, bulk APIs, auth, retries, and typed response handling. It is not ideal as the highest-level query authoring surface.

A typed F# layer can prevent common Elasticsearch mistakes:

- `term` on analyzed text.
- Range query on text.
- Terms aggregation on text without `.keyword`.
- Nested predicates written outside nested scope.
- Missing query/filter distinction.
- Unsafe raw query strings.
- Invalid date math.
- Unit-of-measure mistakes.

## Two-Layer AST

Use two layers:

```text
Logical query AST
  schema-aware, typed, user-facing

Physical Elasticsearch AST
  close to JSON, renderer-facing
```

The lowering pass is where field kind, analyzer, keyword sub-field, nested path, and request context rules are applied.

## Recommended API Concepts

- `Field<'Schema,'Kind,'Unit>`
- `KeywordField<'Schema>`
- `TextField<'Schema>`
- `TextWithKeywordField<'Schema>`
- `DateField<'Schema>`
- `NumericField<'Schema,'Unit>`
- `NestedField<'Schema,'NestedSchema>`
- `Predicate<'Schema>`
- `Query<'Schema>`
- `Agg<'Schema>`
- `RequestContext`
- `ConstructionError`

## Query Invariants

Encode or test these:

- `Any` always carries `MinShouldMatch`.
- Empty `All` lowers to match-all or is rejected by policy.
- Empty `Any` lowers to match-none or is rejected by policy.
- `Eq` on `TextWithKeyword` lowers to `.keyword`.
- `Eq` on `Text` is either unrepresentable or lowers to phrase by explicit policy.
- `Range` only exists on numeric/date fields.
- Aggregations only exist on aggregatable fields.
- Nested predicates cannot leak out of nested scope.
- Raw ES escape hatch carries a name, reason, and telemetry warning.
- Lowering returns `Result`, not exceptions.

## Tests

Required test families:

- Golden JSON tests for every lowering rule.
- Property tests for flattening, double negation, codec round-trip, no empty bool.
- Negative compilation tests for illegal field operations.
- Integration tests through `_validate/query`.
- Mutation tests on lowering.
- Performance tests for lowering large predicate sets.

## Relationship To Symphony

Symphony should generate schema metadata that can feed this library:

- Field kind.
- Physical path.
- Keyword sub-field availability.
- Nested path tree.
- Analyzer and normalizer names.
- Numeric units where known.
- Schema version marker.

This gives the product a clean loop:

```text
Symphony generated mapping
  -> Helios generated F# field handles
  -> typed query construction
  -> validated ES JSON
```

