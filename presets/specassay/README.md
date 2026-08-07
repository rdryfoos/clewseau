# SpecAssay preset

Appends SpecAssay's durable-ID rules and vocabulary onto Spec Kit core templates via `append` strategy. Does not replace Spec Kit's workflow.

Install:

```bash
specify preset add --dev /path/to/specassay/presets/specassay
```

Vocabulary (trace-manifest, statuses, Gate 2) lands in the constitution template. For projects that keep a separate glossary, also merge [`GLOSSARY.md`](./GLOSSARY.md).

See the repo root [`PROMOTION-CONTRACT.md`](../../PROMOTION-CONTRACT.md).
