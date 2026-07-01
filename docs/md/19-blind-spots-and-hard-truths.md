# Blind Spots And Hard Truths

This project has a strong conceptual center. The main risks are not in the idea. They are in the hidden operational edges that can make a beautiful design fail in production.

## Blind Spot 1: Denormalized Document Semantics

CDC is not the hard part. Denormalized document correctness is the hard part.

If an order-line document embeds customer, employee, product, and category data, then a single source row change may require many document updates.

You must decide:

- Does a customer name update rewrite historical order documents?
- Is product category current-state or order-time-state?
- Should employee title reflect current title or title at order time?
- Does a deleted parent remove, tombstone, or mark child documents?

These are business semantics. No CDC tool can answer them.

## Blind Spot 2: The Spec Can Become Another Legacy System

If the spec is hand-maintained without a diff/review loop, it can drift just like any other artifact.

Mitigation:

- Source harvest proposes spec changes.
- Humans review semantic changes.
- CI classifies diffs.
- Generated artifacts include spec hash.
- Run ledger records the exact spec used.

## Blind Spot 3: OpenMetadata Can Create False Confidence

Draft metadata can look official before it is validated.

Mitigation:

- Label draft bundles clearly.
- Validate against a compatibility schema.
- Separate internal bundle from API payload.
- Store validation errors as build artifacts.

## Blind Spot 4: Type Safety Does Not Replace Reconciliation

Types can prevent row-level shape errors. They cannot prove global facts in Elasticsearch:

- Foreign keys.
- Secondary uniqueness.
- Cross-document invariants.
- Aggregate totals.
- Late-arriving CDC ordering.

Mitigation:

- Use `Prevented`, `Inherited`, `Detected` grades.
- Generate reconciliation queries.
- Report detected constraints separately from prevented constraints.

## Blind Spot 5: Search Relevance Is A Product Problem

Strict mapping and safe query DSLs do not guarantee good search.

Missing concerns:

- Analyzer selection.
- Synonyms.
- Search-as-you-type.
- Ranking and boosting.
- Facets and aggregations.
- Highlighting.
- Result explainability.
- Query telemetry and zero-result analysis.

Helios should eventually own this product surface.

## Blind Spot 6: Security And PII Are Not Optional

Catalog/docs can leak sensitive meaning even without sample values.

Need:

- PII tags.
- Classification.
- Owner/steward metadata.
- Field-level masking policy.
- Sample-value scrub policy.
- Export controls for docs and metadata.

## Blind Spot 7: Backfills Are Harder Than First Loads

The first successful load is not enough.

You need:

- Resume from failed chunk.
- Idempotent replay.
- Partial reindex.
- Full reindex.
- Versioned alias swap.
- Rollback.
- Tombstone retention.
- Run comparison.

## Blind Spot 8: Query DSL Scope Can Explode

Elasticsearch has a huge API surface. Trying to model all of it early will bury the useful part.

Mitigation:

- Own the safe 80 percent.
- Keep raw escape hatch with name, reason, and warning.
- Use official client for transport/admin.
- Test lowering aggressively.

## Blind Spot 9: Greenfield And Brownfield Need Different UX

Database-first users want:

- Harvest.
- Diff.
- Explain legacy shape.
- Generate draft projections.

Functional DDD users want:

- Model workflow.
- Declare read model.
- Generate persistence/search adapters.

One engine can serve both, but the product entry points should be different.

## Blind Spot 10: Documentation Can Drift Unless Generated

Human-authored docs are useful now. Long-term, critical field docs should be generated from the spec and enriched by humans.

Ideal loop:

```text
spec -> generated docs seed -> human enrichment -> reviewed artifact -> regenerated safely
```

## Hard Truth

The platform becomes SOTA only when it attaches evidence to every claim.

Without evidence, it is an elegant architecture.

With evidence, it becomes a trustworthy data product compiler.

