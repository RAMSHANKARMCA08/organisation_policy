#!/usr/bin/env python3
"""Build email-ready per-repository and consolidated DevSecOps reports."""

from __future__ import annotations

import argparse
import html
import json
import math
import struct
import zlib
from datetime import date
from collections import defaultdict
from datetime import datetime, timezone
from pathlib import Path

import yaml

from exception_loader import load

SEVERITIES = ("critical", "high", "medium", "low", "info", "review")


def load_repository_exceptions(root: Path) -> list[dict[str, str]]:
    records = []
    if not root.is_dir():
        return records
    for path in sorted((*root.glob("*.yaml"), *root.glob("*.yml"))):
        data = yaml.safe_load(path.read_text(encoding="utf-8")) or {}
        if not isinstance(data, dict) or not data.get("name"):
            raise ValueError(f"Invalid repository exception metadata: {path}")
        records.append({key: str(value) for key, value in data.items()})
    return records


def write_pie_chart(
    output: Path,
    counts: dict[str, int],
    colors: dict[str, str],
    labels: tuple[str, ...],
    size: int = 220,
) -> None:
    """Write an email-safe RGBA PNG without external chart dependencies."""
    total = sum(counts.values())
    slices = []
    end = 0.0
    for label in labels:
        if counts[label] and total:
            end += counts[label] / total
            color = tuple(bytes.fromhex(colors[label].removeprefix("#")))
            slices.append((end, color))

    center = (size - 1) / 2
    radius_squared = (size / 2 - 2) ** 2
    rows = bytearray()
    for y in range(size):
        rows.append(0)
        for x in range(size):
            dx, dy = x - center, y - center
            if dx * dx + dy * dy > radius_squared:
                rows.extend((255, 255, 255, 0))
                continue
            fraction = (math.atan2(dx, -dy) % math.tau) / math.tau
            color = (229, 231, 235)
            for end, candidate in slices:
                if fraction <= end:
                    color = candidate
                    break
            rows.extend((*color, 255))

    def chunk(kind: bytes, data: bytes) -> bytes:
        return (
            struct.pack(">I", len(data))
            + kind
            + data
            + struct.pack(">I", zlib.crc32(kind + data) & 0xFFFFFFFF)
        )

    png = b"\x89PNG\r\n\x1a\n"
    png += chunk(b"IHDR", struct.pack(">IIBBBBB", size, size, 8, 6, 0, 0, 0))
    png += chunk(b"IDAT", zlib.compress(bytes(rows), 9))
    png += chunk(b"IEND", b"")
    output.write_bytes(png)


