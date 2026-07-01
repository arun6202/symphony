# Brainstorming Backlog

## Product Ideas

- Search index workbench: inspect fields, lineage, mapping, sample docs, and quality status.
- Projection designer: choose source tables, joins, target document grain, and field transforms.
- Quality dashboard: document count, null checks, ranges, FK coverage, reconciliation metrics.
- Catalog browser: semantic models, owners, synonyms, field meanings, source-to-target paths.
- Query playground: write F# DSL, Lucene/KQL-like query, or visual builder and see ES JSON.
- Diff viewer: compare two specs and classify changes as additive, breaking, lossy, or metadata-only.
- Run ledger: every extract/load/validate run with hashes and evidence.
- Test case generator: turn constraints and lineage into test files.

## Engineering Nice-To-Haves

- Argu CLI with subcommands.
- FsCheck properties for core folds.
- Fantomas and analyzers in CI.
- Testcontainers for ES validation.
- OpenTelemetry traces around extraction/load.
- Structured log events with run ID.
- Mermaid diagrams generated from spec.
- JSON schema for internal bundle.
- Static docs generated from the spec.
- Contract diff report in Markdown and HTML.

## Helios Library Ideas

- Schema bridge from Symphony mapping to F# field handles.
- Negative compilation test harness.
- Query optimizer pass.
- Query explain viewer.
- `_validate/query` integration runner.
- KQL or PPL-ish parser frontend.
- Saved query catalog.
- Runtime field support.
- Analyzer/normalizer typed references.
- Units of measure for numeric fields.

## CDC Ideas

- Debezium feasibility matrix for Oracle.
- Propulsion.Net projector spike.
- Local join-state store comparison: RocksDB, SQLite, DuckDB, LiteDB, Tsavorite.
- Parent-change fanout planner.
- Tombstone retention policy.
- Replay simulator.
- Stream lag dashboard.

## Documentation Ideas

- Field reference generated from `TableSpec`.
- Operator runbook.
- Onboarding map.
- Architecture decision records.
- Test case catalog.
- Known pitfalls guide.
- Product glossary.
- Demo script for investors or stakeholders.

