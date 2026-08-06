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

## Install (dev path today)

From a Spec Kit project (`specify init` already done):

```bash
specify preset add --dev /path/to/clewseau/presets/clewseau
specify extension add --dev /path/to/clewseau/extensions/clewseau-gate
```

Then copy the extension config template and point it at your registry/paths:

```bash
cp .specify/extensions/clewseau-gate/clewseau-gate-config.template.yml \
   .specify/extensions/clewseau-gate/clewseau-gate-config.yml
# edit registry / source / test globs
```

Run Gate 2:

```bash
bash .specify/extensions/clewseau-gate/scripts/check-traceability.sh
# or via the agent command: /speckit.clewseau-gate.check
```

Catalog-published `specify bundle install clewseau` comes after the preset and extension are in install-allowed catalogs. Until then, use `--dev` as above; `bundle.yml` is the composition contract.

## Validate / build this repo

```bash
specify bundle validate --path . --offline   # warnings OK until components are catalogued
specify bundle build --path .
```

## Explicitly out of scope

- Agentic kanban / human approval lanes (Loom)
- Matrix UI / detective (thread-viz)
- Potato Cannon overlays
- HomesFlow-specific paths (those stay in HomesFlow as a worked example)

## License

MIT. See [`LICENSE`](./LICENSE).
