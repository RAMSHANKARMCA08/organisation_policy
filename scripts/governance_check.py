#!/usr/bin/env python3
"""Check policy ownership, category naming, exception expiry, and repository metadata."""
from pathlib import Path
import sys, yaml
from datetime import date

TOOLS = {"opa", "semgrep", "trivy", "terrascan", "TFLint", "kyverno"}
ALIASES = {"k8s", "kube", "tf", "az"}

def main() -> int:
    root = Path(__file__).resolve().parents[1]; errors=[]; expiring=[]
    for tool in TOOLS:
        if not (root / "owners" / f"{tool.lower()}.yaml").exists(): errors.append(f"missing owner metadata: {tool}")
        base=root/tool
        for p in base.rglob("*"):
            if p.is_dir() and p.name.lower() in ALIASES: errors.append(f"alias category is not allowed: {p}")
        for p in base.rglob("*.yaml"):
            if "exceptions" not in p.parts: continue
            try: d=yaml.safe_load(p.read_text(encoding="utf-8")) or {}
            except yaml.YAMLError as e: errors.append(f"invalid exception {p}: {e}"); continue
            if d.get("valid_till") and str(d["valid_till"]) < date.today().isoformat(): print(f"expired exception: {p}")
            elif d.get("valid_till") and str(d["valid_till"]) <= date.today().replace(day=min(date.today().day+30,28)).isoformat(): expiring.append(str(p))
    repos=root/"repository"; missing=[]
    for p in repos.glob("*.yaml"):
        d=yaml.safe_load(p.read_text(encoding="utf-8")) or {}
        for key in ("name", "project", "point_of_contact_1", "point_of_contact_2"):
            if not d.get(key): missing.append(f"{p}: missing {key}")
        if d.get("visibility") == "public" and d.get("security_severity") != "critical":
            errors.append(f"{p}: public repositories must be classified critical")
        if d.get("visibility") != "public" and d.get("access_scope") == "individual" and d.get("security_severity") != "medium":
            errors.append(f"{p}: individually-accessed repositories must be classified medium")
    errors.extend(missing)
    print(f"repositories_missing_metadata={len(missing)}")
    print(f"exceptions_expiring_soon={len(expiring)}")
    for e in errors: print(e, file=sys.stderr)
    return 1 if errors else 0
if __name__ == "__main__": sys.exit(main())
