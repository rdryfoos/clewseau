#!/usr/bin/env python3
"""Sync samples from a real HomesFlow Gate emit.

Default: copy samples/homesflow.trace-manifest.json → sample.trace-manifest.json
and into Loupe. Refresh the real emit first:

  SPECASSAY_PROJECT_ROOT=…/HomesFlow SPECASSAY_CONFIG=… \
    bash extensions/specassay-check/scripts/check-traceability.sh
  cp "$SPECASSAY_PROJECT_ROOT/trace-manifest.json" samples/homesflow.trace-manifest.json
  python3 scripts/build-sample-manifest.py
"""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REAL = ROOT / "samples" / "homesflow.trace-manifest.json"
OUT = ROOT / "samples" / "sample.trace-manifest.json"
LOUPE = Path("/Users/spudnik/clewloupe/samples/sample.trace-manifest.json")
LOUPE_REAL = Path("/Users/spudnik/clewloupe/samples/homesflow.trace-manifest.json")
HOMESFLOW_MANIFEST = Path("/Users/spudnik/HomesFlow/trace-manifest.json")

# Accept both the new format value and the pre-rename one during transition.
ACCEPTED_FORMATS = {"trace-manifest", "clew"}


def main() -> None:
    src = REAL if REAL.exists() else HOMESFLOW_MANIFEST
    if not src.exists():
        raise SystemExit(f"missing real emit: {REAL} (or {HOMESFLOW_MANIFEST})")
    doc = json.loads(src.read_text(encoding="utf-8"))
    if doc.get("schemaVersion") != 3 or doc.get("format") not in ACCEPTED_FORMATS:
        raise SystemExit("not a schema v3 trace-manifest")

    OUT.parent.mkdir(parents=True, exist_ok=True)
    text = json.dumps(doc, indent=2) + "\n"
    OUT.write_text(text, encoding="utf-8")
    if src.resolve() != REAL.resolve():
        REAL.write_text(text, encoding="utf-8")
    print(
        f"Wrote {OUT} ({len(doc.get('rows', []))} rows) "
        f"gate.ok={doc.get('gate', {}).get('ok')} counts={doc.get('statusCounts')}"
    )

    if LOUPE.parent.exists():
        # Samples are honest emits — copy verbatim, never doctor fields.
        LOUPE.write_text(text, encoding="utf-8")
        LOUPE_REAL.write_text(text, encoding="utf-8")
        print(f"Synced {LOUPE}")
        print(f"Synced {LOUPE_REAL}")


if __name__ == "__main__":
    main()
