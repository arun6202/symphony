# Risk Register

| Risk | Severity | Current Signal | Mitigation |
|---|---:|---|---|
| Scope explosion | High | Oracle, ES, CDC, catalog, UI, DSL, docs all pull at once | Phase gates; small vertical slices; spec remains center |
| Constraint parser sprawl | High | CHECK parsing can become a SQL compiler | Closed `CheckPred` subset; unsupported becomes Declared/Opaque |
| False metadata confidence | High | OpenMetadata bundle is draft-shaped | Validate schemas; label draft vs official; add tests |
| Memory pressure | High | CLI materializes documents in memory | Streaming reader/projector/writer |
| ES mapping immutability | High | Field type changes require reindex | Versioned indices, alias swap, rollback |
| CDC complexity | High | Relational changes affect denormalized docs | Batch first; local state; convergence tests |
| Oracle type fidelity | Medium | NUMBER/timestamp/CLOB/BLOB are tricky | Explicit lossiness model and gates |
| Patched SqlHydra drift | Medium | Embedded source can diverge | Keep patches small; consider upstreamable provider work |
| Query DSL maintenance | Medium | ES surface is huge | Own high-value authoring slice; use official client for transport/admin |
| Frontend hardcoding | Medium | UI can drift from catalog | Generate DomainConfig from semantic model |
| Governance not adopted | Medium | Docs can be ignored | Make gates executable and reports visible |
| Security/PII leakage | High | Catalog/docs may expose samples | Classification tags; scrub examples; policy before real data |

