# Operating Model

SOTA is not only architecture. It is also how teams use the system.

## Roles

### Platform Engineer

Owns:

- Symphony compiler.
- CLI and pipelines.
- Elasticsearch lifecycle.
- CI gates.
- Run ledger infrastructure.

### Domain Engineer

Owns:

- Domain model.
- Projection intent.
- Business rules.
- Workflow/event semantics.

### Data Steward

Owns:

- Field descriptions.
- PII classification.
- Owners.
- Glossary terms.
- Semantic enrichment.

### Search/Product Engineer

Owns:

- Search experience.
- Query DSL usage.
- Ranking and relevance.
- Facets, filters, and UI behavior.

### Operator

Owns:

- Load execution.
- Validation review.
- Alias swap.
- Rollback.
- Incident runbooks.

## Review Loop

Every meaningful change should produce a review pack:

```text
spec diff
mapping diff
lineage diff
quality diff
contract diff
risk classification
run instructions
rollback instructions
```

## Change Classes

Classify changes as:

- Safe additive.
- Breaking field removal.
- Breaking field type change.
- Lossiness increase.
- Constraint weakening.
- Lineage confidence decrease.
- Operational-only change.
- Semantic-only change.

## Governance Gates

Suggested gates:

- No Opaque lineage for governed serving fields.
- No unapproved PII field enters Elasticsearch.
- No lossy precision/timezone mapping without approval.
- No alias swap without validation pass.
- No CDC deploy without convergence tests.
- No semantic model publish without owner and description.

## Human Handoff Ritual

Every phase should leave:

- What changed.
- Why it changed.
- How to validate.
- How to roll back.
- What is still risky.
- What questions remain.

This is especially important because this repo is becoming both a product and a thinking environment.

## Documentation Policy

Keep three documentation layers:

- Source docs: generated from specs and run ledgers.
- Design docs: architecture, decisions, risks, roadmaps.
- Human docs: HTML reading surface for brainstorming and onboarding.

Never rely only on prose for facts that can be generated.

## Golden Operating Principle

No silent drift.

If source schema, domain model, projection spec, mapping, catalog, quality, or docs diverge, the system should either regenerate, report, or fail.

