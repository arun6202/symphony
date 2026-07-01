# Symphony Deep Dive

Symphony is currently the strongest implementation slice in the repository. Its core pattern is:

```text
typed spec -> pure folds -> thin shell
```

## `Bridge.Spec`

The spec layer already has several important pieces.

### Lineage

Lineage is modeled as:

- `Exact` - computed from expression structure.
- `Declared` - asserted by the author for raw expressions.
- `Opaque` - intentionally unknown.

This is a good direction. It makes honesty a first-class value. A production gate can block `Opaque` for governed serving fields, while still allowing experimental fields to exist with a visible coverage penalty.

### Expression Algebra

Current raw cases:

- `RCol`
- `RConcat`
- `RApply`
- `RLit`
- `RRaw`

The typed wrapper `Expr<'row,'value>` is the right F# pattern for a phantom-typed boundary over an untyped foldable core. Future work should add more first-class expression cases before falling back to raw SQL.

Candidates:

- Arithmetic: add, subtract, multiply, divide.
- Null behavior: coalesce, nullable map, required parse.
- Date transforms: truncate, date diff, time zone normalization.
- String transforms: trim, lower, upper, substring.
- Conditional: case/when, option default.
- Aggregate document construction: nested object, repeated child collection.

### Refined Types

Current predicates include:

- `GreaterThanOrEqualToZero`
- `GreaterThanZero`
- `BetweenZeroAndOne`
- `PrimaryKey`

This creates the opening for database constraints to become F# witnesses. The next step is to stop representing refinements as `string list` and model them as a closed constraint AST.

Recommended model:

```fsharp
type Bound<'T> =
    | Inclusive of 'T
    | Exclusive of 'T

type CheckPred =
    | Range of lo: Bound<decimal> option * hi: Bound<decimal> option
    | IntRange of lo: Bound<int64> option * hi: Bound<int64> option
    | BetweenZeroAndOne
    | NonEmpty
    | MaxLength of int
    | InList of string list
```

The exact shape can evolve, but the principle should hold: supported constraints become structured data; unsupported constraints become `Declared` or `Opaque` with coverage impact.

## `Bridge.Folds`

The fold layer already proves the "one score, many performances" idea.

Current folds:

- `CompileEs.compileMapping`
- `LineageOf.fieldLineage`
- `CompileOkf.compileBundle`
- `CompileOpenMetadata.emitBundle`

Recommended future folds:

- `CompileQuality.emitTests`
- `CompileContract.emitContract`
- `CompileDocs.emitFieldReference`
- `CompileQueries.emitSmokeQueries`
- `CompileGraph.emitJsonLd`
- `CompileDiff.compareSpecs`
- `CompileRunLedger.emitRunEvidence`

## `Bridge.Cli`

The CLI currently does all of this in one path:

- Builds the spec.
- Extracts order-line rows.
- Shapes documents.
- Writes bulk chunks.
- Writes metadata artifacts.

This is acceptable for the MVP. For production, split it into explicit workflows:

- `harvest`
- `compile`
- `extract`
- `write-bulk`
- `validate`
- `load`
- `emit-catalog`
- `diff-spec`

An Argu-based F# CLI would fit this repository well.

## Scaling Concern

`extractOrderLines` returns a `JsonObject list`. That is fine for the MVP, but not for billion-row paths.

Future shape:

```text
DbDataReader
  -> row parser Result<Row, Error>
  -> document projector Result<Document, Error>
  -> chunked bulk writer
  -> manifest writer
  -> metrics/run ledger
```

The important move is to keep the pipeline streaming, bounded, and checkpointable.

