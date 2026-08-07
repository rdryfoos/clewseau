
<!-- SpecAssay (append) — constitution article -->

### Article: End-to-End Traceability (NON-NEGOTIABLE)

Every functional requirement, non-functional requirement, and acceptance criterion carries a durable unique ID of the form `<TYPE>-<DOMAIN>-<NN>` (e.g. `FR-LOG-01`, `AC-OFFL-03`). IDs are assigned once at the PRD level and are never reused or renumbered; retired IDs are tombstoned, not recycled.

1. Each acceptance criterion is **atomic** — one independently testable assertion — and maps to at least one automated test *or* an explicitly tracked debt entry. Silent-gap refusal is at **AC altitude**; US/FR/NFR IDs are planning labels (manifest status `backlog`), not silent-gap candidates.
2. Every task in `tasks.md` MUST declare the ID(s) it implements via a `Carries:` field.
3. Every verifying test MUST encode the AC ID it protects. Every requirement-bearing source module MUST carry a coverage annotation naming the ID.
4. Coverage is **bidirectional** and machine-checked: no silent AC gaps, no untraced scope, and exact-set registry ≡ specs ≡ tasks. **CI fails the build on any of these** — local Gate is hygiene; CI Gate is the property line.
5. `/speckit.analyze` MUST report zero SpecAssay traceability violations before `/speckit.implement` runs.

### Article: SpecAssay vocabulary

Use these terms; do not invent synonyms (especially not “dossier”).

| Term | Meaning |
|------|---------|
| **trace-manifest** | The check-emitted traceability artifact (`format: "trace-manifest"`). Default filename `trace-manifest.json`. |
| **trace-manifest.json** | Usual on-disk path for a trace-manifest (configurable via `manifest_path`). |
| **SpecAssay** | Spec Kit overlay: durable IDs, Gate 2, trace-manifest emission. |
| **Loupe** | Viewer that reads a trace-manifest only — no target re-scan. Reads any emitter's manifest. |
| **verified** | Named carrier exists (AC proof and/or `@covers` / proof for US/FR/NFR). |
| **tracked-debt** | Incomplete, but declared on an open task with `Carries:`. |
| **GAP** | Silent AC gap — neither proof nor open debt; Gate refuses; the Golden Thread frays. |
| **backlog** | US/FR/NFR with no own carrier — planning altitude, not a silent gap. |
| **Gate 2** | Deterministic SpecAssay check + manifest emit (`speckit.specassay.check`). |
