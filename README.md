# SpecAssay

Every honest piece of work stands on three legs: the **intent** (why we're doing it), the **build** (the code that does it), and the **proof** (a test that shows it's done). Kick out any leg and it topples. SpecAssay is the inspector that checks all three are there and tied together — and refuses to let work pass as "done" when a leg is quietly missing. It hallmarks what it finds into a small file, the **trace-manifest**, so anyone can read the provenance later, long after everyone's gone home.

*(The name is the assay office: for seven hundred years gold has been tested and struck with a hallmark so its provenance can be read at a glance. SpecAssay does the same for a codebase — and tells real metal from **gilt**, work gilded to gleam like done with nothing underneath.)*

**For a developer:** it's a [GitHub Spec Kit](https://github.com/github/spec-kit) bundle. It adds durable IDs to your templates, runs a deterministic Gate on every push, and emits a `trace-manifest.json` you can read at a glance (or in [Loupe](https://loupe.dryfoos.com)). No fork, no daemon, no second system to keep in sync — the thread lives in the repo.

Read [`PROMOTION-CONTRACT.md`](./PROMOTION-CONTRACT.md) first — that's the idea, and it's the gift. This repo is the installable witness.

## The three legs

- **Intent** — the wish, minted once as a durable ID (`US-…`, `FR-…`, `NFR-…`, `AC-…`) in the registry (usually the PRD). Minted at intent, never inferred from code later, never renumbered.
- **Build** — the code that serves an intent leaves a one-line `@covers ID` mark where it lives. Greppable, author-written.
- **Proof** — the test that closes an acceptance criterion encodes the AC's ID in its name (`test_AC_HOME_15_…`).

The **Golden Thread** is the line that ties the three together, wish to work to proof. When every leg is present and linked, the thread holds. When an acceptance criterion has neither a proof nor an openly-admitted debt, the thread frays — that's a silent gap, and the Gate refuses it.

## How it works (a day in the thread)

1. **Intend.** The business settles a story; you mint its IDs into the registry. Not building it yet? Mint the ID *and* write one open `Carries:` TODO — that's **anointed backlog**, an honest "coming soon," not a broken thread.
2. **Build.** You (or your AI, using the Spec Kit workflow) implement it, leaving `@covers ID` on the source that carries each intent and `**Carries**:` on each task.
3. **Prove.** You write the test named to the acceptance criterion it protects.
4. **Gate.** `speckit.specassay.check` (Gate 2) scans registry, specs, tasks, `@covers`, and named tests, and refuses on silent AC gaps, untraced scope, or registry↔spec↔tasks drift. It writes the trace-manifest **even when it fails**, so the break is visible, not hidden.
5. **Read.** Loupe reads that trace-manifest and shows each intent walked top to bottom — proven (green), honest debt (amber), waiting (blue), or a frayed gap (red).

**CI is the property line.** A Gate on a compliant laptop is a courtesy; a cowboy (or a cold agent) with no local install can still push unmarked work. Run Gate 2 in CI on every PR and every commit to a protected branch, and fail the build when the thread breaks. Local Gate is optional hygiene; the CI Gate is what protects the codebase. The emitted `trace-manifest.json` is the refusal's evidence trail.

## The honest states

Passing does not mean "everything is done." It means nothing *unfinished* is *hidden* at acceptance-criterion altitude. The states are named so debt can stay visible instead of hiding behind a false green:

| State | Meaning |
|-------|---------|
| **proven** | A named proof exists (an AC test, or `@covers`/proof for US/FR/NFR). A traceability fact — that a proof exists — not a claim the code is correct. |
| **tracked-debt** | Started, proof missing, but admitted on an open task with `Carries:`. Visible, on the books. |
| **backlog** | A US/FR/NFR with no carrier yet, or an ID anointed into backlog (registry entry + open `Carries:` TODO). Planning altitude, not a silent gap. |
| **GAP** | A silent AC gap — neither proof nor open debt. The Golden Thread is broken; the Gate refuses. |

