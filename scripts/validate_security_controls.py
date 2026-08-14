#!/usr/bin/env python3
"""Validate exception records, duplicate policy IDs, and release severity gates."""

from __future__ import annotations
import argparse, json, sys
from datetime import date
from pathlib import Path
import yaml
from jsonschema import Draft202012Validator

REQUIRED = {"repository", "policy_id", "reason", "initiated_by", "valid_till"}
SEVERITIES = {"critical", "high", "medium", "low", "info"}

EXCEPTION_SCHEMA = {
    "type": "object",
    "required": [
        "repository",
        "policy_id",
        "reason",
        "initiated_by",
        "approved_by",
        "status",
        "valid_till",
        "reference",
    ],
    "properties": {
        "repository": {"type": "string", "pattern": r"^[A-Za-z0-9._-]+$"},
        "policy_id": {"type": "string", "pattern": r"^[a-z0-9]+(?:-[a-z0-9]+)*$"},
        "reason": {"type": "string", "minLength": 10},
        "initiated_by": {"type": "string", "minLength": 3},
        "approved_by": {"type": "string", "minLength": 3},
        "status": {"enum": ["pending_approval", "approved", "rejected", "expired"]},
        "valid_till": {"type": "string", "pattern": r"^\d{4}-\d{2}-\d{2}$"},
        "reference": {"type": "string", "minLength": 3},
    },
    "additionalProperties": True,
}
SCHEMA_PATH = Path(__file__).resolve().parents[1] / "policy" / "exception.schema.json"
if SCHEMA_PATH.exists():
    EXCEPTION_SCHEMA = json.loads(SCHEMA_PATH.read_text(encoding="utf-8"))


def fields(path: Path) -> dict:
    data = yaml.safe_load(path.read_text(encoding="utf-8"))
    return data if isinstance(data, dict) else {}


def validate_exceptions(root: Path) -> list[str]:
    errors = []
    for path in root.rglob("*.yaml"):
        if "exceptions" not in path.parts:
            continue
        try:
            data = fields(path)
        except yaml.YAMLError as exc:
            errors.append(f"{path}: invalid YAML: {exc}")
            continue
        for error in Draft202012Validator(EXCEPTION_SCHEMA).iter_errors(data):
            errors.append(f"{path}: {error.message}")
        if data.get("repository") and data["repository"] != path.parent.name:
            errors.append(f"{path}: repository must match its exception folder")
    return errors


def duplicate_ids(index: Path) -> list[str]:
    seen, errors = {}, []
    for line in index.read_text(encoding="utf-8", errors="ignore").splitlines():
        if (
            not line.startswith("|")
            or line.startswith("|---")
            or "policy id" in line.lower()
        ):
            continue
        cols = [c.strip() for c in line.strip("|").split("|")]
        if cols and cols[0] in seen:
            errors.append(f"duplicate policy id {cols[0]}: {seen[cols[0]]} and {line}")
        elif cols:
            seen[cols[0]] = line
    return errors


def gate(findings: Path, exceptions: Path) -> list[str]:
    if not findings.exists():
        return []
    data = json.loads(findings.read_text(encoding="utf-8"))
    items = data if isinstance(data, list) else data.get("findings", [])
    approved = {
        fields(p).get("policy_id")
        for p in exceptions.rglob("*.yaml")
        if fields(p).get("status") == "approved"
        and fields(p).get("valid_till", "") >= date.today().isoformat()
    }
    return [
        f"{x.get('policy_id', 'unknown')}: {x.get('severity')}"
        for x in items
        if str(x.get("severity", "")).lower() in {"critical", "high"}
        and x.get("policy_id") not in approved
    ]


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument("--findings", type=Path)
    p.add_argument("--index", type=Path, default=Path("POLICY_INDEX.md"))
    p.add_argument("--exceptions", type=Path, default=Path("."))
    a = p.parse_args()
    errors = validate_exceptions(a.exceptions) + duplicate_ids(a.index)
    errors += (
        [f"blocking finding: {x}" for x in gate(a.findings, a.exceptions)]
        if a.findings
        else []
    )
    for error in errors:
        print(error, file=sys.stderr)
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