def read_reports(root: Path) -> dict[str, list[dict[str, str]]]:
    findings: dict[str, list[dict[str, str]]] = defaultdict(list)
    # Parallel scanner jobs write one status file and log per tool/repository.
    for status_file in root.glob("*/*.status"):
        if status_file.read_text(encoding="utf-8").strip() == "0":
            continue
        repo = status_file.parent.name
        scanner = status_file.stem
        log = status_file.with_suffix(".log")
        clone_log = status_file.parent / f"{scanner}-clone.log"
        detail_file = log if log.exists() else clone_log
        detail = (
            detail_file.read_text(encoding="utf-8", errors="replace").strip()
            if detail_file.exists()
            else "Scanner failed without producing a log."
        )
        findings[repo].append(
            {"scanner": scanner, "severity": "high", "detail": detail[:2000]}
        )

    # Retain compatibility with reports produced by the legacy orchestrator.
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
    repository_exceptions = load_repository_exceptions(Path("repository/exceptions"))
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
    chart_severities = ("critical", "high", "medium", "low")
    repository_counts = defaultdict(lambda: dict.fromkeys(chart_severities, 0))
    for repo, item in all_items:
        if item["severity"] in repository_counts[repo]:
            repository_counts[repo][item["severity"]] += 1
    repository_totals = {
        repo: sum(counts.values())
        for repo, counts in sorted(repository_counts.items())
        if sum(counts.values())
    }
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
            "| S.No | Repository | Scanner | Policy ID | Priority | Error details |",
            "|---:|---|---|---|---|---|",
        ]
        for serial, (repo, item) in enumerate(entries, 1):
            detail = item["detail"].replace("|", "\\|").replace("\n", " ")
            policy_id = item.get("policy_id", "N/A")
            lines.append(
                f"| {serial} | {repo} | {item['scanner']} | {policy_id} | "
                f"{item['severity']} | {detail[:1000]} |"
            )
        lines.append("")
    lines += [
        "## Repository scan exceptions",
        "",
        "| S.No | Repository | Project | Primary contact | Backup contact | Visibility | Access | Severity | Reason | Approved by | Valid till |",
        "|---:|---|---|---|---|---|---|---|---|---|---|",
    ]
    lines += [
        f"| {serial} | {record.get('name', '')} | {record.get('project', '')} | "
        f"{record.get('point_of_contact_1', '')} | {record.get('point_of_contact_2', '')} | "
        f"{record.get('visibility', '')} | {record.get('access_scope', '')} | "
        f"{record.get('security_severity', '')} | {record.get('reason', '')} | "
        f"{record.get('approved_by', '')} | {record.get('valid_till', '')} |"
        for serial, record in enumerate(repository_exceptions, 1)
    ] or ["| - | None | - | - | - | - | - | - | - | - | - |"]
    lines.append("")
    (args.output / "organization-consolidated.md").write_text(
        "\n".join(lines), encoding="utf-8"
    )

    html_rows = "".join(
        f"<tr><td>{serial}</td><td>{html.escape(repo)}</td>"
        f"<td>{html.escape(item['scanner'])}</td>"
        f"<td>{html.escape(item.get('policy_id', 'N/A'))}</td>"
        f"<td><b>{item['severity'].title()}</b></td>"
        f"<td>{html.escape(item['detail'])}</td></tr>"
        for serial, (repo, item) in enumerate(all_items, 1)
    )
    colors = {
        "critical": "#DC2626",
        "high": "#EA580C",
        "medium": "#CA8A04",
        "low": "#16A34A",
        "info": "#2563EB",
        "review": "#6B7280",
    }
    write_pie_chart(
        args.output / "severity-pie.png", severity_counts, colors, SEVERITIES
    )
    repository_palette = (
        "#2563EB",
        "#16A34A",
        "#EA580C",
        "#7C3AED",
        "#0891B2",
        "#DB2777",
        "#4F46E5",
        "#65A30D",
        "#D97706",
        "#0F766E",
    )
    repository_labels = tuple(repository_totals)
    repository_colors = {
        repo: repository_palette[index % len(repository_palette)]
        for index, repo in enumerate(repository_labels)
    }
    write_pie_chart(
        args.output / "repository-pie.png",
        repository_totals,
        repository_colors,
        repository_labels,
    )
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
    repository_exception_html = (
        "".join(
            f"<tr><td>{serial}</td><td>{html.escape(record.get('name', ''))}</td>"
            f"<td>{html.escape(record.get('project', ''))}</td>"
            f"<td>{html.escape(record.get('point_of_contact_1', ''))}</td>"
            f"<td>{html.escape(record.get('point_of_contact_2', ''))}</td>"
            f"<td>{html.escape(record.get('visibility', ''))}</td>"
            f"<td>{html.escape(record.get('access_scope', ''))}</td>"
            f"<td>{html.escape(record.get('security_severity', ''))}</td>"
            f"<td>{html.escape(record.get('reason', ''))}</td>"
            f"<td>{html.escape(record.get('approved_by', ''))}</td>"
            f"<td>{html.escape(record.get('valid_till', ''))}</td></tr>"
            for serial, record in enumerate(repository_exceptions, 1)
        )
        or '<tr><td colspan="11">No repository scan exceptions.</td></tr>'
    )
    document = (
        "<html><head><style>body{font-family:Arial,sans-serif;color:#1f2937}"
        "h1{color:#1d4ed8}table{border-collapse:collapse;width:100%;margin-bottom:24px}"
        "th{background:#1d4ed8;color:white;text-align:left}th,td{border:1px solid #cbd5e1;padding:8px}"
        "tr:nth-child(even){background:#f1f5f9}</style></head><body>"
        f"<h1>Organization DevSecOps report</h1><p>Generated {html.escape(datetime.now(timezone.utc).isoformat())}</p><table role='presentation' style='width:100%;border:0;border-collapse:collapse'><tr><td style='width:50%;border:0;vertical-align:top;padding:8px'><h2>Severity distribution</h2><img src='severity-pie.png' width='220' height='220' alt='Severity distribution pie chart'><ul style='list-style:none;padding:0'>"
        + "".join(
            f"<li><span style='display:inline-block;width:12px;height:12px;background:{colors[s]};margin-right:8px'></span><b>{s.title()}</b>: {severity_counts[s]}</li>"
            for s in SEVERITIES
        )
        + "</ul></td><td style='width:50%;border:0;vertical-align:top;padding:8px'><h2>Findings by repository</h2><img src='repository-pie.png' width='220' height='220' alt='Findings by repository pie chart'><ul style='list-style:none;padding:0'>"
        + "".join(
            f"<li><span style='display:inline-block;width:12px;height:12px;background:{repository_colors[repo]};margin-right:8px'></span><b>{html.escape(repo)}</b>: {repository_totals[repo]}</li>"
            for repo in repository_labels
        )
        + f"</ul></td></tr></table><h2>Critical and high findings by repository</h2><table border='1' cellpadding='6'><tr><th>Repository</th><th>Critical</th><th>High</th></tr>{repo_html}</table><h2>Exceptions expiring in the next 30 days</h2><table border='1' cellpadding='6'><tr><th>Repository</th><th>Policy ID</th><th>Reason</th><th>Valid till</th><th>Days remaining</th></tr>{expiry_html}</table><h2>Findings</h2><table border='1' cellpadding='6'><tr><th>S.No</th><th>Repository</th><th>Scanner</th><th>Policy ID</th><th>Priority</th><th>Details</th></tr>{html_rows or '<tr><td colspan=6>All scanned repositories passed.</td></tr>'}</table><h2>Repository scan exceptions</h2><table border='1' cellpadding='6'><tr><th>S.No</th><th>Repository</th><th>Project</th><th>Primary contact</th><th>Backup contact</th><th>Visibility</th><th>Access</th><th>Severity</th><th>Reason</th><th>Approved by</th><th>Valid till</th></tr>{repository_exception_html}</table></body></html>"
    )
    (args.output / "organization-consolidated.html").write_text(
        document, encoding="utf-8"
    )
    return 1 if all_items or expired else 0


if __name__ == "__main__":
    raise SystemExit(main())
