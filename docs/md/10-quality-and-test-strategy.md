# Quality And Test Strategy

The test strategy should protect both the platform and the generated artifacts.

## Current Tests To Add Immediately

For Symphony output:

- `mapping.json` parses as JSON.
- Root mapping has `dynamic: strict`.
- All spec fields appear in the mapping.
- Text fields include `.keyword` sub-field where policy requires it.
- Bulk chunks have even action/source line counts.
- Bulk chunks end with a newline.
- Bulk chunks stay below byte budget.
- Manifest document count equals emitted documents.
- OpenMetadata bundle generation fails on `Opaque` serving lineage.
- OpenMetadata bundle includes all expected entity categories.

For CLI extraction:

- Order-line document IDs are deterministic.
- Required fields exist.
- Numeric constraints hold.
- Source row count equals emitted document count.
- `lineSales` calculation is stable.

## Elasticsearch Validation

Generated smoke checks:

- Create versioned validation index.
- Apply mapping.
- Bulk load chunks.
- Count documents.
- Query by ID.
- Term query on keyword field.
- Match query on text field.
- Range query on numeric field.
- Aggregation on category/country.
- Unknown field rejection.
- Cleanup validation index.

Validation output should be JSON so it can feed docs and OpenMetadata artifacts.

## Property Tests

Core properties:

- Lineage combination is associative.
- `Opaque` contaminates combined lineage.
- Exact expression lineage never misses referenced columns.
- Declared raw expression only reports declared dependencies.
- `Refined.create` rejects values outside predicate.
- Deterministic ID function gives same ID for same key.
- Bulk chunker preserves document order.
- Bulk chunker never splits an action/source pair.
- Spec hash changes when field mapping changes.

## Helios Query DSL Tests

Required tests:

- Golden JSON tests for equality, range, bool, text, nested, aggregations.
- Negative compilation tests for illegal operations.
- Property tests for bool flattening and codec round-trip.
- `_validate/query` integration tests.
- Fuzz tests for frontend query parsers if Lucene/KQL/PPL-style parsing is added.

## CDC Tests

CDC cannot be trusted without convergence tests:

- Duplicate events are idempotent.
- Out-of-order events converge.
- Delete followed by older update does not resurrect.
- Snapshot plus stream overlap is safe.
- Parent change updates dependent documents or emits an explicit compensation task.

## Acceptance Gates

Suggested gates:

- No `Opaque` lineage on governed serving fields.
- No lossy numeric/timestamp mapping without explicit approval.
- Strict mapping validation passes on ES 8 and ES 9.
- Quality suite has no critical failures.
- Spec diff classification is reviewed before alias swap.
- Run ledger emitted for every load.

