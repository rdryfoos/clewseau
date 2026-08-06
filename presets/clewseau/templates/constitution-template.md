

<!-- Clewseau (append) — constitution article -->

### Article: End-to-End Traceability (NON-NEGOTIABLE)

Every functional requirement, non-functional requirement, and acceptance criterion carries a durable unique ID of the form `<TYPE>-<DOMAIN>-<NN>` (e.g. `FR-LOG-01`, `AC-OFFL-03`). IDs are assigned once at the PRD level and are never reused or renumbered; retired IDs are tombstoned, not recycled.

1. Each acceptance criterion is **atomic** — one independently testable assertion — and maps to at least one automated test *or* an explicitly tracked debt entry.
2. Every task in `tasks.md` MUST declare the ID(s) it implements via a `Traces:` field.
3. Every verifying test MUST encode the AC ID it protects. Every requirement-bearing source module MUST carry a coverage annotation naming the ID.
4. Coverage is **bidirectional** and machine-checked: no silent AC gaps, and no untraced scope. CI fails the build on either.
5. `/speckit.analyze` MUST report zero Clewseau traceability violations before `/speckit.implement` runs.
