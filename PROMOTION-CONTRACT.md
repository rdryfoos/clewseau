# Clewseau — Promotion Contract

**Status:** normative gift. The idea is the product; the scripts are witnesses.

This is the refusal to promote work that will not carry an immutable ID, plus the honest states that replace green theater. Prior art is thick (safety-critical RTM practice; Jonathan Smart / Sooner Safer Happier "Golden Thread"; GitHub Spec Kit; Thorsten Schlathölter's CAS-DD / open-source `clew`). Clewseau's contribution is making admission cheap enough that AI-speed work still cannot hide.

## One sentence

Mint durable IDs at intent; refuse silent gaps; allow tracked debt to stay visible.

## Rules

1. **Mint at intent.** IDs are assigned once in the authoritative registry (usually the PRD), not inferred from code later. Feature specs inherit; they do not mint.
2. **Immutability.** Never renumber. Never reuse. Retire in place (tombstone), do not recycle.
3. **Atomic ACs.** One acceptance criterion, one independently testable assertion. Split compounds before Spec Kit ingests them.
4. **Propagation.** Every task declares `Traces:` with the ID(s) it serves. Implementation carriers name the ID (`@covers` or language equivalent). Verification names the AC in the test identifier.
5. **Coverage altitude.** A requirement counts as covered only when its acceptance criteria are covered (or explicitly tracked as debt). AC is the atomic unit of "covered."
6. **Honest states.** Prefer named states over false greens:
   - **verified** — a named proof exists (not "tests ran and passed" as a ceremony claim)
   - **tracked-debt** — proof missing, but visible in an open task / backlog entry
   - **blocked** — cannot proceed; reason recorded
   - **GAP** — silent gap; thread broken
7. **Refusal.** Gate 1 (judgment, e.g. `/speckit.analyze`) and Gate 2 (deterministic check) fail closed on silent gaps and untraced scope. Passing does not mean zero gaps; it means zero *hidden* ones.
8. **Dossier.** Gate 2 emits `clew.json` — a Clewseau-native matrix (`format: "clew"`). The file is written even when the gate fails. It is not ReqIF/OSLC; see `docs/clew-schema.md`.
9. **Attribution is not authentication.** Optional operator stamps record claimed provenance in an already-trusted context. They enforce nothing about who may act.

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
> 1. Each acceptance criterion is **atomic** — one independently testable assertion — and maps to at least one automated test *or* an explicitly tracked debt entry.
> 2. Every task in `tasks.md` MUST declare the ID(s) it implements via a `Traces:` field.
> 3. Every verifying test MUST encode the AC ID it protects. Every requirement-bearing source module MUST carry a coverage annotation naming the ID.
> 4. Coverage is **bidirectional** and machine-checked: no silent AC gaps, and no untraced scope. CI fails the build on either.
> 5. `/speckit.analyze` MUST report zero Clewseau traceability violations before `/speckit.implement` runs.

## Lineage (name prior art first)

- Business / programme "golden thread" usage; Jonathan Smart, *Sooner Safer Happier*
- Safety-critical requirements traceability matrices (avionics, medical, rail practice)
- GitHub Spec Kit (stock SDD workflow Clewseau overlays)
- Thorsten Schlathölter — CAS-DD and open-source `clew` (inner-loop code-anchored specs); complementary altitude to Clewseau's promotion/refusal focus
