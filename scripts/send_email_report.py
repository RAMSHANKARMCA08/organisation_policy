#!/usr/bin/env python3
"""Send a generated report archive through Gmail SMTP."""

from __future__ import annotations

import argparse
import os
import smtplib
import sys
from email.message import EmailMessage
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--attachment", type=Path, required=True)
    parser.add_argument("--recipient", required=True)
    parser.add_argument("--subject", default="Organization DevSecOps scan report")
    parser.add_argument("--body-file", type=Path)
    parser.add_argument("--html-file", type=Path)
    args = parser.parse_args()

    username = os.environ.get("GMAIL_USERNAME")
    app_password = os.environ.get("GMAIL_APP_PASSWORD")
    missing = [
        name
        for name, value in (
            ("GMAIL_USERNAME", username),
            ("GMAIL_APP_PASSWORD", app_password),
        )
        if not value
    ]
    if missing:
        print(
            f"Missing required environment variable(s): {', '.join(missing)}",
            file=sys.stderr,
        )
        return 2
    # Google displays app passwords in groups; remove copied whitespace before
    # authenticating while keeping the secret out of logs.
    app_password = "".join(app_password.split())
    if not args.attachment.is_file():
        print(f"Report attachment not found: {args.attachment}", file=sys.stderr)
        return 2

    message = EmailMessage()
    message["From"] = username
    message["To"] = args.recipient
    message["Subject"] = args.subject
    body = "The organization DevSecOps scan has completed. Reports are attached."
    if args.body_file:
        if not args.body_file.is_file():
            print(f"Email body file not found: {args.body_file}", file=sys.stderr)
            return 2
        body = args.body_file.read_text(encoding="utf-8")
    message.set_content(body)
    if args.html_file:
        if not args.html_file.is_file():
            print(f"HTML email file not found: {args.html_file}", file=sys.stderr)
            return 2
        message.add_alternative(
            args.html_file.read_text(encoding="utf-8"), subtype="html"
        )
    message.add_attachment(
        args.attachment.read_bytes(),
        maintype="application",
        subtype="zip",
        filename=args.attachment.name,
    )

    try:
        with smtplib.SMTP_SSL("smtp.gmail.com", 465, timeout=30) as smtp:
            smtp.login(username, app_password)
            smtp.send_message(message)
    except smtplib.SMTPAuthenticationError:
        print(
            "Gmail rejected GMAIL_APP_PASSWORD. Generate a new app password "
            "for the configured account and update the GitHub Actions secret.",
            file=sys.stderr,
        )
        return 3
    except smtplib.SMTPException as error:
        print(f"Gmail SMTP delivery failed: {error}", file=sys.stderr)
        return 4

    print(f"Report sent to {args.recipient}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
