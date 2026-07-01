# Polyglot Domain Export

The goal is to export F# domain goodness to TypeScript, JavaScript, Kotlin, and Swift without pretending arbitrary F# can be safely transpiled to every language.

## Core Principle

Do not transpile the whole program.

Export a portable domain contract:

```text
F# domain model
  -> Domain IR
  -> TypeScript / JavaScript / Kotlin / Swift models
  -> validators
  -> codecs
  -> selected pure business rules
```

This keeps the system honest. Models and portable rules travel well. Effects, database access, async workflows, and platform-specific behavior do not.

## What Should Export

Export:

- Records.
- Discriminated unions.
- Single-case wrappers.
- Enums.
- Value objects.
- Required/optional fields.
- Constraint metadata.
- JSON codecs.
- Validation functions.
- Pure decision tables.
- Pure business rules that use the portable subset.

Do not export directly:

- Database access.
- Async workflows.
- Dependency injection.
- F# computation expressions.
- Arbitrary higher-order functions.
- Reflection-heavy behavior.
- Elasticsearch client code.

## Domain IR

Add a language-neutral domain intermediate representation:

```text
DomainPackage
  name
  version
  types
  constraints
  codecs
  pure rules
  error model
  semantic metadata
```

This IR is the real export contract.

It can generate:

- TypeScript types and validators.
- JavaScript runtime validators.
- Kotlin data classes and sealed interfaces.
- Swift structs and enums.
- JSON schema or JTD.
- OpenAPI components.
- Test fixtures.

## F# As The Authoring Source

F# remains the best authoring language because:

- Discriminated unions are native.
- Records are concise.
- Constrained values are natural.
- Pattern matching expresses business logic clearly.
- Domain Modeling Made Functional maps directly to the language.

The exported languages consume a projection of that model.

## TypeScript / JavaScript

TypeScript should get:

- `type` aliases for records and unions.
- tagged union representation.
- `zod` or generated validator option.
- JSON codecs.
- exhaustive match helper where useful.

JavaScript should get:

- generated runtime validators.
- JSDoc typedefs.
- codec functions.
- plain object constructors.

Fable can help for F# to JS, but the product should still define a stable Domain IR so non-Fable consumers are not locked out.

## Kotlin

Kotlin should get:

- `data class` records.
- `sealed interface` or `sealed class` unions.
- inline/value classes for simple wrappers where appropriate.
- kotlinx.serialization codecs.
- validation functions returning typed results.

## Swift

Swift should get:

- `struct` records.
- `enum` associated-value unions.
- `Codable` codecs.
- throwing or `Result`-returning validators.
- value-oriented API.

## Business Logic Export

Only export logic that fits a portable subset:

- no I/O
- no time access except explicit parameters
- no randomness except explicit seed
- no database calls
- no hidden dependencies
- no platform-specific libraries

Better pattern:

```text
F# rule declarations
  -> decision table / expression tree / rule IR
  -> generated implementation per target language
  -> shared golden tests
```

Golden tests matter more than clever transpilation.

## Why This Matters

This lets the same business truth power:

- backend F#
- frontend TypeScript/JavaScript
- Android Kotlin
- iOS Swift
- API contracts
- generated docs
- validation at boundaries

The platform becomes a domain contract compiler, not just a data pipeline.

