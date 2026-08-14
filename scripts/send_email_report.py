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
    args = parser.parse_args()

    username = os.environ.get("GMAIL_USERNAME")
    app_password = os.environ.get("GMAIL_APP_PASSWORD")
    if not username or not app_password:
        print(
            "GMAIL_USERNAME and GMAIL_APP_PASSWORD must be configured", file=sys.stderr
        )
        return 2
    if not args.attachment.is_file():
        print(f"Report attachment not found: {args.attachment}", file=sys.stderr)
        return 2

    message = EmailMessage()
    message["From"] = username
    message["To"] = args.recipient
    message["Subject"] = args.subject
    message.set_content(
        "The full organization DevSecOps scan completed successfully. "
        "The generated scan reports are attached."
    )
    message.add_attachment(
        args.attachment.read_bytes(),
        maintype="application",
        subtype="zip",
        filename=args.attachment.name,
    )

    with smtplib.SMTP_SSL("smtp.gmail.com", 465, timeout=30) as smtp:
        smtp.login(username, app_password)
        smtp.send_message(message)

    print(f"Report sent to {args.recipient}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
