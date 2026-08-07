# Clewseau vocabulary

Copy into the project glossary (e.g. `glossary.md`) when the repo keeps one. The same terms are appended to the constitution via the Clewseau preset.

| Term | Meaning |
|------|---------|
| **clew** | The Gate-emitted traceability artifact (`format: "clew"`). Default filename `clew.json`. |
| **clew.json** | Usual on-disk path for a clew (configurable via Gate `clew_path`). |
| **Clewseau** | Spec Kit overlay: durable IDs, Gate 2, clew emission. Not Thorsten Schlathölter’s open-source `clew` tool. |
| **clewloupe** | Viewer that consumes a clew only — no target re-scan. |
| **verified** | Named carrier exists (AC proof and/or `@covers` / proof for US/FR/NFR). |
| **tracked-debt** | Incomplete, but declared on an open task with `Traces:`. |
| **GAP** | Silent AC gap — neither proof nor open debt; the Thread is broken; Gate refuses. |
| **backlog** | US/FR/NFR with no own carrier — planning altitude, not a silent gap. |
| **the Thread** | The wish → work → proof chain a clew records. Human-facing: the Thread is intact or broken. Prefer this wording over "Gate passed/failed" except when naming the check script itself. Prefer **Thread** over "string" in product prose; "clew" already carries the ball-of-thread etymology. |
| **mark** / **`@covers`** | Leave a mark when you touch the work: a one-line comment in source naming the durable ID(s) that code serves. Greppable; author-written; Gate reads it; clewloupe shows it under Implementation. |
| **`Traces:`** | Mark on a task checkbox naming the ID(s) that task carries — usually open debt or anointed backlog. |
| **Gate 2** | Deterministic Clewseau check + clew emit (`speckit.clewseau-gate.check`). The mechanism that judges the Thread; say "Gate" when you mean this script, "Thread" when you mean what the human sees. Local runs are hygiene; **CI Gate is the property line** that protects the codebase. |

