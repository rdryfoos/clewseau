---
description: Run Clewseau Gate 2 — fail on silent gaps; emit clew.json
---

# Clewseau Gate 2 check

Run the portable Gate 2 script shipped with this extension. It checks that durable IDs in the registry are either verified (named proof) or tracked as debt (open task), that coverage annotations / test-encoded IDs are not orphans, and **always writes `clew.json`** (path configurable) — the Clewseau dossier / matrix. The dossier is written even when the gate fails, so GAPs are visible.

`clew.json` is Clewseau-native (`format: "clew"`, schemaVersion 3). It is not ReqIF/OSLC. Panther (the viewer) consumes this file; it does not re-scan the target.

## Steps

1. Confirm `.specify/extensions/clewseau-gate/clewseau-gate-config.yml` exists (copy from `config-template.yml` if missing) and points at this project's registry, specs, tasks, and source/test trees. Set `clew_path` if you do not want `clew.json` at the project root.
2. From the project root, run:

```bash
bash .specify/extensions/clewseau-gate/scripts/check-traceability.sh
```

3. Report the script's exit code, any `FAIL:` lines, and confirm `clew.json` (or configured `clew_path`) was written.
4. Do **not** weaken the gate. If something is unfinished, it belongs as tracked debt (unchecked task with `Traces:`), not as a silenced gap.
5. Reminder: **verified** means a named proof exists — not that a full suite was asserted green by this script.
