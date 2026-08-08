# Scope, the pull request, and requirement PRs

> **Status: design note.** Every claim below is tagged **(shipped)** — true of
> the gate as it stands today — or **(proposed)** — intended direction, not yet
> built. SpecAssay does not describe unbuilt behavior as real; neither does this
> file.

SpecAssay hallmarks the Golden Thread from wish to work to proof. This note is
about the *edge* of that guarantee: what a passing Gate does and does not
promise, why the pull request is the backstop for the rest, and how the same
durable IDs that make the forward thread possible can carry pull requests that
change the requirements themselves.

## 1. Completeness, not minimality (shipped)

Gate 2 walks in one direction only: **requirement → work → proof**. It reads the
registry, the specs, and the tasks; it opens source files *only* to pull out
`@covers` marks and test names. Everything it refuses is a hole in *declared*
intent:

- **exact-set drift** — registry ≢ specs, or registry ≢ tasks
- **missing `Carries:`** — a task that names no ID
- **untraced scope** — an `@covers` or test whose ID **is not in the registry**
- **silent AC gap** — a registry AC with neither a test nor an open `Carries:` TODO

Read that third one carefully, because its name misleads: *"untraced scope"*
fires when code claims a **fake** ID, never when code claims **no** ID. The gate
never enumerates the source tree and asks "does this file correspond to a
requirement?" There is no **work → requirement** direction.

The consequence is a precise scope line:

> A passing Gate proves **completeness of declared intent** — every wish you
> wrote down is built and proven, with nothing *hidden* at AC altitude. It does
> **not** prove **minimality** — that nothing was built *beyond* what was wished
> for.

This is by design, not oversight. You do **not** paste an ID onto every line of
code (see the field guide) — most legitimate code is unmarked, so the gate
*cannot* treat unmarked code as suspicious. An honest developer who takes a
side-track and writes something nobody asked for — unmarked — is invisible to
the Gate; the build stays green and the Thread reads intact. Two further limits
sharpen the point:

- **Attribution is not authentication** (Promotion Contract, rule 9). `@covers`
  is author-written; the Gate trusts the mark, it never validates the code
  behind it.
- **`verified` is a traceability claim, not a quality claim.** It means a test
  *names* the AC — not that the code is correct or that the test asserts
  anything. An empty `test_AC_…()` still reads `verified`.

Even the "bidirectional" language in the constitution is bidirectional over
**IDs** (no gaps forward, no invented IDs backward), not over **code**.

## 2. The backstop is the pull request (shipped)

Catching *undeclared* work is not the Gate's job; it is the job of the human
layer SpecAssay sits beside — the **pull request** and **Gate 1 judgment**
(`/speckit.analyze`). SpecAssay is explicit that it is not a replacement for
Spec Kit and not the judgment layer.

This backstop is **necessary but not sufficient**, and it is weakest in exactly
the conditions SpecAssay exists for:

- **Volume is the enemy of review.** The side-track problem is worst when a lot
  of code arrives fast — the same velocity that makes reviewers skim.
- **Green can lower vigilance.** A single "Gate green · Thread intact" signal
  borrows credibility for *everything* in the diff, including the parts the Gate
  never looked at. Automation bias means the tool can inadvertently provide
  cover for the one thing it cannot see.

The design response is **not** to add a refusal. It is to make the review
*legible*: decompose the single green check into named claims, and hand the
reviewer a spotlight on what traces to nothing. That is the roadmap in §3–4.

## 3. The pull request as a briefing (proposed)

Threat model: the **honest** developer who side-tracks, not the adversary who
mislabels. For honest developers the goal is not to *refuse* — it is to make the
discrepancy cheap to see and cheap to reconcile. Two reframes make this
low-friction (often friction-*negative*):

1. **Illuminate, don't refuse.** Compute and surface; never gate on undeclared
   code (that would false-positive on every legitimate refactor).
2. **Diff, not repo.** Ask the bidirectional question of the **PR diff**, not
   the whole tree. The diff is small, it is already the review unit, and it is
   the one altitude where work → requirement is affordable.

### 3a. The manifest diff (proposed)

