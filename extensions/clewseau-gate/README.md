# Clewseau Gate

Every **wish** is on the **Thread** with its **work** and its **proof**; this Gate stops the line at any loose end, then winds what it found into a ball — the **clew**.

Gate 2: compare the ID registry to specs, tasks, coverage annotations, and test names. **Exact-set** registry ≡ specs ≡ tasks. Silent AC gaps and untraced scope fail. **Always writes a clew** (default `clew.json`, configurable via `clew_path`) for clewloupe or any matrix consumer.

**CI is the property line.** Run this script on every PR / protected-branch push and fail the build on non-zero exit. Local runs are hygiene; CI is what stops a cowboy (or any machine without Clewseau) from merging unmarked work. Keep the emitted clew from the CI run as evidence.

Install:

```bash
specify extension add --dev /path/to/clewseau/extensions/clewseau-gate
```

Install scaffolds `clewseau-gate-config.yml` from `config-template.yml`. Edit `registry`, `clew_path`, `specs`, `tasks`, `src_globs`, and `test_globs` for your repo.
