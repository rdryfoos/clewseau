---
description: Run Clewseau Gate 2 — fail on silent gaps and untraced scope
---

# Clewseau Gate 2 check

Run the portable Gate 2 script shipped with this extension. It does **not** re-scan product intent; it only checks that durable IDs in the registry are either verified (named proof) or tracked as debt (open task), and that coverage annotations / test-encoded IDs are not orphans.

## Steps

1. Confirm `.specify/extensions/clewseau-gate/clewseau-gate-config.yml` exists (copy from the `.template.yml` if missing) and points at this project's registry, specs, tasks, and source/test trees.
2. From the project root, run:

```bash
bash .specify/extensions/clewseau-gate/scripts/check-traceability.sh
```

3. Report the script's exit code and any `FAIL:` lines verbatim.
4. Do **not** weaken the gate. If something is unfinished, it belongs as tracked debt (unchecked task with `Traces:`), not as a silenced gap.
5. Reminder: **verified** means a named proof exists — not that a full suite was asserted green by this script.
