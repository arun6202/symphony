# Glossary

## Symphony

The F# projection and governance engine that turns relational truth into Elasticsearch artifacts, lineage, quality, contracts, and catalog output.

## Helios

Reference/product layer containing the Elastic F# query DSL, API/frontend experiments, semantic catalog work, and quality rules.

## TableSpec

The typed projection specification: source, target index/alias, key, fields, lineage, constraints, and detected metadata.

## Fold

A pure function over the spec that emits an artifact, such as mapping JSON, lineage, quality rules, or documentation.

## Lineage

Source-to-target provenance for a field.

## Exact

Lineage computed from structured expression cases.

## Declared

Lineage asserted by an author for a raw expression.

## Opaque

Lineage intentionally unknown. Useful as an escape hatch, but should be gated.

## Refined Type

An F# type that carries a value only after a predicate has been checked.

## Lossiness

A classification of whether source semantics survive target mapping exactly.

## OpenMetadata

External metadata/catalog vocabulary and API target. Symphony should emit compatible artifacts but keep its typed spec as internal truth.

## OKF

Local, human-readable catalog/documentation style used for field explanations and lineage.

## Debezium

CDC platform that can capture database changes into Kafka-style event streams.

## Propulsion.Net

.NET/F# event-processing library family that may help with checkpointed projectors and stream processing.

## SCN

Oracle System Change Number, useful as a consistent version/watermark for snapshots and CDC.

## Alias Swap

Elasticsearch operational pattern where a versioned concrete index is loaded and validated before the serving alias moves to it.

## BulkOp

Small algebra for Elasticsearch writes, typically `Upsert` or `Tombstone` with a source version.

