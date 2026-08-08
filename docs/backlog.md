# SpecAssay backlog — hypotheses to test

Product-level open questions, minted so they don't evaporate. Not code tasks —
things we believe or suspect and want to put to the test.

## H1 — Does SpecAssay only work in a greenfield environment?

**Status:** anointed backlog (minted, carried by this note, not yet tested).

**Hypothesis to falsify:** SpecAssay only makes sense when a project (and the
org around it) starts fresh — durable IDs from day one, no legacy sea, Spec Kit
already in hand.

**Why we suspect it's *false* (codebase axis):** the gate governs only
*declared* intent; it never enumerates all code, so un-marked legacy is invisible
to it. That is the same "blind spot" that lets un-marked vibe-code slip past — and
it is precisely what makes brownfield adoption tractable. You **govern the
margin**: mint IDs for new intent, mark that slice, and the gate checks only that
thread. The registry *is* the scope boundary — start it empty, grow it one intent
at a time. `tracked-debt` and `anointed backlog` are the on-ramp for legacy
behavior you can't prove yet: admit it, don't refuse the whole repo.

**Where it might actually bite (org axis):** "greenfield *business* environment"
is the harder read. An established org with entrenched Jira / RTM / compliance
tooling and no Spec Kit is a bigger adoption gap than any legacy codebase.
Process inertia and politics, not the technique, are the real risk. HomesFlow was
greenfield on *both* axes, so the incremental-brownfield story is untested.

**How we'd test it:** adopt SpecAssay on a real brownfield repo for *new work
only* — empty/small registry, mark just the new intents, leave the legacy
un-gated — and see whether the thread grows cleanly at the margin without a
retrofit, and whether a team actually tolerates the ceremony mid-stream.
