import asyncio
import re
import os
import email
from email import policy
from email.mime.image import MIMEImage
from email.message import EmailMessage
from aiosmtpd.controller import Controller
from aiosmtpd.handlers import AsyncMessage
import smtplib


class MyHandler(AsyncMessage):
    async def handle_message(self, message):
        # Extract recipient and format subject
        recipient = message['To']
        subject = (message['Subject']).replace('_', ' ')

        # Parse the received message using standard email policy
        msg = email.message_from_string(str(message), policy=policy.default)
        print('Message received.\n')

        # Define severity levels and search for severity and date in the message
        severity_levels = ["", "🟧  !Warning: Potential Security Risk Identified"]
        severity_match = re.search(r"Severity: (\d+)\s?\((.*?)\)", str(msg))
        date_match = re.search(r"Date: (.*?)\n", str(msg))

        # Load HTML template
        with open("../notifications/email.html", "r") as file:
            template = file.read()

        # Check if severity and date are found
        if severity_match and date_match:
            new_subject = severity_levels[int(severity_match.group(1))]
            template = template.replace("$timestamp", date_match.group(1))
            template = template.replace("$detected_rule", subject)
        else:
            print("Severity or Date not found.")
            return

        # Set up new email message with HTML content
        new_message = EmailMessage()
        new_message['From'] = os.getenv("GMAIL_USER")
        new_message['To'] = recipient
        new_message['Subject'] = new_subject

        # Set plain text alternative and HTML content
        new_message.set_content("This is a plain text alternative.")  # Fallback for non-HTML clients
        new_message.add_alternative(template, subtype='html')  # HTML content

        # Attach inline logo image
        with open("../notifications/logo.png", "rb") as img:
            logo = MIMEImage(img.read(), name="sage.png")
            logo.add_header('Content-ID', '<logo_cid>')  # Inline reference for the image
            new_message.attach(logo)

        # SMTP configuration
        smtp_server = "smtp.gmail.com"
        smtp_port = 587
        gmail_user = os.getenv("GMAIL_USER")
        gmail_password = os.getenv("GMAIL_PASSWORD")

        try:
            # Send email using SMTP server
            with smtplib.SMTP(smtp_server, smtp_port) as smtp:
                smtp.starttls()  # Enable TLS encryption
                smtp.login(gmail_user, gmail_password)
                smtp.send_message(new_message)
            print(f"Message redirected to {recipient}")
        except Exception as e:
            print(f"Failed to send message: {e}")

        # Return SMTP success response
        return '250 Message accepted for delivery'


async def main():
    # Initialize and start the email controller on localhost
    controller = Controller(MyHandler(), hostname='0.0.0.0', port=1025)
    controller.start()
    try:
        # Keep server running indefinitely until interrupted
        await asyncio.Event().wait()
    except KeyboardInterrupt:
        controller.stop()


# Entry point
if __name__ == '__main__':
    asyncio.run(main())
