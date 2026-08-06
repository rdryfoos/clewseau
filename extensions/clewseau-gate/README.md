# Clewseau Gate

Extension that runs Gate 2: compare the ID registry to specs, tasks, coverage annotations, and test names. Silent gaps and untraced scope fail.

Install:

```bash
specify extension add --dev /path/to/clewseau/extensions/clewseau-gate
```

Install scaffolds `clewseau-gate-config.yml` from `config-template.yml`. Edit `registry`, `specs`, `tasks`, `src_globs`, and `test_globs` for your repo. Defaults assume a single PRD at repo root and Spec Kit `specs/**` layout.
