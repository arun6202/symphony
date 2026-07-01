# Frontier Feature Directions

This is the feature surface that would make Symphony and Helios feel like a serious product rather than a clever repo.

## 1. Projection Workbench

A human-facing UI for building and reviewing projections:

- Source tables and relationships.
- Target document grain.
- Field transforms.
- Constraint confidence.
- Lineage preview.
- Mapping preview.
- Generated test preview.

This is where brownfield and greenfield users meet the same compiler.

## 2. Spec Diff And Review

Every schema/spec change should produce a classified diff:

- Additive.
- Breaking.
- Lossy.
- Metadata-only.
- Operationally risky.
- Requires reindex.
- Requires catalog review.

Output:

- Markdown PR report.
- HTML review page.
- Machine-readable JSON.

## 3. Evidence Graph

Create a graph of claims and proofs:

```text
field exists
  -> generated from spec hash X
  -> source columns A,B
  -> mapping path P
  -> quality tests T1,T2
  -> validation run R
  -> catalog entity C
```

This is more valuable than lineage alone. It answers "why should I trust this field?"

## 4. Run Ledger

Every run should emit a durable record:

- Run ID.
- Source identity.
- SCN or snapshot.
- Spec hash.
- Mapping hash.
- Bulk manifest hash.
- Document count.
- Validation result.
- Alias swap result.
- Quality result.
- Operator or automation identity.

The run ledger becomes the system memory.

## 5. Search Quality Loop

Helios should capture:

- Top queries.
- Zero-result queries.
- Slow queries.
- Low-click queries.
- Manual relevance judgments.
- Suggested synonyms.
- Analyzer experiments.

This turns search into an iterative product, not a static index.

## 6. Query Playground

A page where users can see:

- Human query.
- Typed predicate.
- Lowered Elasticsearch JSON.
- Validation result.
- Response sample.
- Explanation of field choices.

This would make the typed DSL tangible.

## 7. Constraint Coverage Dashboard

Show:

- Prevented constraints.
- Inherited constraints.
- Detected constraints.
- Declared constraints.
- Unsupported constraints.
- Lossy mappings.

The dashboard should make weak spots visible without shame. Visibility is the point.

## 8. Semantic Enrichment Workflow

Generated artifacts need human enrichment:

- Business labels.
- Descriptions.
- Owners.
- PII tags.
- Synonyms.
- Metric definitions.
- Example questions.

Make enrichment reviewable and versioned.

## 9. Replay And Backfill Simulator

Before CDC production:

- Simulate event orderings.
- Simulate duplicate events.
- Simulate parent updates.
- Simulate deletes and late updates.
- Compare stream output to batch rebuild output.

This catches the hardest bugs before production.

## 10. Agent Handoff Pack

The docs can become an agent operating manual:

- Current architecture.
- Current tasks.
- Known risks.
- Test commands.
- Code ownership.
- Safe change patterns.
- Generated diagrams.

This directly supports AI-assisted product building.

