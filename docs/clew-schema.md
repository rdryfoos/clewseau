# clew.json — Clewseau dossier schema

Native Clewseau matrix artifact. Gate 2 always emits this file (default path `clew.json`).

## Framing

- **Practice lineage:** software RTM discipline (safety-critical / Spec Kit outer loop). Not a claim of certification.
- **Not** OMG ReqIF or OSLC (requirements exchange / live linking). Those remain optional future adapters.
- **Not** W3C supply-chain “traceability” vocabularies.
- Filename nods to Ariadne’s clew and to complementary inner-loop work (Thorsten Schlathölter’s CAS-DD / `clew` tool) without colliding on the product name **Clewseau**.

## Top-level shape

| Field | Meaning |
|---|---|
| `schemaVersion` | `3` (row status axis + orthogonal `blocked`) |
| `format` | Always `"clew"` |
| `emitter` | `"clewseau-gate"` |
| `targetName` | Project label |
| `repoPath` | Absolute path scanned |
| `generatedAt` | ISO-8601 UTC |
| `totals` | `registryIdCount`, `acCount`, `coveredCount` |
| `statusCounts` | Counts for `verified`, `tracked-debt`, `GAP` |
| `blockedCount` | Rows with `blocked: true` |
| `rows` | Matrix rows |

## Row shape

| Field | Meaning |
|---|---|
| `id` | Durable ID from the registry |
| `type` | `AC` / `FR` / `NFR` / `US` (prefix) |
| `statement` | Best-effort prose from the registry line |
| `status` | `verified` \| `tracked-debt` \| `GAP` |
| `blocked` | Orthogonal hold flag (Gate 2 leaves `false` until a blocked source exists) |
| `implementations` | `{ path, line, excerpt }` from coverage annotations |
| `proofs` | `{ name, path, line }` from test-encoded AC IDs |
| `attestedBy` | Optional operator stamp; `null` until attribution exists |

**verified** means a named proof exists — not that tests were executed green by this emitter.

## Consumers

**clewloupe** (viewer) reads `clew.json` only. It must not re-scan the target.
