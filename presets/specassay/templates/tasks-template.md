

<!-- SpecAssay (append) — mandatory Carries field -->

## SpecAssay — Carries (required)

Every task MUST declare the registry ID(s) it implements:

- Format on each task line: `**Carries**: AC-…, FR-…` (one or more IDs from the PRD registry).
- Do not invent IDs in tasks. If an ID is missing from the registry, stop and fix the PRD first.
- Test tasks that verify an AC SHOULD encode that AC in the test name (e.g. `test_AC_SYNC_04_…`).
