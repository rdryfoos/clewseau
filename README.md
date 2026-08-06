# Clewseau

A Spec Kit **bundle**: durable-ID grammar in the templates, Gate 2 refusal of silent gaps, and emission of a **clew** (default file `clew.json`).

Stock Spec Kit only. No fork. No kanban daemon. Visualization is separate (**clewloupe** consumes the clew; it does not re-scan).

Read [`PROMOTION-CONTRACT.md`](./PROMOTION-CONTRACT.md) first — that is the gift. This repo is the installable witness.

## What you get

| Component | Id | Role |
|-----------|-----|------|
| Preset | `clewseau` | Appends ID / `Traces:` requirements onto Spec Kit's `spec-template`, `tasks-template`, and `constitution-template` |
| Extension | `clewseau-gate` | Gate 2 check + **clew emitter** (`speckit.clewseau-gate.check`) |

Bundle id: `clewseau`.

## The clew (`clew.json`)

Gate 2 always writes a Clewseau-native **clew** (default path `clew.json`, configurable as `clew_path`):

- `format: "clew"`, `schemaVersion: 3`, `emitter: "clewseau-gate"`
- Rows: id, statement, status (`verified` \| `tracked-debt` \| `GAP` \| `backlog`), implementations, proofs
- Top-level `gate: { ok, failures[] }` so non-row refusals are visible to viewers
- Written even when the gate fails, so silent AC gaps are visible in the file
- Silent-gap refusal is **AC-only** (coverage altitude); US/FR/NFR without a carrier are `backlog`, not `GAP`
- **Exact-set** registry ≡ specs ≡ tasks (no unclaimed registry IDs)
- Not ReqIF/OSLC; optional ReqIF export can come later. See [`docs/clew-schema.md`](./docs/clew-schema.md)

**Reading a clew in SDLC terms** (requirement → build → proof → Gate → loupe): [`docs/reading-a-clew.md`](./docs/reading-a-clew.md).

## Vocabulary

| Term | Meaning |
|------|---------|
| **clew** | Gate-emitted traceability artifact (`format: "clew"`). Not “dossier.” |
| **clew.json** | Default on-disk path (Gate `clew_path`). |
| **`{name}.clew.json`** | Portable copies / samples. |
| **verified** / **tracked-debt** / **GAP** / **backlog** | Honest coverage states — see the reading guide. |
| **clewloupe** | Viewer only; consumes a clew; no target re-scan. |

Preset paste-ready article + glossary stub: `presets/clewseau/templates/constitution-template.md`, `presets/clewseau/GLOSSARY.md`.

## Samples

| File | Role |
|------|------|
| [`samples/homesflow.clew.json`](./samples/homesflow.clew.json) | Real Gate 2 emit against HomesFlow |
| [`samples/sample.clew.json`](./samples/sample.clew.json) | Same honest emit (preview default) |

See [`samples/README.md`](./samples/README.md). Rebuild with `python3 scripts/build-sample-clew.py` after regenerating the real emit.

## Install (catalog path)

From a Spec Kit project (`specify init` already done). Add Clewseau's install-allowed catalogs, then install the bundle:

```bash
specify preset catalog add \
  https://raw.githubusercontent.com/rdryfoos/clewseau/main/catalogs/presets.json \
  --name clewseau --install-allowed

specify extension catalog add \
  https://raw.githubusercontent.com/rdryfoos/clewseau/main/catalogs/extensions.json \
  --name clewseau --install-allowed

specify bundle catalog add \
  https://raw.githubusercontent.com/rdryfoos/clewseau/main/catalogs/bundles.json \
  --id clewseau --policy install-allowed

specify bundle install clewseau
```

If Gate config was not scaffolded automatically, copy it once:

```bash
cp .specify/extensions/clewseau-gate/config-template.yml \
   .specify/extensions/clewseau-gate/clewseau-gate-config.yml
```

Edit `.specify/extensions/clewseau-gate/clewseau-gate-config.yml` so `registry` / globs match your repo.

Run Gate 2:

```bash
bash .specify/extensions/clewseau-gate/scripts/check-traceability.sh
# writes clew.json; or via the agent command: /speckit.clewseau-gate.check
```

## Install (dev path)

```bash
specify preset add --dev /path/to/clewseau/presets/clewseau
specify extension add --dev /path/to/clewseau/extensions/clewseau-gate
```

Install scaffolds `clewseau-gate-config.yml` from `config-template.yml`.

## Release artifacts

```bash
./scripts/build-release.sh          # → dist/*.zip
specify bundle validate --path . --offline
```

## Explicitly out of scope

- Agentic kanban / human approval lanes (Loom)
- Matrix UI (**clewloupe** — separate viewer)
- Potato Cannon overlays
- HomesFlow-specific paths (those stay in HomesFlow as a worked example)

## Community submission

Catalog install is ready. Peer review with collaborators precedes Spec Kit community filing; submission packaging is prepared privately and filed when that review is done.

## License

MIT. See [`LICENSE`](./LICENSE).
