# Clewseau

A Spec Kit **bundle**: durable-ID grammar in the templates, plus a Gate 2 refusal that fails closed on silent gaps.

Stock Spec Kit only. No fork. No kanban daemon. No visualizer.

Read [`PROMOTION-CONTRACT.md`](./PROMOTION-CONTRACT.md) first — that is the gift. This repo is the installable witness.

## What you get

| Component | Id | Role |
|-----------|-----|------|
| Preset | `clewseau` | Appends ID / `Traces:` requirements onto Spec Kit's `spec-template`, `tasks-template`, and `constitution-template` |
| Extension | `clewseau-gate` | `speckit.clewseau-gate.check` — portable Gate 2 script + config |

Bundle id: `clewseau`.

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
# or via the agent command: /speckit.clewseau-gate.check
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

GitHub release `v0.1.0` publishes:

- `clewseau-0.1.0.zip` (bundle)
- `clewseau-preset-0.1.0.zip`
- `clewseau-gate-0.1.0.zip`

## Explicitly out of scope

- Agentic kanban / human approval lanes (Loom)
- Matrix UI / detective (thread-viz)
- Potato Cannon overlays
- HomesFlow-specific paths (those stay in HomesFlow as a worked example)

## Community submission

Catalog install is ready. Peer review with collaborators precedes Spec Kit community filing; submission packaging is prepared privately and filed when that review is done.

## License

MIT. See [`LICENSE`](./LICENSE).
