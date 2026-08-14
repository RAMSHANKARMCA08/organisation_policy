#!/usr/bin/env python3
"""Normalize scanner JSON outputs into one CI finding contract."""

import argparse, json
from pathlib import Path

SEVERITIES = {"critical", "high", "medium", "low", "info"}


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--input", type=Path, required=True)
    p.add_argument("--output", type=Path, required=True)
    p.add_argument("--repository", required=True)
    a = p.parse_args()
    findings = []
    for source in a.input.rglob("*.json"):
        try:
            data = json.loads(source.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError):
            continue
        items = (
            data
            if isinstance(data, list)
            else data.get("findings", data.get("results", []))
        )
        if not isinstance(items, list):
            continue
        for item in items:
            if isinstance(item, dict) and item.get("Vulnerabilities"):
                items.extend(
                    [
                        {**v, "target": item.get("Target", ""), "tool": "trivy"}
                        for v in item["Vulnerabilities"]
                    ]
                )
                continue
            sev = str(item.get("severity", item.get("level", "info"))).lower()
            sev = sev if sev in SEVERITIES else "info"
            findings.append(
                {
                    "repository": a.repository,
                    "file": item.get("file", item.get("target", "")),
                    "line": item.get(
                        "line",
                        item.get("start", {}).get("line", 0)
                        if isinstance(item.get("start"), dict)
                        else 0,
                    ),
                    "tool": item.get("tool", source.stem),
                    "policy_id": str(
                        item.get(
                            "policy_id",
                            item.get("check_id", item.get("rule_id", "unknown")),
                        )
                    ).lower(),
                    "severity": sev,
                    "category": item.get("category", "unspecified"),
                    "description": item.get("description", item.get("message", "")),
                    "remediation": item.get(
                        "remediation", "Review the scanner guidance."
                    ),
                    "exception_status": "not_evaluated",
                }
            )
    a.output.parent.mkdir(parents=True, exist_ok=True)
    a.output.write_text(
        json.dumps({"repository": a.repository, "findings": findings}, indent=2) + "\n",
        encoding="utf-8",
    )


if __name__ == "__main__":
    main()
