import sys
from pathlib import Path

from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload


SERVICE_ACCOUNT_FILE = "service-account.json"
SCOPES = ["https://www.googleapis.com/auth/drive.file"]


def upload_file(file_path: str, folder_id: str):
    path = Path(file_path)

    if not path.exists():
        raise FileNotFoundError(f"File tidak ditemukan: {file_path}")

    credentials = service_account.Credentials.from_service_account_file(
        SERVICE_ACCOUNT_FILE,
        scopes=SCOPES,
    )

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