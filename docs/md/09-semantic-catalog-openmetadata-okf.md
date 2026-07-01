# Semantic Catalog, OpenMetadata, and OKF

Symphony should keep its internal typed spec independent and emit OpenMetadata/OKF/semantic artifacts as outputs.

## Internal Truth

Internal truth:

- Typed F# spec.
- Source harvest.
- Projection rules.
- Constraint model.
- Lineage model.
- Quality model.

OpenMetadata and OKF should not be the source of truth for projection logic. They are consumers and governance surfaces.

## OpenMetadata Export

Current draft entities include:

- `DatabaseService`
- `Database`
- `DatabaseSchema`
- `Table`
- `SearchIndex`
- `Pipeline`
- `Lineage`
- `TestSuite`
- `DataContract`

Next step:

- Validate JSON against OpenMetadata schemas or a stable local compatibility model.
- Separate "draft internal bundle" from "official OpenMetadata API payload".
- Add structured run results.
- Add owners, teams, tags, PII classification, and glossary terms.

## OKF / Markdown Catalog

OKF-style local docs remain valuable even if OpenMetadata integration matures.

Markdown catalog should include:

- Field name.
- Type.
- Required flag.
- Source columns.
- Transform expression.
- Lineage grade.
- Constraint/enforcement grade.
- Lossiness.
- Quality tests.
- Example queries.
- Owner/steward.
- Change history.

## Semantic Models

Helios already points toward OSI-aligned semantic models.

The semantic catalog should answer:

- What does this field mean?
- Which provider fields implement it?
- What UI controls can use it?
- What metrics are available?
- What relationships exist?
- What synonyms help AI and search UX?
- Which tests prove it still works?

## Future Unified Catalog Flow

```text
Symphony spec
  -> generated technical catalog seed
  -> human enrichment
  -> semantic model artifact
  -> Helios catalog loader
  -> API validation
  -> frontend DomainConfig
  -> docs and quality reports
```

## Quality Evidence

Every catalog concept should eventually connect to evidence:

- Row counts.
- Metric reconciliation.
- Golden samples.
- Query validation.
- Lineage coverage.
- Constraint coverage.
- Drift reports.
- Run ledger entries.

