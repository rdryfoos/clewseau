# Reading a trace-manifest

How to read a SpecAssay **trace-manifest** (`trace-manifest.json`) in ordinary SDLC terms — requirement → build → proof — then what Gate emits and what **Loupe** paints.

Schema details live in [`trace-manifest-schema.md`](./trace-manifest-schema.md). This guide is the workflow story.

## What a trace-manifest is

SpecAssay's Gate 2 scans your Spec Kit project (registry / PRD, specs, tasks, `@covers`, named tests) and writes a **trace-manifest**: a matrix of durable IDs with honest status. Default path is repo-root `trace-manifest.json`. Portable samples use `{name}.trace-manifest.json`.

**Loupe** only reads that file. It does not re-scan the target.

Passing Gate does **not** mean zero unfinished work. It means zero *hidden* unfinished work at acceptance-criterion altitude, plus exact-set inventory (registry ≡ specs ≡ tasks).

## How to read one row

For any ID, ask in this order:

1. **Where does the requirement live?** (PRD / registry statement)
2. **What build / tasks are done vs open?** (`Carries:` on checkbox tasks)
3. **What carriers exist?** (`@covers` in source; named tests encoding the AC)
4. **What did Gate therefore emit?** (`status`, `implementations[]`, `proofs[]`)
5. **What does Loupe paint?** Requirement / Implementation / Proof colors; **fray** only when `GAP` or `gate.ok: false`

### Status in one line

| Status | SDLC meaning |
|--------|----------------|
| **verified** | Named proof (and/or `@covers` where required by altitude) exists — not “tests happened to pass.” |
| **tracked-debt** | Work started (spec or code exists) but proof is missing, excused by an open `Carries:` task — visible unfinished work. |
| **GAP** | AC with neither proof nor open debt — **hidden** unfinished work; Gate fails; the braid frays. |
| **backlog** | Planning altitude: US/FR/NFR with no own carrier, **or** any ID **anointed into backlog** — minted in the registry with an open `Carries:` TODO and nothing else. |

Silent-gap refusal is **AC-only**. Parents are covered when their child ACs are verified or debt — not by sticking `@covers US-…` on a file.

**Minting an ID is a promise, and the Gate holds you to it immediately.** A registry ID claimed nowhere fails exact-set (that is drift — often a fat-fingered rename in a spec). The deliberate way to mint ahead of the work is **anointed backlog**: mint the ID *and* write one open `Carries:` TODO for it (a conventional home is `specs/backlog/tasks.md`, which the standard tasks glob already matches). The TODO proves intent, names who is carrying the item, and the ID rides as `backlog` — visible, not silent — until a spec claims it and normal rules take over. A typo’d ID never comes with a matching TODO, so the drift tripwire still fires.

### Colors vs fray (Loupe)

| Signal | Meaning |
|--------|---------|
| Green node | Carrier present for that step |
| Red, braid solid | Incomplete but excused (debt, missing `@covers`, empty backlog proof) while the Golden Thread is intact |
| Fray / red banner | Golden Thread broken: silent AC gap or other refusal (`gate.ok: false` — Gate refused the manifest) |

## Worked examples (HomesFlow)

HomesFlow’s live trace-manifest at session time: `gate.ok: true`, 67 verified / 10 tracked-debt / 0 GAP / 4 backlog (81 rows). `samples/homesflow.trace-manifest.json` is that real emit; `samples/sample.trace-manifest.json` is the preview default (honest today; may later be mocked for cases HomesFlow doesn’t emit).

### `AC-GUEST-01` → verified

1. **Requirement:** PRD owns guest visibility — Guest sees only guest-marked fields; edit controls disabled.
2. **Build:** Guest restriction work is done and traced in tasks.
3. **Carriers:** `@covers AC-GUEST-01, …` on the guest test module; named proof `test_AC_GUEST_01_guest_fields_only`.
4. **Manifest:** `implementations: [{…}]`, `proofs: [{ name: test_AC_GUEST_01_… }]`, status `verified`.
5. **Loupe:** Requirement / Implementation / Proof green (or Implementation green from `@covers` and Proof green from the named test). Braid solid.

`AC-A11Y-01` is the same story with proofs only (named accessibility tests, empty `implementations[]`): still `verified` because AC altitude keys on the named proof.

### `AC-HOME-09` → tracked-debt

