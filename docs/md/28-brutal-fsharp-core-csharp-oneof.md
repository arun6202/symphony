# Brutal F# Core And C# OneOf Edge

The compiler core should be brutally idiomatic F#.

Do not make the core "compatible with C#."

Make it excellent F# first, then generate C# consumer models at the boundary.

## Rule

```text
F# owns the design.
C# consumes a transcription.
```

That means:

- F# records and discriminated unions are the authoring model.
- F# `Option` and `Result` are the internal error and absence model.
- F# pattern matching drives business rules.
- F# modules and pure functions own the compiler logic.
- C# receives generated records, OneOf unions, validators, codecs, and facades.

The core should not be weakened to make C# authoring convenient.

## Why Brutal F#

F# gives this project its leverage:

- Discriminated unions.
- Records.
- Pattern matching.
- Single-case wrappers.
- Units of measure.
- Railway-oriented `Result`.
- Exhaustive modeling.
- Concise domain language.

These are not decorative. They are the reason Symphony can become a data product compiler instead of an ETL codebase.

## The Anti-Pattern

Avoid this:

```text
Design F# types so C# can call them nicely.
```

That usually leads to:

- class-heavy models
- nullable surfaces
- mutable DTOs
- stringly union tags
- exceptions for expected failure
- weaker domain invariants

The project loses its main advantage.

## The Correct Pattern

Use explicit layers:

```text
F# Domain / Projection Core
  -> DomainIR
  -> generated C# adapter
  -> generated TypeScript / Kotlin / Swift / JS
```

C# is not ignored. It is served by a dedicated output.

## C# With OneOf

OneOf is a reasonable C# target for discriminated unions today.

Example concept:

```fsharp
type OrderStatus =
    | Draft
    | Submitted of SubmittedAt
    | Fulfilled of FulfilledAt
    | Cancelled of CancelledAt * CancellationReason
```

Generated C# shape:

```csharp
public abstract record OrderStatus;

public sealed record Draft : OrderStatus;
public sealed record Submitted(DateTimeOffset SubmittedAt) : OrderStatus;
public sealed record Fulfilled(DateTimeOffset FulfilledAt) : OrderStatus;
public sealed record Cancelled(
    DateTimeOffset CancelledAt,
    string CancellationReason) : OrderStatus;
```

or, for OneOf-focused consumers:

```csharp
using OneOf;

public sealed record Draft;
public sealed record Submitted(DateTimeOffset SubmittedAt);
public sealed record Fulfilled(DateTimeOffset FulfilledAt);
public sealed record Cancelled(DateTimeOffset CancelledAt, string Reason);

public sealed class OrderStatus
    : OneOfBase<Draft, Submitted, Fulfilled, Cancelled>
{
    private OrderStatus(OneOf<Draft, Submitted, Fulfilled, Cancelled> input)
        : base(input) { }

    public static implicit operator OrderStatus(Draft value) => new(value);
    public static implicit operator OrderStatus(Submitted value) => new(value);
    public static implicit operator OrderStatus(Fulfilled value) => new(value);
    public static implicit operator OrderStatus(Cancelled value) => new(value);
}
```

But this is an adapter. It is not the source of truth.

## What Should Transcribe To C#

Generate:

- immutable records
- OneOf or sealed-record union adapters
- nullable annotations
- validators
- JSON codecs
- `Result`/error DTOs
- pure business rule facades
- test fixtures

Do not generate:

- database access
- DuckDB/Oracle extraction internals
- Elasticsearch client calls
- arbitrary F# computation expressions
- complex higher-order F# workflows

## C# Compatibility Policy

Policy:

- The core API may be F#-native.
- Public CLI and file formats must be language-neutral.
- Generated C# packages should be pleasant for C# consumers.
- C# compatibility must never force the F# core into weaker modeling.

## Future C# Union Keyword

If C# gains a stable native union feature, the C# generator can target it later.

Until then:

- sealed record hierarchy for maximum framework familiarity
- OneOf for consumers who want value-style union matching
- generated `Match` helpers for ergonomics

## Golden Tests

Every generated C# package should share fixtures with F#:

```text
F# domain value
  -> JSON fixture
  -> C# decode
  -> C# validate
  -> C# encode
  -> same JSON
```

This matters more than syntactic cleverness.

## Final Rule

Keep the cathedral in F#.

Build good roads to C#.

