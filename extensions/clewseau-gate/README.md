# Clewseau Gate

Every **wish** gets a string tied to its **work** and its **proof**; this Gate stops the line at any loose end, then winds all the string it found into a ball — the **clew**.

Gate 2: compare the ID registry to specs, tasks, coverage annotations, and test names. **Exact-set** registry ≡ specs ≡ tasks. Silent AC gaps and untraced scope fail. **Always writes a clew** (default `clew.json`, configurable via `clew_path`) for clewloupe or any matrix consumer.

Install:

```bash
specify extension add --dev /path/to/clewseau/extensions/clewseau-gate
```

Install scaffolds `clewseau-gate-config.yml` from `config-template.yml`. Edit `registry`, `clew_path`, `specs`, `tasks`, `src_globs`, and `test_globs` for your repo.
