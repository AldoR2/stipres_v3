import os
import sys
from pathlib import Path

from google.oauth2.credentials import Credentials
from google.auth.transport.requests import Request
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload


SCOPES = ["https://www.googleapis.com/auth/drive.file"]


def get_credentials():
    credentials = Credentials(
        token=None,
        refresh_token=os.environ["GDRIVE_REFRESH_TOKEN"],
        token_uri="https://oauth2.googleapis.com/token",
        client_id=os.environ["GDRIVE_CLIENT_ID"],
        client_secret=os.environ["GDRIVE_CLIENT_SECRET"],
        scopes=SCOPES,
    )

    credentials.refresh(Request())
    return credentials


def upload_file(file_path: str, folder_id: str):
    path = Path(file_path)

    if not path.exists():
        raise FileNotFoundError(f"File tidak ditemukan: {file_path}")

    credentials = get_credentials()
    service = build("drive", "v3", credentials=credentials)

    file_metadata = {
        "name": path.name,
        "parents": [folder_id],
    }

    media = MediaFileUpload(
        str(path),
        mimetype="application/vnd.android.package-archive",
        resumable=True,
    )

    uploaded_file = service.files().create(
        body=file_metadata,
        media_body=media,
        fields="id, name, webViewLink",
        supportsAllDrives=True,
    ).execute()

    print("Upload berhasil")
    print(f"Nama file: {uploaded_file.get('name')}")
    print(f"File ID: {uploaded_file.get('id')}")
    print(f"Link: {uploaded_file.get('webViewLink')}")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python upload_to_drive.py <file_path> <folder_id>")
        sys.exit(1)

    upload_file(sys.argv[1], sys.argv[2])