# Open Questions

## Product

1. Is the first real user a data engineer, backend engineer, product analyst, or platform owner?
2. Is Helios the eventual product shell or just a reference implementation?
3. Should the docs optimize for internal engineering, stakeholder demos, or customer-facing explanation?
4. What is the first production data domain after Northwind?

## Architecture

1. Is Oracle definitely the source of truth for the first production path?
2. Should batch rebuild be the first release mode before CDC?
3. Should Parquet be introduced as a staging format, or is direct NDJSON enough for now?
4. Should DuckDB remain staging/diff infrastructure in the production plan?
5. Should `Opaque` be banned everywhere or only in governed fields?

## Metadata

1. Is OpenMetadata a hard target API or a compatibility language?
2. Should OKF remain a first-class local artifact?
3. Who owns semantic model enrichment: engineer, analyst, data steward, or product owner?
4. What PII/classification vocabulary should be used?

## Helios

1. Should the query DSL cover all ES features or a safe subset?
2. Should raw ES be allowed with warnings or banned in governed queries?
3. Should a Lucene/KQL/PPL parser be added early?
4. Should UI fields be generated from Symphony output, semantic models, or both?

## CDC

1. Is Debezium operationally acceptable for Oracle in the target environment?
2. Is Propulsion.Net preferred as the .NET stream-processing layer?
3. What latency is required: seconds, minutes, or batch windows?
4. How should parent changes fan out to denormalized documents?

## Testing

1. Are ES 8 and ES 9 both required in CI?
2. Should OpenMetadata schema validation be a hard gate?
3. What coverage thresholds should fail builds?
4. Should generated docs be tested for link completeness?