1. **Requirement:** PRD owns AC-HOME-09 — iPad trailing column is content only (no full-bleed hero / home-level tab bar).
2. **Build done:** `T021a` checked off (iPad shell layout).
3. **Proof still open:** `T024d` — snapshot/UI test, deferred until XCUITest/snapshot infra; manual iPad pass until then. `Carries: AC-HOME-09`.
4. **Manifest:** `implementations: []`, `proofs: []`, status `tracked-debt` (ID on an open checkbox task; no named proof).
5. **Loupe:** Requirement red (debt) **with open `Carries:` task listed**; Implementation red (no `@covers`); Proof red-not-fray (“No proof — tracked as debt”); braid solid if `gate.ok`.

### `AC-HOME-10` → tracked-debt (build further along)

1. **Requirement:** PRD owns AC-HOME-10 — iPad leading column: compact hero + vertical icon tabs; three-panel trailing for all sections.
2. **Build done:** `T021a`, `T021c` checked off.
3. **Implementation carrier:** code has `@covers AC-HOME-10` (Implementation hit — not a named AC proof).
4. **Proof still open:** `T024e` — snapshot/UI test for leading column; same deferred note. `Carries: AC-HOME-10`.
5. **Manifest:** `implementations: [{…}]`, `proofs: []`, status `tracked-debt`.
6. **Loupe:** Requirement red (debt) **with open `Carries:` task listed**; Implementation green + expandable **▸ file:line** source; Proof red-not-fray; braid solid while the Golden Thread is intact.

### `US-EDIT-01` / `FR-GUEST-02` → backlog

1. **Requirement:** Story or feature ID lives in the registry (planning altitude).
2. **Build / claim:** May already have child AC work; the US/FR itself often has no personal `@covers` or named proof.
3. **Carriers for this ID:** none required at this altitude.
4. **Manifest:** empty arrays, status `backlog` — not `GAP`.
5. **Loupe:** muted / red-not-fray on empty steps; braid stays solid while the Golden Thread is intact. Do not fray a story label for lacking its own carrier.

### `US-CLEW-01` / `FR-CLEW-01` / `AC-CLEW-01` → anointed backlog

1. **Requirement:** Rik decided the SpecAssay-native HomesFlow slice is wanted and minted its IDs into the PRD — no spec, no tasks, no code yet. (These IDs predate the rename and are scheduled for tombstoning as a temporary probe; they are left in place to demonstrate durability.)
2. **Anointment:** one open TODO in `specs/backlog/tasks.md` — `- [ ] T900 Deliver … — **Carries**: US-CLEW-01, FR-CLEW-01, AC-CLEW-01`.
3. **Carriers:** none — and that’s the point; the TODO is the only thread.
4. **Manifest:** status `backlog` for all three (yes, the AC too — an anointed AC isn’t a *silent* gap; the TODO names it), `debtTasks` lists the carrying TODO, `gate.ok: true`.
5. **Loupe:** muted / red-not-fray with the carrying TODO visible under the Requirement. Delete the TODO without picking the work up and the Gate fails exact-set on the next run.

### What a `GAP` would look like (HomesFlow has none)

If an **AC** had no named proof **and** no open `Carries:` task:

1. Requirement still in the PRD.
2. Build may look “done” in conversation — but nothing durable claims the unfinished proof.
3. No carriers.
4. Manifest: status `GAP`; Gate adds `silent-gap` to `gate.failures[]`; `gate.ok: false`.
5. Loupe: fray + Gate-failed chrome.

That is the difference between **tracked-debt** (visible unfinished work) and **GAP** (hidden unfinished work). HomesFlow has zero GAPs today; a mocked `sample.trace-manifest.json` can show fray later without changing the real HomesFlow emit.

## Where this sits in the Spec Kit loop

```text
PRD / registry  →  specs inherit IDs  →  tasks with Carries:
        ↓
   implement + @covers + named AC tests
        ↓
   Gate 2 (exact-set + AC silent-gap refusal)  →  trace-manifest.json
        ↓
   Loupe (view only)
```

Gate 1 judgment (`/speckit.analyze` and human review) still matters. Gate 2 is the deterministic witness that refuses silent AC gaps and inventory drift, then leaves a trace-manifest anyone can open without re-running the scan.

## Further reading

- [`loupe-field-guide.md`](./loupe-field-guide.md) — the same story with screenshots
- [`../PROMOTION-CONTRACT.md`](../PROMOTION-CONTRACT.md) — normative rules
- [`trace-manifest-schema.md`](./trace-manifest-schema.md) — field-level shape
- [`../presets/specassay/GLOSSARY.md`](../presets/specassay/GLOSSARY.md) — locked vocabulary
- [`../samples/README.md`](../samples/README.md) — regenerating the HomesFlow sample
