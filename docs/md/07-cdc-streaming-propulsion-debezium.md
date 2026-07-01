# CDC, Propulsion.Net, and Debezium Brainstorm

The user is considering Propulsion.Net and Debezium for the Helios/Symphony future. This document captures a possible direction.

## First Principle

CDC should come after batch is boring.

The batch path proves:

- Projection semantics.
- Document identity.
- Mapping compatibility.
- Quality checks.
- Alias lifecycle.
- Run evidence.
- Reconciliation.

CDC then reuses the same spec and document builder.

## Debezium Role

Debezium is a strong candidate for source change capture when the source is supported and the operational context accepts Kafka-style infrastructure.

Potential responsibilities:

- Capture row-level source changes.
- Emit structured change events.
- Preserve source offsets and transaction metadata.
- Feed Kafka topics for downstream processors.

Questions for Oracle specifically:

- Is Oracle LogMiner acceptable for the target deployment?
- Is XStream licensed and available?
- Are database privileges acceptable?
- What is the expected redo volume?
- How are schema changes represented and versioned?

## Propulsion.Net Role

Propulsion.Net can be considered for event processing patterns in .NET/F#:

- Checkpointed stream consumption.
- Bounded parallelism.
- Projector-style handlers.
- EventStore/Kafka style processing patterns, depending on adapter choice.
- Functional composition around event handling.

Possible fit:

```text
Debezium event
  -> normalize source event
  -> group by aggregate/document key
  -> apply to local document state
  -> emit Symphony BulkOp
  -> Elasticsearch sink
  -> checkpoint after durable write
```

## CDC Document State

Relational-to-document CDC is harder than row replication.

For an order-line document, changes can arrive from:

- `Orders`
- `Order Details`
- `Customers`
- `Employees`
- `Products`
- `Categories`

If a customer name changes, many order-line documents may need updates. That means the stream processor needs one of:

- Local join state.
- Lookup-on-change back to Oracle.
- Precomputed reverse dependency index.
- Denormalization policy that avoids updating history fields.

The right answer depends on product semantics.

## Bulk Operation Algebra

Use a small shared operation model:

```fsharp
type BulkOp =
    | Upsert of id: DocId * document: Json * version: SourceVersion
    | Tombstone of id: DocId * version: SourceVersion
```

For Oracle, `SourceVersion` should be SCN-aligned if possible.

## Version Guard

Use Elasticsearch external versioning where possible:

- Prevent older events from overwriting newer documents.
- Make replay safe.
- Allow snapshot and stream overlap.
- Prevent delete resurrection with tombstones.

## CDC Acceptance Tests

Before production CDC:

- Insert creates a document.
- Update source field updates the right target fields.
- Delete creates tombstone or removes document according to policy.
- Out-of-order events converge to highest source version.
- Duplicate events are idempotent.
- Parent change updates all dependent documents or is explicitly out of scope.
- Snapshot plus CDC overlap does not double-apply or drop changes.

## Recommendation

Use Debezium for capture only if its Oracle operational model is acceptable. Use Propulsion.Net or a similar F#/.NET stream processing layer for deterministic, checkpointed projection handling. Do not let either tool own projection semantics. The Symphony spec owns semantics.

