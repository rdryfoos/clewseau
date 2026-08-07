# Sample `clew.json` files

| File | What |
|------|------|
| `homesflow.clew.json` | Real Gate 2 emit against HomesFlow (live tree; includes anointed-backlog rows carried by `specs/backlog/tasks.md`) |
| `sample.clew.json` | Preview default — may be mocked for interesting cases HomesFlow doesn’t emit |

Today both are the honest HomesFlow emit. Later, `sample.clew.json` can diverge (GAP / fray / etc.) while `homesflow.clew.json` stays the real baseline.

Regenerate the HomesFlow pair (until sample is intentionally mocked):

```bash
# from a machine that can see HomesFlow
CFG=/path/to/HomesFlow/.specify/extensions/clewseau-gate/clewseau-gate-config.yml
CLEWSEAU_PROJECT_ROOT=/path/to/HomesFlow CLEWSEAU_CONFIG=$CFG \
  bash extensions/clewseau-gate/scripts/check-traceability.sh
cp /path/to/HomesFlow/clew.json samples/homesflow.clew.json
python3 scripts/build-sample-clew.py
```

Silent-gap refusal is **AC-only**. US/FR/NFR without `@covers` are `backlog`, not `GAP`.
