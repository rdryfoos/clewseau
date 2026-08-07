# Sample `trace-manifest.json` files

| File | What |
|------|------|
| `homesflow.trace-manifest.json` | Real Gate 2 emit against HomesFlow — fully SpecAssay-native (`**Carries**:`, no `clew`/`Traces`); 82 rows, `gate.ok: true`, 0 GAP |
| `sample.trace-manifest.json` | Clean synthetic demo (`example-app`) — the shareable "shape" artifact and Loupe's preview default |

`homesflow.trace-manifest.json` is the real baseline; `sample.trace-manifest.json` is a curated synthetic demo (it can show GAP / fray cases HomesFlow doesn't). Both are clean, post-rename manifests.

Regenerate the HomesFlow twin (the synthetic `sample` is curated by hand, not synced):

```bash
# from a machine (or CI) that can see HomesFlow
cd /path/to/HomesFlow && bash .specify/extensions/specassay-check/scripts/check-traceability.sh
cp /path/to/HomesFlow/trace-manifest.json samples/homesflow.trace-manifest.json
```

Silent-gap refusal is **AC-only**. US/FR/NFR without `@covers` are `backlog`, not `GAP`.
