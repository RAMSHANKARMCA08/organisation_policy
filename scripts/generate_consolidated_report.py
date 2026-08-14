#!/usr/bin/env python3
"""Build email-ready per-repository and consolidated DevSecOps reports."""

from __future__ import annotations

import argparse
import html
import json
from datetime import date
from collections import defaultdict
from datetime import datetime, timezone
from pathlib import Path
from exception_loader import load

SEVERITIES = ("critical", "high", "medium", "low", "info", "review")


def read_reports(root: Path) -> dict[str, list[dict[str, str]]]:
    findings: dict[str, list[dict[str, str]]] = defaultdict(list)
    for summary in root.glob("*/summary.json"):
        repo = summary.parent.name
        status = json.loads(summary.read_text(encoding="utf-8")).get("status", "1")
        for log in summary.parent.glob("*.log"):
            text = log.read_text(encoding="utf-8", errors="replace").strip()
            if text and (status != "0" or "unavailable" in text.lower()):
                severity = "review" if "unavailable" in text.lower() else "high"
                findings[repo].append(
                    {"scanner": log.stem, "severity": severity, "detail": text[:2000]}
                )
    return findings


def render_repo(
    repo: str, items: list[dict[str, str]], output: Path, active, expired
) -> None:
    grouped = defaultdict(list)
    for item in items:
        grouped[item["severity"]].append(item)
    lines = [
        f"# DevSecOps report: {repo}",
        "",
        f"Generated: {datetime.now(timezone.utc).isoformat()}",
        "",
    ]
    for severity in SEVERITIES:
        if not grouped[severity]:
            continue
        lines += [f"## {severity} ({len(grouped[severity])})", ""]
        for item in grouped[severity]:
            lines += [
                f"### {item['scanner']}",
                "",
                "```text",
                item["detail"],
                "```",
                "",
            ]
    repo_active = active.get(repo, [])
    repo_expired = [x for x in expired if x.get("repository") == repo]
    lines += [
        "## Approved exceptions",
        "",
        "| Policy ID | Reason | Valid till |",
        "|---|---|---|",
    ]
    lines += [
        f"| {x.get('policy_id')} | {x.get('reason', '')} | {x.get('valid_till')} |"
        for x in repo_active
    ] or ["| None | None | None |"]
    lines += [
        "",
        "## Expired exceptions",
        "",
        "| Policy ID | Reason | Expired on |",
        "|---|---|---|",
    ]
    lines += [
        f"| {x.get('policy_id')} | {x.get('reason', '')} | {x.get('valid_till')} |"
        for x in repo_expired
    ] or ["| None | None | None |"]
    if repo_expired:
        lines += [
            "",
            "Expired exceptions do not suppress findings and force a failed security status.",
        ]
    if not items and not repo_expired:
        lines += ["## PASS", "", "No scanner errors were reported.", ""]
    output.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--reports", type=Path, default=Path("scan-reports"))
    parser.add_argument("--output", type=Path, default=Path("consolidated-reports"))
    args = parser.parse_args()
    args.reports.mkdir(parents=True, exist_ok=True)
    args.output.mkdir(parents=True, exist_ok=True)
    findings = read_reports(args.reports)
    active, expired, pending = load(Path("."))
    for repo, items in findings.items():
        findings[repo] = [
            item
            for item in items
            if not any(
                x.get("policy_id", "").lower() in item["detail"].lower()
                for x in active.get(repo, [])
            )
        ]
    all_items = [(repo, item) for repo, items in findings.items() for item in items]

    for repo in sorted(
        set(findings) | {p.name for p in args.reports.iterdir() if p.is_dir()}
    ):
        render_repo(
            repo, findings.get(repo, []), args.output / f"{repo}.md", active, expired
        )

    grouped = defaultdict(list)
    for repo, item in all_items:
        grouped[item["severity"]].append((repo, item))
    severity_counts = {severity: len(grouped[severity]) for severity in SEVERITIES}
    repository_counts = defaultdict(lambda: {"critical": 0, "high": 0})
    for repo, item in all_items:
        if item["severity"] in repository_counts[repo]:
            repository_counts[repo][item["severity"]] += 1
    today = date.today()
    expiring = []
    for repo, records in active.items():
        for record in records:
            try:
                days = (date.fromisoformat(str(record.get("valid_till"))) - today).days
            except ValueError:
                continue
            if 0 <= days <= 30:
                expiring.append((repo, record, days))
    lines = [
        "# Organization DevSecOps consolidated report",
        "",
        f"Generated: {datetime.now(timezone.utc).isoformat()}",
        "",
        f"Repositories with findings: {len(findings)}",
        f"Total findings: {len(all_items)}",
        "",
        "## Severity summary",
        "",
        "| Severity | Findings |",
        "|---|---:|",
    ]
    lines += [
        f"| {severity} | {severity_counts[severity]} |" for severity in SEVERITIES
    ]
    lines += [
        "",
        "## Critical and high findings by repository",
        "",
        "| Repository | Critical | High |",
        "|---|---:|---:|",
    ]
    lines += [
        f"| {repo} | {counts['critical']} | {counts['high']} |"
        for repo, counts in sorted(repository_counts.items())
    ] or ["| None | 0 | 0 |"]
    lines += [
        "",
        "## Exceptions expiring in the next 30 days",
        "",
        "| Repository | Policy ID | Reason | Valid till | Days remaining |",
        "|---|---|---|---|---:|",
    ]
    lines += [
        f"| {repo} | {record.get('policy_id')} | {record.get('reason', '')} | {record.get('valid_till')} | {days} |"
        for repo, record, days in expiring
    ] or ["| None | None | None | None | - |"]
    lines += ["", "## Approved exceptions", ""]
    lines += [
        f"- {r}: {x.get('policy_id')} — {x.get('reason', '')} (valid till {x.get('valid_till')})"
        for r, xs in active.items()
        for x in xs
    ] or ["No active exceptions."]
    lines += (
        ["", "## Expired exceptions", ""]
        + (
            [
                f"- {x.get('repository')}: {x.get('policy_id')} — expired {x.get('valid_till')}"
                for x in expired
            ]
            or ["No expired exceptions."]
        )
        + [""]
    )
    for severity in SEVERITIES:
        entries = grouped[severity]
        if not entries:
            continue
        lines += [
            f"## {severity} ({len(entries)})",
            "",
            "| Repository | Scanner | Error details |",
            "|---|---|---|",
        ]
        for repo, item in entries:
            detail = item["detail"].replace("|", "\\|").replace("\n", " ")
            lines.append(f"| {repo} | {item['scanner']} | {detail[:1000]} |")
        lines.append("")
    (args.output / "organization-consolidated.md").write_text(
        "\n".join(lines), encoding="utf-8"
    )

    html_rows = "".join(
        f"<tr><td>{html.escape(repo)}</td><td>{html.escape(item['scanner'])}</td><td><b>{item['severity']}</b></td><td>{html.escape(item['detail'])}</td></tr>"
        for repo, item in all_items
    )
    colors = {
        "critical": "#b91c1c",
        "high": "#ea580c",
        "medium": "#ca8a04",
        "low": "#2563eb",
        "info": "#64748b",
        "review": "#7c3aed",
    }
    parts = []
    start = 0
    total = max(sum(severity_counts.values()), 1)
    for severity in SEVERITIES:
        count = severity_counts[severity]
        if count:
            parts.append(
                f"{colors[severity]} {start / total * 100:.2f}% {(start + count) / total * 100:.2f}%"
            )
            start += count
    gradient = ", ".join(parts) or "#e5e7eb 0 100%"
    expiry_html = (
        "".join(
            f"<tr><td>{html.escape(repo)}</td><td>{html.escape(str(record.get('policy_id')))}</td><td>{html.escape(str(record.get('reason', '')))}</td><td>{record.get('valid_till')}</td><td>{days}</td></tr>"
            for repo, record, days in expiring
        )
        or '<tr><td colspan="5">No exceptions expiring in the next 30 days.</td></tr>'
    )
    repo_html = (
        "".join(
            f"<tr><td>{html.escape(repo)}</td><td>{v['critical']}</td><td>{v['high']}</td></tr>"
            for repo, v in sorted(repository_counts.items())
        )
        or '<tr><td colspan="3">No findings.</td></tr>'
    )
    document = (
        f"<html><body><h1>Organization DevSecOps report</h1><p>Generated {html.escape(datetime.now(timezone.utc).isoformat())}</p><h2>Severity distribution</h2><div style='width:220px;height:220px;border-radius:50%;background:conic-gradient({gradient})'></div><ul>"
        + "".join(f"<li>{s}: {severity_counts[s]}</li>" for s in SEVERITIES)
        + f"</ul><h2>Critical and high findings by repository</h2><table border='1' cellpadding='6'><tr><th>Repository</th><th>Critical</th><th>High</th></tr>{repo_html}</table><h2>Exceptions expiring in the next 30 days</h2><table border='1' cellpadding='6'><tr><th>Repository</th><th>Policy ID</th><th>Reason</th><th>Valid till</th><th>Days remaining</th></tr>{expiry_html}</table><h2>Findings</h2><table border='1' cellpadding='6'><tr><th>Repository</th><th>Scanner</th><th>Priority</th><th>Details</th></tr>{html_rows or '<tr><td colspan=4>All scanned repositories passed.</td></tr>'}</table></body></html>"
    )
    (args.output / "organization-consolidated.html").write_text(
        document, encoding="utf-8"
    )
    return 1 if all_items or expired else 0


if __name__ == "__main__":
    raise SystemExit(main())
