# SOTA Elevation Plan

This is the shortest path from promising architecture to frontier-level platform.

## Level 1: Deterministic Artifacts

Goal: every generation run is repeatable.

Must have:

- Stable spec hash.
- Stable mapping hash.
- Stable bulk manifest.
- Deterministic document IDs.
- Artifact tests.
- Structured validation output.

Exit:

- Two runs on the same input produce byte-stable artifacts or explainable differences.

## Level 2: Evidence-Backed Quality

Goal: every claim has a test or coverage grade.

Must have:

- Generated quality suite.
- Constraint coverage.
- Lineage coverage.
- Lossiness coverage.
- OpenMetadata bundle validation.
- Elasticsearch smoke queries.

Exit:

- A reviewer can see why each field is trusted.

## Level 3: Source And Domain Dual Ingress

Goal: support both development schools.

Must have:

- `SourceCatalog` for database-first.
- `DomainProjection` for DDD-first.
- Shared `ProjectionSpec`.
- Human enrichment workflow.
- Generated semantic catalog seed.

Exit:

- The same compiler can start from Oracle metadata or F# domain declarations.

## Level 4: Operational Search Lifecycle

Goal: production-safe Elasticsearch evolution.

Must have:

- Versioned index creation.
- Alias swap.
- Rollback.
- Reindex planning.
- Spec diff classifier.
- Backfill/resume support.
- Run ledger.

Exit:

- A breaking mapping change can be shipped with a documented rollback path.

## Level 5: Helios Product Surface

Goal: humans can use and improve the generated surface.

Must have:

- Query playground.
- Semantic catalog browser.
- Field trust page.
- Search quality feedback.
- Generated typed query handles.
- API and frontend from catalog metadata.

Exit:

- Users can understand, query, and improve a generated index without reading F# source.

## Level 6: CDC Convergence

Goal: streaming path converges with batch truth.

Must have:

- Debezium or equivalent capture.
- Propulsion.Net or equivalent projector.
- `BulkOp` algebra.
- Source version guard.
- Tombstones.
- Parent-change policy.
- Batch-vs-stream reconciliation.

Exit:

- Stream output and batch rebuild output converge for the same source version.

## Level 7: AI-Assisted Data Product Compiler

Goal: agents help build projections safely.

Must have:

- Machine-readable spec.
- Machine-readable run ledger.
- Generated docs.
- Agent task templates.
- Guardrails for raw SQL/Raw ES.
- Reviewable suggested changes.

Exit:

- An AI agent can propose a projection change, generate artifacts, run tests, and produce a review pack without bypassing governance.

## The Most Important Upgrade

Introduce an explicit `ProjectionSpec` that is more general than today's `TableSpec`.

Suggested conceptual model:

```text
ProjectionSpec
  source inputs
  document grain
  identity policy
  fields
  transforms
  lineage
  constraints
  lossiness
  quality
  semantic metadata
  serving policy
```

This becomes the platform center.

