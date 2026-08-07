# Clewseau — Promotion Contract

**Status:** normative gift. The idea is the product; the scripts are witnesses.

This is the refusal to promote work that will not carry an immutable ID, plus the honest states that replace green theater. Prior art is thick (safety-critical RTM practice; Jonathan Smart / Sooner Safer Happier "Golden Thread"; GitHub Spec Kit; Thorsten Schlathölter's CAS-DD / open-source `clew`). Clewseau's contribution is making admission cheap enough that AI-speed work still cannot hide.

## One sentence

Mint durable IDs at intent; refuse silent gaps; allow tracked debt to stay visible.

## Rules

1. **Mint at intent.** IDs are assigned once in the authoritative registry (usually the PRD), not inferred from code later. Feature specs inherit; they do not mint.
2. **Immutability.** Never renumber. Never reuse. Retire in place (tombstone), do not recycle.
3. **Atomic ACs.** One acceptance criterion, one independently testable assertion. Split compounds before Spec Kit ingests them.
4. **Propagation.** Every task declares `Traces:` with the ID(s) it serves. Implementation carriers name the ID (`@covers` or language equivalent). Verification names the AC in the test identifier. Feature specs inherit registry IDs; they do not mint. **Gate 2 exact-set:** registry ≡ specs ≡ tasks (no unclaimed registry IDs, no invented feature IDs) — with one deliberate exception, anointed backlog (rule 5a).
5. **Coverage altitude.** A requirement counts as covered when its acceptance criteria are covered (or explicitly tracked as debt). **AC is the atomic unit of “covered”** and of Gate 2 silent-gap refusal. US/FR/NFR are planning altitude: they are not silent-gap candidates; the clew records them as `backlog` when they have no own carrier, not as `GAP`. Quiet waiting in the PRD with **no claim at all** is not allowed — that is exact-set drift, not a spec switch.
5a. **Anointed backlog.** Minting an ID is a promise, and the Gate holds you to it immediately. The deliberate way to mint ahead of the work: mint the ID **and** write one open `Traces:` TODO for it (conventionally in `specs/backlog/tasks.md`). The TODO is the claim — it proves intent and names who is carrying the item; the ID rides as `backlog` (ACs included: an anointed AC is not a *silent* gap). The moment a spec claims the ID, the anointment expires and normal rules apply. A typo’d ID in a spec never comes with a matching TODO, so drift still fails exact-set.
6. **Honest states.** Prefer named states over false greens:
   - **verified** — a named proof (AC) or `@covers`/proof (US/FR/NFR) exists (not “tests ran and passed” as a ceremony claim)
   - **tracked-debt** — work started (spec/impl presence), proof missing, but visible in an open task / backlog entry
   - **backlog** — US/FR/NFR without own carrier, or any ID anointed into backlog (registry entry + open `Traces:` TODO and nothing else); not a broken thread
   - **GAP** — silent AC gap; thread broken; Gate refuses
7. **Refusal.** Gate 1 (judgment, e.g. `/speckit.analyze`) and Gate 2 (deterministic check) fail closed on **silent AC gaps**, **untraced scope**, and **registry↔spec↔tasks drift**. Passing does not mean zero unfinished work; it means zero *hidden* unfinished work at AC altitude, and zero abandoned or invented IDs in the planning layer.
7a. **CI is the property line.** A Gate on a compliant laptop is courtesy and fast feedback. A cowboy (or a cold agent) with no local Clewseau install can still push unmarked work. **Gate 2 must run in CI** on every PR and every commit to a protected branch, and must fail the build when the Thread breaks. Local Gate is optional hygiene; CI Gate is what protects the codebase. The clew emitted on that run is the refusal's evidence trail.
8. **Clew.** Gate 2 emits a **clew** (default path `clew.json`) — a Clewseau-native matrix (`format: "clew"`) including `gate: { ok, failures[] }` so non-row refusals (orphans, missing Traces, drift) are visible to viewers. The file is written even when the gate fails. It is not ReqIF/OSLC; see `docs/clew-schema.md`.
9. **Attribution is not authentication.** Optional operator stamps record claimed provenance in an already-trusted context. They enforce nothing about who may act.
10. **Viewer invariant.** Gate PASS ⇔ contiguous braid in clewloupe; Gate FAIL ⇔ fray / clew broken. Red nodes may mark excused incompleteness without fray.

## What Clewseau is not

- Not a fork of Spec Kit, and not a replacement for Spec Kit.
- Not Thorsten Schlathölter's `clew` (inner-loop constructor). Cite it; do not collide with the name.
- Not agent kanban / human-lane orchestration (that is a separate Loom-shaped concern).
- Not a visualizer. **clewloupe** (or any viewer) may consume `clew.json`; viewers must not mint IDs or re-scan the target.

## Paste-ready constitution article

Add to `.specify/memory/constitution.md` (or feed `/speckit.constitution`):

> ### Article: End-to-End Traceability (NON-NEGOTIABLE)
>
> Every functional requirement, non-functional requirement, and acceptance criterion carries a durable unique ID of the form `<TYPE>-<DOMAIN>-<NN>` (e.g. `FR-LOG-01`, `AC-OFFL-03`). IDs are assigned once at the PRD level and are never reused or renumbered; retired IDs are tombstoned, not recycled.
>
> 1. Each acceptance criterion is **atomic** — one independently testable assertion — and maps to at least one automated test *or* an explicitly tracked debt entry. Silent-gap refusal is at **AC altitude**; US/FR/NFR IDs are planning labels (clew status `backlog`), not silent-gap candidates.
> 2. Every task in `tasks.md` MUST declare the ID(s) it implements via a `Traces:` field.
> 3. Every verifying test MUST encode the AC ID it protects. Every requirement-bearing source module MUST carry a coverage annotation naming the ID.
> 4. Coverage is **bidirectional** and machine-checked: no silent AC gaps, no untraced scope, and **exact-set** registry ≡ specs ≡ tasks (no abandoned PRD IDs, no invented feature IDs). **CI fails the build on any of these** — local Gate is hygiene; CI Gate is the property line.
> 5. `/speckit.analyze` MUST report zero Clewseau traceability violations before `/speckit.implement` runs.
>
> ### Article: Clewseau vocabulary
>
> Use these terms; do not invent synonyms (especially not “dossier”).
>
> | Term | Meaning |
> |------|---------|
> | **clew** | The Gate-emitted traceability artifact (`format: "clew"`). Default filename `clew.json`. |
> | **clew.json** | Usual on-disk path for a clew (configurable via Gate `clew_path`). |
> | **Clewseau** | Spec Kit overlay: durable IDs, Gate 2, clew emission. Not Thorsten Schlathölter’s open-source `clew` tool. |
> | **clewloupe** | Viewer that consumes a clew only — no target re-scan. |
> | **verified** | Named carrier exists (AC proof and/or `@covers` / proof for US/FR/NFR). |
> | **tracked-debt** | Incomplete, but declared on an open task with `Traces:`. |
> | **GAP** | Silent AC gap — neither proof nor open debt; Gate refuses; thread frays. |
> | **backlog** | US/FR/NFR with no own carrier, or any ID anointed into backlog (registry + open `Traces:` TODO only) — planning altitude, not a silent gap. |
> | **Gate 2** | Deterministic Clewseau check + clew emit (`speckit.clewseau-gate.check`). |

## Lineage (name prior art first)

- Business / programme "golden thread" usage; Jonathan Smart, *Sooner Safer Happier*
- Safety-critical requirements traceability matrices (avionics, medical, rail practice)
- GitHub Spec Kit (stock SDD workflow Clewseau overlays)
- Thorsten Schlathölter — CAS-DD and open-source `clew` (inner-loop code-anchored specs); complementary altitude to Clewseau's promotion/refusal focus
