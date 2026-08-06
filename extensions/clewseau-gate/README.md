# Clewseau Gate

Extension that runs Gate 2: compare the ID registry to specs, tasks, coverage annotations, and test names. Silent gaps and untraced scope fail.

Install:

```bash
specify extension add --dev /path/to/clewseau/extensions/clewseau-gate
cp .specify/extensions/clewseau-gate/clewseau-gate-config.template.yml \
   .specify/extensions/clewseau-gate/clewseau-gate-config.yml
```

Configure `registry`, `specs`, `tasks`, `src_globs`, and `test_globs` for your repo. Defaults assume a single PRD at repo root and Spec Kit `specs/**` layout.