Silent-gap refusal is **AC-only** (acceptance criteria are the atomic unit of "covered"); US/FR/NFR without a carrier are `backlog`, not `GAP`.

## The trace-manifest (`trace-manifest.json`)

Gate 2 always writes a portable, vendor-neutral **trace-manifest** (default path `trace-manifest.json`, configurable as `manifest_path`):

- `format: "trace-manifest"`, `schemaVersion: 3`, `emitter: "specassay-check"`
- Rows: id, statement, status (`proven` \| `tracked-debt` \| `GAP` \| `backlog`), implementations, proofs
- Top-level `gate: { ok, failures[] }` so non-row refusals (orphans, drift, missing `Carries:`) are visible to viewers
- Written even when the Gate fails, so silent AC gaps are visible in the file
- **Exact-set** registry ≡ specs ≡ tasks (no unclaimed registry IDs) — except **anointed backlog**

The `format` value is deliberately vendor-neutral: `trace-manifest` belongs to no single tool, so any emitter can write one and any viewer can read it. Not ReqIF/OSLC; see [`docs/trace-manifest-schema.md`](./docs/trace-manifest-schema.md).

**Reading a trace-manifest in SDLC terms** (intent → build → proof → Gate → Loupe): [`docs/reading-a-manifest.md`](./docs/reading-a-manifest.md). Visual tour with screenshots: [`docs/loupe-field-guide.md`](./docs/loupe-field-guide.md). **Does it work cold?** A zero-context agent on stock Spec Kit + this bundle delivered a PRD item end to end, Gate-clean: [`docs/evidence-cold-agent-trial.md`](./docs/evidence-cold-agent-trial.md).

## What you get

| Component | Id | Role |
|-----------|-----|------|
| Preset | `specassay` | Appends durable-ID / `Carries:` grammar onto Spec Kit's `spec-template`, `tasks-template`, and `constitution-template` |
| Extension | `specassay-check` | Gate 2 check + **trace-manifest emitter** (`speckit.specassay.check`) |

Bundle id: `specassay`.

## Install (catalog path)

From a Spec Kit project (`specify init` already done):

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

If Gate config wasn't scaffolded automatically, copy it once and point it at your repo:

```bash
cp .specify/extensions/specassay-check/config-template.yml \
   .specify/extensions/specassay-check/specassay-check-config.yml
# then edit registry / globs in specassay-check-config.yml
```

Run Gate 2 locally (fast feedback):

```bash
bash .specify/extensions/specassay-check/scripts/check-traceability.sh
# writes trace-manifest.json; or via the agent command: /speckit.specassay.check
```

**Dev path:**

```bash
specify preset add --dev /path/to/specassay/presets/specassay
specify extension add --dev /path/to/specassay/extensions/specassay-check
```

## Samples

| File | Role |
|------|------|
| [`samples/homesflow.trace-manifest.json`](./samples/homesflow.trace-manifest.json) | Real Gate 2 emit against HomesFlow (82 rows, 0 GAP) |
| [`samples/sample.trace-manifest.json`](./samples/sample.trace-manifest.json) | Clean synthetic `example-app` demo — Loupe's preview default |

See [`samples/README.md`](./samples/README.md).

## What SpecAssay is not

- **Not a fork of Spec Kit**, and not a replacement — a bundle that overlays the stock workflow.
- **Not Thorsten Schlathölter's `clew`** (an inner-loop, code-anchored constructor). SpecAssay is complementary altitude — promotion/refusal on the outer loop — and cites `clew` as prior art. The shared `trace-manifest` format is designed so both can emit one for the same viewer.
- **Not a visualizer.** [Loupe](https://loupe.dryfoos.com) (or any viewer) may read `trace-manifest.json`; viewers never mint IDs or re-scan the target.
- **Not agent kanban / human-approval lanes**, and not HomesFlow-specific paths (those stay in HomesFlow as a worked example).

## License

MIT. See [`LICENSE`](./LICENSE).
