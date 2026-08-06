# Reading a clew

How to read a Clewseau **clew** (`clew.json`) in ordinary SDLC terms — requirement → build → proof — then what Gate emits and what **clewloupe** paints.

Schema details live in [`clew-schema.md`](./clew-schema.md). This guide is the workflow story.

## What a clew is

Gate 2 scans your Spec Kit project (registry / PRD, specs, tasks, `@covers`, named tests) and writes a **clew**: a matrix of durable IDs with honest status. Default path is repo-root `clew.json`. Portable samples use `{name}.clew.json`.

**clewloupe** only reads that file. It does not re-scan the target.

Passing Gate does **not** mean zero unfinished work. It means zero *hidden* unfinished work at acceptance-criterion altitude, plus exact-set inventory (registry ≡ specs ≡ tasks).

## How to read one row

For any ID, ask in this order:

1. **Where does the requirement live?** (PRD / registry statement)
2. **What build / tasks are done vs open?** (`Traces:` on checkbox tasks)
3. **What carriers exist?** (`@covers` in source; named tests encoding the AC)
4. **What did Gate therefore emit?** (`status`, `implementations[]`, `proofs[]`)
5. **What does clewloupe paint?** Requirement / Implementation / Proof colors; **fray** only when `GAP` or `gate.ok: false`

### Status in one line

| Status | SDLC meaning |
|--------|----------------|
| **verified** | Named proof (and/or `@covers` where required by altitude) exists — not “tests happened to pass.” |
| **tracked-debt** | Team knew it wasn’t done and left an open `Traces:` task — visible unfinished work. |
| **GAP** | AC with neither proof nor open debt — **hidden** unfinished work; Gate fails; braid frays. |
| **backlog** | US/FR/NFR with no own carrier — planning altitude waiting; not a silent AC gap. |

Silent-gap refusal is **AC-only**. Parents are covered when their child ACs are verified or debt — not by sticking `@covers US-…` on a file.

### Colors vs fray (clewloupe)

| Signal | Meaning |
|--------|---------|
| Green node | Carrier present for that step |
| Red, braid solid | Incomplete but excused (debt, missing `@covers`, empty backlog proof) while Gate passed |
| Fray / Gate-failed chrome | Thread broken: silent AC gap or other Gate refusal (`gate.ok: false`) |

## Worked examples (HomesFlow)

HomesFlow’s live clew at session time: `gate.ok: true`, roughly 61 verified / 13 tracked-debt / 0 GAP / 5 backlog. `samples/homesflow.clew.json` is that real emit; `samples/sample.clew.json` is the preview default (honest today; may later be mocked for cases HomesFlow doesn’t emit).

### `AC-GUEST-01` → verified

1. **Requirement:** PRD owns guest visibility — Guest sees only guest-marked fields; edit controls disabled.
2. **Build:** Guest restriction work is done and traced in tasks.
3. **Carriers:** `@covers AC-GUEST-01, …` on the guest test module; named proof `test_AC_GUEST_01_guest_fields_only`.
4. **Clew:** `implementations: [{…}]`, `proofs: [{ name: test_AC_GUEST_01_… }]`, status `verified`.
5. **Loupe:** Requirement / Implementation / Proof green (or Implementation green from `@covers` and Proof green from the named test). Braid solid.

`AC-A11Y-01` is the same story with proofs only (named accessibility tests, empty `implementations[]`): still `verified` because AC altitude keys on the named proof.

### `AC-HOME-09` → tracked-debt

1. **Requirement:** PRD owns AC-HOME-09 — iPad trailing column is content only (no full-bleed hero / home-level tab bar).
2. **Build done:** `T021a` checked off (iPad shell layout).
3. **Proof still open:** `T024d` — snapshot/UI test, deferred until XCUITest/snapshot infra; manual iPad pass until then. `Traces: AC-HOME-09`.
4. **Clew:** `implementations: []`, `proofs: []`, status `tracked-debt` (ID on an open checkbox task; no named proof).
5. **Loupe:** Requirement red (debt) **with open `Traces:` task listed**; Implementation red (no `@covers`); Proof red-not-fray (“No proof — tracked as debt”); braid solid if `gate.ok`.

### `AC-HOME-10` → tracked-debt (build further along)

1. **Requirement:** PRD owns AC-HOME-10 — iPad leading column: compact hero + vertical icon tabs; three-panel trailing for all sections.
2. **Build done:** `T021a`, `T021c` checked off.
3. **Implementation carrier:** code has `@covers AC-HOME-10` (Implementation hit — not a named AC proof).
4. **Proof still open:** `T024e` — snapshot/UI test for leading column; same deferred note. `Traces: AC-HOME-10`.
5. **Clew:** `implementations: [{…}]`, `proofs: []`, status `tracked-debt`.
6. **Loupe:** Requirement red (debt) **with open `Traces:` task listed**; Implementation green + expandable **▸ @covers** source; Proof red-not-fray; braid solid if Gate passed.

### `US-EDIT-01` / `FR-GUEST-02` → backlog

1. **Requirement:** Story or feature ID lives in the registry (planning altitude).
2. **Build / claim:** May already have child AC work; the US/FR itself often has no personal `@covers` or named proof.
3. **Carriers for this ID:** none required at this altitude.
4. **Clew:** empty arrays, status `backlog` — not `GAP`.
5. **Loupe:** muted / red-not-fray on empty steps; braid stays solid when Gate passed. Do not fray a story label for lacking its own carrier.

### What a `GAP` would look like (HomesFlow has none)

If an **AC** had no named proof **and** no open `Traces:` task:

1. Requirement still in the PRD.
2. Build may look “done” in conversation — but nothing durable claims the unfinished proof.
3. No carriers.
4. Clew: status `GAP`; Gate adds `silent-gap` to `gate.failures[]`; `gate.ok: false`.
5. Loupe: fray + Gate-failed chrome.

That is the difference between **tracked-debt** (visible unfinished work) and **GAP** (hidden unfinished work). HomesFlow has zero GAPs today; a mocked `sample.clew.json` can show fray later without changing the real HomesFlow emit.

## Where this sits in the Spec Kit loop

```text
PRD / registry  →  specs inherit IDs  →  tasks with Traces:
        ↓
   implement + @covers + named AC tests
        ↓
   Gate 2 (exact-set + AC silent-gap refusal)  →  clew.json
        ↓
   clewloupe (view only)
```

Gate 1 judgment (`/speckit.analyze` and human review) still matters. Gate 2 is the deterministic witness that refuses silent AC gaps and inventory drift, then leaves a clew anyone can open without re-running the scan.

## Further reading

- [`../PROMOTION-CONTRACT.md`](../PROMOTION-CONTRACT.md) — normative rules
- [`clew-schema.md`](./clew-schema.md) — field-level shape
- [`../presets/clewseau/GLOSSARY.md`](../presets/clewseau/GLOSSARY.md) — locked vocabulary
- [`../samples/README.md`](../samples/README.md) — regenerating the HomesFlow sample
