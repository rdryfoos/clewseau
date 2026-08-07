# SpecAssay — Promotion Contract

**Status:** normative gift. The idea is the product; the scripts are witnesses.

This is the refusal to promote work that will not carry an immutable ID, plus the honest states that replace green theater. Prior art is thick (safety-critical RTM practice; the UK "golden thread" of building-safety records; Jonathan Smart / Sooner Safer Happier "Golden Thread"; GitHub Spec Kit; Thorsten Schlathölter's CAS-DD / open-source `clew`). SpecAssay's contribution is making admission cheap enough that AI-speed work still cannot hide.

## One sentence

Mint durable IDs at intent; refuse silent gaps; allow tracked debt to stay visible.

## Rules

1. **Mint at intent.** IDs are assigned once in the authoritative registry (usually the PRD), not inferred from code later. Feature specs inherit; they do not mint.
2. **Immutability.** Never renumber. Never reuse. Retire in place (tombstone), do not recycle.
3. **Atomic ACs.** One acceptance criterion, one independently testable assertion. Split compounds before Spec Kit ingests them.
4. **Propagation.** Every task declares `Carries:` with the ID(s) it serves. Implementation carriers name the ID (`@covers` or language equivalent). Verification names the AC in the test identifier. Feature specs inherit registry IDs; they do not mint. **Gate 2 exact-set:** registry ≡ specs ≡ tasks (no unclaimed registry IDs, no invented feature IDs) — with one deliberate exception, anointed backlog (rule 5a).
5. **Coverage altitude.** A requirement counts as covered when its acceptance criteria are covered (or explicitly tracked as debt). **AC is the atomic unit of “covered”** and of Gate 2 silent-gap refusal. US/FR/NFR are planning altitude: they are not silent-gap candidates; the trace-manifest records them as `backlog` when they have no own carrier, not as `GAP`. Quiet waiting in the PRD with **no claim at all** is not allowed — that is exact-set drift, not a spec switch.
5a. **Anointed backlog.** Minting an ID is a promise, and the Gate holds you to it immediately. The deliberate way to mint ahead of the work: mint the ID **and** write one open `Carries:` TODO for it (conventionally in `specs/backlog/tasks.md`). The TODO is the claim — it proves intent and names who is carrying the item; the ID rides as `backlog` (ACs included: an anointed AC is not a *silent* gap). The moment a spec claims the ID, the anointment expires and normal rules apply. A typo’d ID in a spec never comes with a matching TODO, so drift still fails exact-set.
6. **Honest states.** Prefer named states over false greens:
   - **verified** — a named proof (AC) or `@covers`/proof (US/FR/NFR) exists (not “tests ran and passed” as a ceremony claim)
   - **tracked-debt** — work started (spec/impl presence), proof missing, but visible in an open task / backlog entry
   - **backlog** — US/FR/NFR without own carrier, or any ID anointed into backlog (registry entry + open `Carries:` TODO and nothing else); not a broken thread
   - **GAP** — silent AC gap; the Golden Thread is broken; Gate refuses
7. **Refusal.** Gate 1 (judgment, e.g. `/speckit.analyze`) and Gate 2 (deterministic check) fail closed on **silent AC gaps**, **untraced scope**, and **registry↔spec↔tasks drift**. Passing does not mean zero unfinished work; it means zero *hidden* unfinished work at AC altitude, and zero abandoned or invented IDs in the planning layer.
7a. **CI is the property line.** A Gate on a compliant laptop is courtesy and fast feedback. A cowboy (or a cold agent) with no local SpecAssay install can still push unmarked work. **Gate 2 must run in CI** on every PR and every commit to a protected branch, and must fail the build when the Golden Thread breaks. Local Gate is optional hygiene; CI Gate is what protects the codebase. The trace-manifest emitted on that run is the refusal's evidence trail.
8. **Trace-manifest.** Gate 2 emits a **trace-manifest** (default path `trace-manifest.json`) — a portable, vendor-neutral matrix (`format: "trace-manifest"`) including `gate: { ok, failures[] }` so non-row refusals (orphans, missing Carries, drift) are visible to viewers. The file is written even when the gate fails. It is not ReqIF/OSLC; see `docs/trace-manifest-schema.md`.
9. **Attribution is not authentication.** Optional operator stamps record claimed provenance in an already-trusted context. They enforce nothing about who may act.
10. **Viewer invariant.** Gate PASS ⇔ contiguous braid in Loupe; Gate FAIL ⇔ fray / Golden Thread broken. Red nodes may mark excused incompleteness without fray.

## What SpecAssay is not

- Not a fork of Spec Kit, and not a replacement for Spec Kit.
- Not Thorsten Schlathölter's `clew` (inner-loop constructor). SpecAssay is complementary altitude — promotion/refusal on the outer loop — and cites `clew` as prior art. The shared `trace-manifest` format is designed so `clew` and SpecAssay can both emit one for the same viewer.
- Not agent kanban / human-lane orchestration (that is a separate Loom-shaped concern).
- Not a visualizer. **Loupe** (or any viewer) may consume `trace-manifest.json`; viewers must not mint IDs or re-scan the target.

## Paste-ready constitution article

Add to `.specify/memory/constitution.md` (or feed `/speckit.constitution`):

> ### Article: End-to-End Traceability (NON-NEGOTIABLE)
>
> Every functional requirement, non-functional requirement, and acceptance criterion carries a durable unique ID of the form `<TYPE>-<DOMAIN>-<NN>` (e.g. `FR-LOG-01`, `AC-OFFL-03`). IDs are assigned once at the PRD level and are never reused or renumbered; retired IDs are tombstoned, not recycled.
>
> 1. Each acceptance criterion is **atomic** — one independently testable assertion — and maps to at least one automated test *or* an explicitly tracked debt entry. Silent-gap refusal is at **AC altitude**; US/FR/NFR IDs are planning labels (trace-manifest status `backlog`), not silent-gap candidates.
> 2. Every task in `tasks.md` MUST declare the ID(s) it implements via a `Carries:` field.
> 3. Every verifying test MUST encode the AC ID it protects. Every requirement-bearing source module MUST carry a coverage annotation naming the ID.
> 4. Coverage is **bidirectional** and machine-checked: no silent AC gaps, no untraced scope, and **exact-set** registry ≡ specs ≡ tasks (no abandoned PRD IDs, no invented feature IDs). **CI fails the build on any of these** — local Gate is hygiene; CI Gate is the property line.
> 5. `/speckit.analyze` MUST report zero SpecAssay traceability violations before `/speckit.implement` runs.
>
> ### Article: SpecAssay vocabulary
>
> Use these terms; do not invent synonyms (especially not “dossier”).
>
> | Term | Meaning |
> |------|---------|
> | **trace-manifest** | The Gate-emitted traceability artifact (`format: "trace-manifest"`). Default filename `trace-manifest.json`. |
> | **trace-manifest.json** | Usual on-disk path for a trace-manifest (configurable via Gate `manifest_path`). |
> | **SpecAssay** | Spec Kit overlay: durable IDs, Gate 2, trace-manifest emission. |
> | **Loupe** | Viewer that reads a trace-manifest only — no target re-scan. |
> | **verified** | Named carrier exists (AC proof and/or `@covers` / proof for US/FR/NFR). |
> | **tracked-debt** | Incomplete, but declared on an open task with `Carries:`. |
> | **GAP** | Silent AC gap — neither proof nor open debt; Gate refuses; the Golden Thread frays. |
> | **backlog** | US/FR/NFR with no own carrier, or any ID anointed into backlog (registry + open `Carries:` TODO only) — planning altitude, not a silent gap. |
> | **Gate 2** | Deterministic SpecAssay check + trace-manifest emit (`speckit.specassay.check`). |

## Lineage (name prior art first)

- Business / programme "golden thread" usage; Jonathan Smart, *Sooner Safer Happier*
- The UK "golden thread" of building-safety information (Hackitt review / Building Safety Act)
- Safety-critical requirements traceability matrices (avionics, medical, rail practice)
- GitHub Spec Kit (stock SDD workflow SpecAssay overlays)
- Thorsten Schlathölter — CAS-DD and open-source `clew` (inner-loop code-anchored specs); complementary altitude to SpecAssay's promotion/refusal focus
