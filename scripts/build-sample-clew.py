#!/usr/bin/env python3
"""Sync samples from a real HomesFlow Gate emit.

Default: copy samples/homesflow.clew.json → sample.clew.json and into clewloupe.
Refresh the real emit first:

  CLEWSEAU_PROJECT_ROOT=…/HomesFlow CLEWSEAU_CONFIG=… \
    bash extensions/clewseau-gate/scripts/check-traceability.sh
  cp "$CLEWSEAU_PROJECT_ROOT/clew.json" samples/homesflow.clew.json
  python3 scripts/build-sample-clew.py
"""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REAL = ROOT / "samples" / "homesflow.clew.json"
OUT = ROOT / "samples" / "sample.clew.json"
LOUPE = Path("/Users/spudnik/clewloupe/samples/sample.clew.json")
LOUPE_REAL = Path("/Users/spudnik/clewloupe/samples/homesflow.clew.json")
HOMESFLOW_CLEW = Path("/Users/spudnik/HomesFlow/clew.json")


def main() -> None:
    src = REAL if REAL.exists() else HOMESFLOW_CLEW
    if not src.exists():
        raise SystemExit(f"missing real emit: {REAL} (or {HOMESFLOW_CLEW})")
    doc = json.loads(src.read_text(encoding="utf-8"))
    if doc.get("schemaVersion") != 3 or doc.get("format") != "clew":
        raise SystemExit("not a schema v3 clew")

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
