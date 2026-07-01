# License And OSS Strategy

The repository root license is Apache License 2.0. The embedded `Symphony/SqlHydra.Source` license is MIT.

This is a strong posture for the project.

## Why This Matters

Apache 2.0 is enterprise-friendly:

- Permits commercial use.
- Permits modification.
- Permits redistribution.
- Includes an explicit patent license.
- Allows companies to build proprietary products around the work.
- Requires preservation of license and notices.

MIT for the embedded SqlHydra source is also permissive:

- Permits use, modification, distribution, sublicensing, and sale.
- Requires preservation of copyright and permission notice.

This combination is architecturally valuable. It means the project can be a real platform foundation, not a toy that enterprise architects avoid because of license ambiguity.

## The Treasure

The valuable thing here is not just code. It is the combination of:

- F# type-driven domain modeling.
- Brownfield database harvesting.
- Oracle-to-Elasticsearch projection.
- Lineage, constraints, quality, contracts, docs.
- Polyglot model export.
- A permissive license posture.

An architect will notice that this is not another closed ETL point solution. It can become a reusable compiler/evidence layer that teams can adopt, fork, inspect, and extend.

## Practical License Rules

Not legal advice, but the engineering rules should be:

- Keep the root Apache 2.0 license visible.
- Preserve the embedded SqlHydra MIT license.
- Add a `NOTICE` file if required attribution grows.
- Mark modified third-party source clearly.
- Track generated artifacts separately from source license obligations.
- Keep dependency licenses visible in docs or release artifacts.
- Avoid adding copyleft dependencies to the compiler core without deliberate review.

## Product Strategy

Apache 2.0 is a good fit for:

- Open-core architecture.
- Enterprise adoption.
- Consulting/services.
- Internal platform teams.
- Cloud-hosted governance/workbench product later.
- Vendor-neutral data product compiler positioning.

The license says: "You can trust this enough to build with it."

The architecture should live up to that.

## Boundary For Embedded Code

`SqlHydra.Source` is useful, but it should stay clearly bounded:

```text
third-party generator source
  -> patched/provider-specific behavior
  -> generated source catalog / F# types
```

Long-term, keep a record of:

- what was changed
- why it was changed
- whether it can be upstreamed
- which generated artifacts depend on it

This prevents the embedded source from becoming a mystery fork.

