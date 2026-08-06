

<!-- Clewseau (append) — durable ID discipline -->

## Clewseau — durable IDs (required)

Every requirement and acceptance criterion MUST carry a durable ID per the project Clewseau / traceability standard.

- IDs are assigned **once at the PRD (registry) level**. This feature spec **inherits** them; do **not** mint new IDs here.
- Grammar: `<TYPE>-<DOMAIN>-<NN>` where TYPE is `US` | `FR` | `NFR` | `AC` (example: `AC-SYNC-04`).
- Acceptance criteria are **atomic** — one independently testable assertion each. Split compounds before specify.

## Risk & failure modes (required)

List material failures, user impact, and mitigations traced to FR/AC IDs:

| Failure | User impact | Mitigation / trace |
|---------|-------------|-------------------|
| [e.g. sync conflict] | [user-visible effect] | [e.g. AC-SYNC-01] |
