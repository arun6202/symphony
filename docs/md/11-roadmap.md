# Roadmap

## Phase 0 - Documentation And Shared Understanding

Goal: make the project understandable and handoff-ready.

Deliverables:

- Expanded Markdown docs.
- Rich HTML docs.
- Current state summary.
- Integrated architecture.
- Helios deep dive.
- Test and roadmap docs.

Exit:

- A new collaborator can understand the project direction in under one hour.

## Phase 1 - Reframe SQLite As The Miniature

Goal: keep the current Northwind slice working while reshaping it into the same pipeline Oracle will use.

Deliverables:

- `SourceCatalog` draft for SQLite.
- `ProjectionSpec` draft for the Northwind order-line projection.
- Explicit pipeline command vocabulary: harvest, compile, extract, stage, project, validate, export.
- Artifact tests.
- Structured validation output.
- ES 8 and ES 9 validation matrix.
- Output manifest with run ID.
- OpenMetadata draft schema validation strategy.

Exit:

- Running the CLI produces deterministic artifacts with automated checks and a named projection spec.

## Phase 2 - TSV And DuckDB Staging

Goal: make extraction transparent, replayable, and aligned with the future Oracle route.

Deliverables:

- Typed TSV schema.
- TSV manifest and checksums.
- SQLite to TSV extractor.
- DuckDB TSV loader.
- Reconciliation SQL hooks.
- Stage-level run ledger entry.

Exit:

- Northwind data can flow through TSV and DuckDB before Elasticsearch projection.

## Phase 3 - Closed Constraint Model

Goal: replace stringly constraint handling.

Deliverables:

- `CheckPred` AST.
- Constraint parser for the supported subset.
- Refined type witness generation.
- Constraint coverage report.
- Tests for unsupported constraint degradation.

Exit:

- Supported constraints are structured; unsupported constraints are visible.

## Phase 4 - Streaming Projection And Bulk Pipeline

Goal: remove in-memory materialization.

Deliverables:

- Reader-to-bulk streaming pipeline.
- Byte-budgeted chunk writer.
- Structured parse/project errors.
- Checkpoint/resume-ready manifest.
- Metrics and run ledger.

Exit:

- Pipeline can handle large tables without holding all documents in memory.

## Phase 5 - Oracle Harvest And TSV Batch

Goal: move from SQLite to Oracle.

Deliverables:

- Oracle lab source tables.
- Data dictionary harvester.
- Oracle type fidelity map.
- SCN-stamped snapshot.
- Oracle extraction to typed TSV.
- DuckDB staging from Oracle TSV.
- Alias lifecycle validation.

Exit:

- Oracle source data can follow the same TSV/DuckDB/projection path and produce a validated Elasticsearch serving index.

## Phase 6 - Polyglot Domain Export

Goal: turn F# domain and projection truth into safe consumer contracts.

Deliverables:

- `DomainIR` schema.
- TypeScript model export.
- C# sealed-record or OneOf adapter export.
- JSON fixtures and codec tests.
- Export policy for pure rules only.

Exit:

- At least TypeScript and C# consumers can decode, validate, and round-trip generated model fixtures.

## Phase 7 - Helios Query Library Hardening

Goal: make the F# Elastic DSL production-quality.

Deliverables:

- `Result`-based lowering.
- Stronger phantom field APIs.
- Golden JSON tests.
- Negative compilation tests.
- ES validation tests.
- Docs/examples from Symphony-generated mapping.

Exit:

- Helios can query Symphony-generated indices safely.

## Phase 8 - Semantic Catalog Integration

Goal: connect generated technical specs to human/product semantics.

Deliverables:

- Semantic model seed from Symphony.
- Human enrichment workflow.
- Catalog loader tests.
- API schema endpoint from catalog.
- UI field controls from catalog.

Exit:

- Frontend/API no longer rely on hardcoded field lists for the main domain.

## Phase 9 - CDC Prototype

Goal: prove incremental convergence.

Deliverables:

- Debezium feasibility result.
- Propulsion.Net stream processor spike.
- `BulkOp` algebra.
- Version guard.
- CDC convergence tests.

Exit:

- Insert/update/delete events converge to correct Elasticsearch documents.

## Phase 10 - Governance And Productization

Goal: make it usable by a team.

Deliverables:

- Spec diff review.
- Ownership metadata.
- PII and classification tags.
- Quality dashboard.
- Run history.
- Operator runbooks.

Exit:

- Team can safely evolve source schema and serving indices.
