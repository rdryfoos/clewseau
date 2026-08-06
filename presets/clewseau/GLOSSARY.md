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
| **GAP** | Silent AC gap — neither proof nor open debt; Gate refuses; thread frays. |
| **backlog** | US/FR/NFR with no own carrier — planning altitude, not a silent gap. |
| **Gate 2** | Deterministic Clewseau check + clew emit (`speckit.clewseau-gate.check`). |

Do not use **dossier** for this artifact — in Clewseau it is a **clew**.
