# SpecAssay

When people build things, we follow a **Golden Thread** from the **wish**, to the **work**, to the **proof it's done**. SpecAssay is the inspector who makes sure nobody skips a link: every wish gets a name, every bit of work says which wish it's for, and every wish needs its proof. If the Golden Thread is missing a link or broken, SpecAssay stops the line and points at the loose end. Then it hallmarks what it found and saves it in a file — the **trace-manifest** — so anyone can check it later, even long after everyone's gone home. (The name is the assay office: for seven hundred years, gold has been tested and struck with a hallmark so its provenance can be read at a glance. SpecAssay does the same for a codebase.)

A Spec Kit **bundle**: durable-ID grammar in the templates, Gate 2 refusal of silent gaps, and emission of a **trace-manifest** (default file `trace-manifest.json`).

Stock Spec Kit only. No fork. No kanban daemon. Visualization is separate (**Loupe** reads the trace-manifest; it does not re-scan).

Read [`PROMOTION-CONTRACT.md`](./PROMOTION-CONTRACT.md) first — that is the gift. This repo is the installable witness.

## What you get

| Component | Id | Role |
|-----------|-----|------|
| Preset | `specassay` | Appends ID / `Carries:` requirements onto Spec Kit's `spec-template`, `tasks-template`, and `constitution-template` |
| Extension | `specassay-check` | Gate 2 check + **trace-manifest emitter** (`speckit.specassay.check`) |

Bundle id: `specassay`.

## The trace-manifest (`trace-manifest.json`)

Gate 2 always writes a portable, vendor-neutral **trace-manifest** (default path `trace-manifest.json`, configurable as `manifest_path`):

- `format: "trace-manifest"`, `schemaVersion: 3`, `emitter: "specassay-check"`
- Rows: id, statement, status (`verified` \| `tracked-debt` \| `GAP` \| `backlog`), implementations, proofs
- Top-level `gate: { ok, failures[] }` so non-row refusals are visible to viewers
- Written even when the gate fails, so silent AC gaps are visible in the file
- Silent-gap refusal is **AC-only** (coverage altitude); US/FR/NFR without a carrier are `backlog`, not `GAP`
- **Exact-set** registry ≡ specs ≡ tasks (no unclaimed registry IDs) — except **anointed backlog**: an ID whose only carrier is an open `Carries:` TODO is `backlog`, not drift
- Not ReqIF/OSLC; optional ReqIF export can come later. See [`docs/trace-manifest-schema.md`](./docs/trace-manifest-schema.md)

The `format` value is deliberately vendor-neutral: `trace-manifest` belongs to no single tool, so any emitter (SpecAssay's `specassay-check` included) can write one and any viewer can read it.

**Reading a trace-manifest in SDLC terms** (requirement → build → proof → Gate → Loupe): [`docs/reading-a-manifest.md`](./docs/reading-a-manifest.md). Visual tour with screenshots: [`docs/loupe-field-guide.md`](./docs/loupe-field-guide.md).

**Does it work cold?** A zero-context agent on stock Spec Kit + this bundle delivered a PRD item end to end, Gate-clean: [`docs/evidence-cold-agent-trial.md`](./docs/evidence-cold-agent-trial.md).

## Vocabulary

| Term | Meaning |
|------|---------|
| **trace-manifest** | Gate-emitted traceability artifact (`format: "trace-manifest"`). Not “dossier.” |
| **trace-manifest.json** | Default on-disk path (Gate `manifest_path`). |
| **`{name}.trace-manifest.json`** | Portable copies / samples. |
| **verified** / **tracked-debt** / **GAP** / **backlog** | Honest coverage states — see the reading guide. |
| **Loupe** | Viewer only; reads a trace-manifest; no target re-scan. |

Preset paste-ready article + glossary stub: `presets/specassay/templates/constitution-template.md`, `presets/specassay/GLOSSARY.md`.

Convention: reader-facing repos (this one, Loupe, the vendored check README) open with a plain-language explainer like the one at the top of this file — keep it when rewriting.

## Samples

| File | Role |
|------|------|
| [`samples/homesflow.trace-manifest.json`](./samples/homesflow.trace-manifest.json) | Real Gate 2 emit against HomesFlow |
| [`samples/sample.trace-manifest.json`](./samples/sample.trace-manifest.json) | Same honest emit (preview default) |

See [`samples/README.md`](./samples/README.md). Rebuild with `python3 scripts/build-sample-manifest.py` after regenerating the real emit.

## Install (catalog path)

From a Spec Kit project (`specify init` already done). Add SpecAssay's install-allowed catalogs, then install the bundle:

```bash
specify preset catalog add \
  https://raw.githubusercontent.com/rdryfoos/specassay/main/catalogs/presets.json \
  --name specassay --install-allowed

specify extension catalog add \
  https://raw.githubusercontent.com/rdryfoos/specassay/main/catalogs/extensions.json \
  --name specassay --install-allowed

specify bundle catalog add \
  https://raw.githubusercontent.com/rdryfoos/specassay/main/catalogs/bundles.json \
  --id specassay --policy install-allowed

specify bundle install specassay
```

If Gate config was not scaffolded automatically, copy it once:

```bash
cp .specify/extensions/specassay-check/config-template.yml \
   .specify/extensions/specassay-check/specassay-check-config.yml
```

Edit `.specify/extensions/specassay-check/specassay-check-config.yml` so `registry` / globs match your repo.

Run Gate 2 locally (fast feedback):

```bash
bash .specify/extensions/specassay-check/scripts/check-traceability.sh
# writes trace-manifest.json; or via the agent command: /speckit.specassay.check
```

**CI is the property line.** A Gate on a compliant laptop is courtesy. Without SpecAssay on the machine, unmarked work can still be pushed. Run the same script (or `speckit.specassay.check`) on every PR and every commit to a protected branch, and **fail the build** when it exits non-zero. Local Gate is optional hygiene; CI Gate is what protects the Golden Thread. Archive the emitted `trace-manifest.json` from that run as the refusal's evidence.

## Install (dev path)

```bash
specify preset add --dev /path/to/specassay/presets/specassay
specify extension add --dev /path/to/specassay/extensions/specassay-check
```

Install scaffolds `specassay-check-config.yml` from `config-template.yml`.

## Release artifacts

```bash
./scripts/build-release.sh          # → dist/*.zip
specify bundle validate --path . --offline
```

## Explicitly out of scope

- Agentic kanban / human approval lanes (Loom)
- Matrix UI (**Loupe** — separate viewer)
- Potato Cannon overlays
- HomesFlow-specific paths (those stay in HomesFlow as a worked example)

## Community submission

Catalog install is ready. Peer review with collaborators precedes Spec Kit community filing; submission packaging is prepared privately and filed when that review is done.

## License

MIT. See [`LICENSE`](./LICENSE).
