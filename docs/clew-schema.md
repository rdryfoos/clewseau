# clew.json — Clewseau clew schema

Native Clewseau **clew** (matrix artifact). Gate 2 always emits this file (default path `clew.json`).

## Framing

- **Practice lineage:** software RTM discipline (safety-critical / Spec Kit outer loop). Not a claim of certification.
- **Not** OMG ReqIF or OSLC (requirements exchange / live linking). Those remain optional future adapters.
- **Not** W3C supply-chain “traceability” vocabularies.
- Filename nods to Ariadne’s clew and to complementary inner-loop work (Thorsten Schlathölter’s CAS-DD / `clew` tool) without colliding on the product name **Clewseau**.

## Top-level shape

| Field | Meaning |
|---|---|
| `schemaVersion` | `3` |
| `format` | Always `"clew"` |
| `emitter` | `"clewseau-gate"` |
| `targetName` | Project label |
| `repoPath` | Absolute path scanned |
| `generatedAt` | ISO-8601 UTC |
| `gate` | `{ ok: boolean, failures: GateFailure[] }` — full Gate refuse set (including non-row failures) |
| `totals` | `registryIdCount`, `acCount`, `coveredCount` |
| `statusCounts` | Counts for `verified`, `tracked-debt`, `GAP`, `backlog` |
| `rows` | Matrix rows |

### `gate.failures[]`

Each failure: `{ kind, detail, id? }`.

| `kind` | Meaning |
|---|---|
| `silent-gap` | AC with neither named proof nor open tracked-debt task |
| `orphan-covers` | `@covers` ID not in registry |
| `orphan-test` | Test-encoded ID not in registry |
| `missing-traces` | Checkbox task line without `Traces:` |
| `spec-orphan` / `task-orphan` | Spec or tasks reference an ID not in the registry |
| `spec-unclaimed` / `task-unclaimed` | Registry ID absent from specs or tasks (exact-set drift) |
| `registry-missing` | Configured registry file absent |

**Registry drift:** Gate 2 requires **exact set** match — registry IDs ≡ IDs found under configured `specs` globs ≡ IDs found under configured `tasks` globs. Feature specs inherit; they do not mint. Registry IDs may not wait unclaimed.

**Invariant for viewers:** Gate PASS (`gate.ok`) ⇔ contiguous descent braid; Gate FAIL ⇔ fray / clew broken. Tracked debt and excused incompleteness may still show red nodes without fray.

## Row shape

| Field | Meaning |
|---|---|
| `id` | Durable ID from the registry |
| `type` | `AC` / `FR` / `NFR` / `US` (prefix) |
| `statement` | Best-effort prose from the registry line |
| `registry` | `{ path, line }` where the ID sits in the registry (relative to `repoPath`); `null` if the registry file was unreadable |
| `status` | `verified` \| `tracked-debt` \| `GAP` \| `backlog` |
| `implementations` | `{ path, line, excerpt }` from coverage annotations |
| `proofs` | `{ name, path, line }` from test-encoded AC IDs |
| `debtTasks` | `{ path, line, excerpt }` open checkbox tasks that name this ID (usually via `Traces:`) — why `tracked-debt` is excused |
| `attestedBy` | Optional operator stamp; `null` until attribution exists |

### Status vocabulary (coverage altitude)

| Status | Who | Meaning |
|---|---|---|
| `verified` | AC: named proof; US/FR/NFR: `@covers` or named proof | Named carrier exists (not “tests ran green”) |
| `tracked-debt` | Any | Work started (spec/impl presence), proof missing, excused by an open task with Traces (`debtTasks` lists those tasks) |
| `GAP` | **AC only** (silent gap) | Neither named proof nor open debt — Gate refuses; viewer frays |
| `backlog` | Any | Planning altitude: US/FR/NFR without own carrier, or any ID **anointed into backlog** (registry entry + open `Traces:` TODO and nothing else) — **not** a silent gap; do not fray |

Backlog rows are “covered” in the promotion-contract sense when their child ACs are verified or debt — not by requiring `@covers` on the US/FR/NFR ID itself.

Older clew files may omit `debtTasks` / `registry` or still carry unused `blocked` / `blockedCount` fields. Gate emits `debtTasks` (possibly empty) and `registry` (possibly `null`); clewloupe treats missing fields as `[]` / absent.

## Consumers

**clewloupe** (viewer) reads `clew.json` only. It must not re-scan the target.
