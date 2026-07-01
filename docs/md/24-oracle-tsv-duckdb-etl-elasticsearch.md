# Oracle -> TSV -> DuckDB -> ETL -> Elasticsearch

This path should become the production backbone after the SQLite miniature is proven.

## Pipeline

```text
Oracle
  -> source catalog harvest
  -> SCN-stamped extract
  -> typed TSV files
  -> DuckDB staging
  -> projection ETL
  -> Elasticsearch bulk chunks
  -> validation index
  -> alias swap
  -> run ledger + docs + catalog
```

## Stage 1: Oracle Harvest

Harvest metadata from:

- `ALL_TAB_COLUMNS`
- `ALL_CONSTRAINTS`
- `ALL_CONS_COLUMNS`
- `ALL_IND_COLUMNS`
- `ALL_TAB_COMMENTS`
- `ALL_COL_COMMENTS`

Output:

- `SourceCatalog`
- source table definitions
- source column definitions
- keys and relationships
- check constraints
- comments
- type fidelity notes
- unsupported/unknown rule list

## Stage 2: SCN-Stamps

Every Oracle extract should record:

- source connection identity
- schema/owner
- SCN or snapshot identity
- extract timestamp
- source catalog hash
- query hash
- row counts

This is the basis for replay, audit, and CDC overlap later.

## Stage 3: Typed TSV

TSV files should be more disciplined than loose text dumps.

Each TSV set should include:

- `data/*.tsv`
- `schema/*.json`
- `manifest.json`
- `checksums.json`
- `extract-log.json`

TSV rules:

- UTF-8.
- Header row required.
- Explicit null token policy.
- Explicit date/time format.
- Explicit decimal format.
- Escaping policy documented.
- Row count and byte count recorded.

## Stage 4: DuckDB Staging

DuckDB is the local analytical engine for:

- loading TSVs
- inspecting row counts
- running joins
- building projection queries
- validating reconciliation SQL
- generating intermediate result sets

DuckDB should not become hidden business logic. Projection semantics live in `ProjectionSpec`.

## Stage 5: ETL Projection

The ETL layer should:

- parse staged rows
- apply type/refinement checks
- build target documents
- assign deterministic IDs
- capture field-level lineage
- record rejected rows with reasons
- stream documents to the bulk writer

Avoid full in-memory materialization.

## Stage 6: Elasticsearch Bulk

Generate:

- mapping
- settings
- versioned index name
- bulk chunks
- bulk manifest
- validation smoke queries
- alias swap plan

Every bulk action should be deterministic.

## Stage 7: Validation

Validation should include:

- mapping creation
- bulk load
- document count
- source-to-target count reconciliation
- required-field checks
- strict mapping rejection
- sample document fetch
- generated smoke queries
- quality suite

## Stage 8: Run Ledger

The ledger ties the entire path together:

```text
source catalog hash
  + projection spec hash
  + TSV manifest hash
  + mapping hash
  + bulk manifest hash
  + validation result
  + alias result
```

This is the minimum evidence chain.

## Later Evolution

After TSV is proven, add:

- Parquet staging for large volume and typed columns.
- Direct streaming path for high-throughput loads.
- CDC with Debezium/GoldenGate.
- Batch-vs-stream convergence checks.

TSV is the first durable path because it is transparent and debuggable.

