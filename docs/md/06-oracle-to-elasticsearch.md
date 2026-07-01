# Oracle To Elasticsearch Production Path

The production path is Oracle to Elasticsearch, with Symphony as the correctness and governance layer.

## Why Oracle Changes The Game

SQLite is a good MVP source, but Oracle introduces the enterprise-grade concerns that justify Symphony:

- Rich data dictionary.
- Constraints, comments, indexes, and relationships.
- SCN for consistent snapshots.
- Flashback queries.
- Production-scale table sizes.
- CDC options.
- Type fidelity challenges.
- Governance and ownership needs.

## Batch First

Build batch before CDC.

Recommended batch path:

```text
Oracle AS OF SCN
  -> streamed row read
  -> typed parser/refinement validation
  -> projection document builder
  -> byte-budgeted bulk chunks
  -> versioned Elasticsearch index
  -> validation checks
  -> alias swap
  -> run ledger
```

## Oracle Harvesting

Harvest:

- Tables and columns.
- Nullability.
- Data types, precision, scale, length.
- Primary keys.
- Foreign keys.
- Unique constraints.
- Check constraints.
- Indexes.
- Table comments.
- Column comments.
- Owners and schemas.

Oracle views to start with:

- `ALL_TAB_COLUMNS`
- `ALL_CONSTRAINTS`
- `ALL_CONS_COLUMNS`
- `ALL_IND_COLUMNS`
- `ALL_TAB_COMMENTS`
- `ALL_COL_COMMENTS`

## Type Fidelity

Critical Oracle issues:

- Empty string is null.
- `NUMBER` may exceed .NET primitive ranges.
- `DATE` has time but no time zone.
- `TIMESTAMP WITH TIME ZONE` needs explicit normalization.
- `CLOB` indexing can explode costs.
- `BLOB` should generally become a reference, not indexed bytes.

Recommended lossiness model:

- `Lossless`
- `LossyPrecision`
- `LossyTimezone`
- `BlobRef`
- `TextAnalysisLoss`
- `Unsupported`

## Elasticsearch Lifecycle

Never treat the alias as an implementation detail. It is the serving contract.

```text
northwind_order_lines_v001
  <- load and validate
northwind_order_lines_alias
  <- atomic swap after validation
```

Every load should record:

- Source database and schema.
- SCN or snapshot identity.
- Spec hash.
- Mapping hash.
- Bulk manifest hash.
- Document count.
- Chunk count.
- Bytes written.
- Validation results.
- Alias swap result.
- Rollback target.

## Open Decisions

- Oracle source library: ODP.NET directly, SqlHydra provider extension, or hybrid.
- Batch extract format: direct NDJSON, Parquet staging, or both.
- CDC path: Debezium, GoldenGate, custom polling, or hybrid.
- Constraint policy: fail on unknown CHECKs or report coverage.
- Spec ownership: DBA-generated proposal, app-team review, or platform-team review.

