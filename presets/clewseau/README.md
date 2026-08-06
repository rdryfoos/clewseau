# Clewseau preset

Appends Clewseau's durable-ID rules and vocabulary onto Spec Kit core templates via `append` strategy. Does not replace Spec Kit's workflow.

Install:

```bash
specify preset add --dev /path/to/clewseau/presets/clewseau
```

Vocabulary (clew, statuses, Gate 2) lands in the constitution template. For projects that keep a separate glossary, also merge [`GLOSSARY.md`](./GLOSSARY.md).

See the repo root [`PROMOTION-CONTRACT.md`](../../PROMOTION-CONTRACT.md).
