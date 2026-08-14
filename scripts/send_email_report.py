#!/usr/bin/env python3
"""Send a generated report archive through Gmail SMTP."""

from __future__ import annotations

import argparse
import base64
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
    oauth2_token = os.environ.get("SMTP_OAUTH2_TOKEN")
    smtp_server = os.environ.get("SMTP_SERVER", "smtp.gmail.com").strip()
    smtp_port_text = os.environ.get("SMTP_PORT", "465").strip()
    missing = [name for name, value in (("GMAIL_USERNAME", username),) if not value]
    if missing:
        print(
            f"Missing required environment variable(s): {', '.join(missing)}",
            file=sys.stderr,
        )
        return 2
    if not oauth2_token and not app_password:
        print(
            "Configure SMTP_OAUTH2_TOKEN (preferred) or GMAIL_APP_PASSWORD",
            file=sys.stderr,
        )
        return 2
    try:
        smtp_port = int(smtp_port_text)
    except ValueError:
        print("SMTP_PORT must be 465 or 587", file=sys.stderr)
        return 2
    if smtp_port not in (465, 587):
        print("SMTP_PORT must be 465 (SSL/TLS) or 587 (STARTTLS)", file=sys.stderr)
        return 2
    if app_password:
        # Google displays app passwords in groups; remove copied whitespace.
        app_password = "".join(app_password.split())

    def authenticate(smtp: smtplib.SMTP) -> None:
        if oauth2_token:
            auth = f"user={username}\x01auth=Bearer {oauth2_token}\x01\x01"
            encoded = base64.b64encode(auth.encode()).decode("ascii")
            code, response = smtp.docmd("AUTH", f"XOAUTH2 {encoded}")
            if code != 235:
                raise smtplib.SMTPAuthenticationError(code, response)
        else:
            smtp.login(username, app_password)

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
        if smtp_port == 465:
            with smtplib.SMTP_SSL(smtp_server, smtp_port, timeout=30) as smtp:
                authenticate(smtp)
                smtp.send_message(message)
        else:
            with smtplib.SMTP(smtp_server, smtp_port, timeout=30) as smtp:
                smtp.ehlo()
                smtp.starttls()
                smtp.ehlo()
                authenticate(smtp)
                smtp.send_message(message)
    except smtplib.SMTPAuthenticationError:
        print(
            "The SMTP server rejected the OAuth token or app password. Update "
            "the configured Actions authentication secret.",
            file=sys.stderr,
        )
        return 3
    except smtplib.SMTPException as error:
        print(f"SMTP delivery failed: {error}", file=sys.stderr)
        return 4
    except OSError as error:
        print(
            f"Unable to connect to {smtp_server}:{smtp_port}: {error}", file=sys.stderr
        )
        return 4

    print(f"Report sent to {args.recipient}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
