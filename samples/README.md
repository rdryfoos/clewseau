# Sample `trace-manifest.json` files

| File | What |
|------|------|
| `homesflow.trace-manifest.json` | Real Gate 2 emit against HomesFlow (live tree; includes anointed-backlog rows carried by `specs/backlog/tasks.md`) |
| `sample.trace-manifest.json` | Preview default — may be mocked for interesting cases HomesFlow doesn’t emit |

Today both are the honest HomesFlow emit. Later, `sample.trace-manifest.json` can diverge (GAP / fray / etc.) while `homesflow.trace-manifest.json` stays the real baseline.

**Transition note:** the top-level `format`/`emitter` are the post-rename values (`trace-manifest` / `specassay-check`), but the row `excerpt`/`statement` text still reflects HomesFlow's pre-rename tree — you'll see `**Traces**:` marks and `Clewseau`-worded PRD statements. That's honest: the check accepts both `**Carries**:` and `**Traces**:` during transition, and HomesFlow hasn't been re-emitted under SpecAssay yet. Regenerating from a renamed HomesFlow will refresh those excerpts.

Regenerate the HomesFlow pair (until sample is intentionally mocked):

```bash
# from a machine that can see HomesFlow
CFG=/path/to/HomesFlow/.specify/extensions/specassay-check/specassay-check-config.yml
SPECASSAY_PROJECT_ROOT=/path/to/HomesFlow SPECASSAY_CONFIG=$CFG \
  bash extensions/specassay-check/scripts/check-traceability.sh
cp /path/to/HomesFlow/trace-manifest.json samples/homesflow.trace-manifest.json
python3 scripts/build-sample-manifest.py
```

Silent-gap refusal is **AC-only**. US/FR/NFR without `@covers` are `backlog`, not `GAP`.