Gate 2 already emits a trace-manifest per commit, so CI has two: **base** and
**PR head**. Diff them, and diff the code, and bucket every changed file:

- **on-thread** — gained/holds an `@covers`, is a test naming an AC, or is a
  registry / spec / task edit
- **off-thread** — changed, but nothing in or near it touches any requirement in
  this PR

The off-thread bucket is where a side-track hides — now a short, named list,
computed for free, requiring no new marks. **Ceiling, stated honestly:** this
cannot tell a legitimate refactor from unwanted scope; both land off-thread.
What it does is collapse the reviewer's search space from *the whole diff* to
*the untraced subset*, and label it. For an honest team that is the whole game.

### 3b. The Thread Report (proposed)

On every PR, SpecAssay posts a generated briefing — friction-negative, because
the developer receives more than they give:

- **what moved** — statuses that changed (backlog → verified, proofs added, IDs
  minted or retired): the manifest diff in prose
- **story-scoped view** — "this PR advances US-X; here is its thread now, end to
  end"
- **the off-thread list** — as a one-click acknowledgment: *"these untraced
  changes are incidental (refactor / deps / plumbing)."* The tick is a record,
  not a gate.
- **requirement changes** — see §4

This is the direct counter to the automation-bias trap: not one green check, but
the green decomposed into legible claims, including an explicit "here is what
traces to nothing."

## 4. Pull requests that change requirements (proposed)

The reason SpecAssay is *unusually* suited to this: mint-at-intent, immutable
IDs, and registry-as-source-of-truth already made requirements **first-class
version-controlled artifacts with stable identity.** A wish is diffable,
reviewable, and mergeable — keyed by an ID that survives the change. Most shops
cannot meaningfully PR a requirement because their requirements live in a ticket
tracker with no durable identity; here they live in git.

What SpecAssay can add on top:

- **Legible requirement diffs.** A PR touching the registry shows IDs *added*
  (minted), *retired* (tombstoned), *restated* (wording changed). Immutability
  becomes a cheap, rare, high-value gate on the diff: renumber or reuse an ID →
  fail. It almost never fires, so it costs no friction.

- **Blast-radius on intent change** — the integrity property from the
  *Bidirectional Traceability* field note, made mechanical. When an AC's
  statement changes, its carriers (the `@covers` code and the `test_AC_…` proof)
  were written against the *old* wording. SpecAssay lists them and marks them
  **"re-confirm — the wish moved under the proof."** The PR that changes the
  requirement carries its own list of what it may have invalidated.

- **Two honest shapes of requirement-PR:**
  - **Requirement-only PR** (intent changes, no code): the changed ID rides as
    `backlog` — minted, no carrier yet. The Gate stays green *and honest*:
    "intent moved; here is the new open thread." A later code PR closes it; the
    durable ID stitches the two across time.
  - **Discovery PR** (mid-build, the spec was found wrong): changes the
    requirement *and* the code together, reviewed as one, the thread showing both
    moved in lockstep. SpecAssay's job is coherence — no orphaned proofs, no ACs
    pointing at deleted code, immutability intact.

## 5. Friction stance and build order (proposed)

A bolt-alongside **gate** on undeclared code is both high-friction and wrong for
honest developers. So we **refuse to build the refusal.** Everything above is
assistive except two gates that are cheap, rare, and genuinely worth it:

- **immutability** — never renumber, never reuse
- **coherence after a requirement change** — no orphaned proofs

Build order, converging strategies rather than one silver bullet:

1. **Manifest diff + Thread Report** (§3) — a script over data already emitted,
   plus a Loupe "PR view" that diffs two manifests. Friction-negative. Build
   first.
2. **Requirement-diff legibility + immutability gate** (§4) — small.
3. **Blast-radius / re-confirm on intent change** (§4) — the highest-leverage
   piece for anyone who values the bidirectional thread.
4. **Full requirement-PR workflow** (§4) — the destination.

None of it asks the developer to tag more code. The value comes from *reading
the diff against the thread you already have* and *handing author and reviewer a
briefing instead of a checkmark.*
