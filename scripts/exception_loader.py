"""Single source of truth for approved, expired, and pending exceptions."""
from datetime import date
from pathlib import Path
import yaml

def load(root: Path = Path(".")):
    active, expired, pending = {}, [], []
    for p in root.rglob("*.yaml"):
        if "exceptions" not in p.parts: continue
        try: d = yaml.safe_load(p.read_text(encoding="utf-8")) or {}
        except yaml.YAMLError: continue
        till = str(d.get("valid_till", "")); item = {**d, "file": str(p)}
        if till and till < date.today().isoformat(): expired.append(item)
        elif d.get("status") == "approved" and till >= date.today().isoformat(): active.setdefault(d.get("repository", ""), []).append(item)
        else: pending.append(item)
    return active, expired, pending
