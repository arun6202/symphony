# Canonflow Documentation Index

Status: expanded handoff and product-design pack
Date: 2026-07-01

This folder captures the current state, future direction, architecture, tests, and open questions for **Canonflow**. Treat it as a working design base, not a final specification.

The current center of gravity is sharper now:

```text
SQLite miniature
  -> unified compiler pipeline
  -> Oracle end-to-end
  -> governed Elasticsearch read model
  -> evidence, docs, catalog, tests
  -> polyglot domain/model export
```

The platform supports both brownfield database-first development and greenfield functional DDD. Both paths converge into a shared `ProjectionSpec`/`DomainIR` compiler core.

Brand model:

```text
Canonflow
  -> Symphony: brutal F# compiler core
  -> Helios: workbench, query, catalog, and product surface
```

## Reading Order

1. `01-vision.md` - overall product and architecture vision.
2. `23-new-mvp-direction.md` - unified SQLite miniature first, then Oracle end-to-end.
3. `26-unified-codebase-architecture.md` - proposed project/module architecture for the new MVP.
4. `24-oracle-tsv-duckdb-etl-elasticsearch.md` - the Oracle to TSV to DuckDB to ETL to Elasticsearch path.
5. `25-polyglot-domain-export.md` - exporting F# domain goodness to TypeScript, JavaScript, Kotlin, Swift, and C# adapters.
6. `28-brutal-fsharp-core-csharp-oneof.md` - keep the compiler core F#-native; generate C# OneOf adapters only at the edge.
7. `27-license-and-oss-strategy.md` - Apache 2.0/MIT posture, enterprise adoption, and contribution rules.
8. `02-current-state.md` - what exists today in this repository.
9. `03-unified-architecture.md` - how Symphony and Helios fit together.
10. `17-two-development-schools.md` - greenfield functional DDD and brownfield database-first development.
11. `04-symphony-deep-dive.md` - current Symphony internals.
12. `05-helios-deep-dive.md` - Helios reference system and library direction.
13. `06-oracle-to-elasticsearch.md` - production target path.
14. `07-cdc-streaming-propulsion-debezium.md` - future CDC runtime thinking.
15. `08-elastic-fsharp-query-library.md` - type-safe query DSL direction.
16. `09-semantic-catalog-openmetadata-okf.md` - catalog, lineage, and metadata.
17. `10-quality-and-test-strategy.md` - tests to add and acceptance gates.
18. `11-roadmap.md` - phased build plan.
19. `12-risk-register.md` - risks and mitigations.
20. `13-human-handoff.md` - concise handoff for a new human or AI collaborator.
21. `18-sota-evaluation.md` - how the idea fares against existing tool categories.
22. `19-blind-spots-and-hard-truths.md` - failure modes and risks that are easy to underweight.
23. `20-frontier-feature-directions.md` - product and platform features worth pursuing.
24. `21-sota-elevation-plan.md` - concrete upgrades that would make the platform frontier-level.
25. `22-operating-model.md` - roles, review loops, evidence, governance, and team workflow.
26. `14-brainstorming-backlog.md` - ideas, nice-to-haves, and product options.
27. `15-open-questions.md` - decisions that should be answered soon.
28. `16-glossary.md` - shared terms.
29. `29-canonflow-brand.md` - umbrella brand, naming model, tagline, and message map.

## HTML Companion

The richer human-reading site lives in `docs/html/`. It is intentionally more visual, with Material 3 inspired cards, diagrams, roadmap bands, and decision surfaces.
