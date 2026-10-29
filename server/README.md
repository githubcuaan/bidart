# Bidart avatar API

## Local setup

1. Make sure `server/firebase-service-account.json` exists.

2. Build and start MinIO plus the avatar API from the repository root:

   ```powershell
   docker compose up -d --build
   ```

   The services are available at:

   ```powershell
   MinIO console: http://localhost:9001
   MinIO API:     http://localhost:9000
   Avatar API:    http://localhost:3001
   ```

3. Run Flutter with the API endpoint:

   ```powershell
   flutter run -d chrome --dart-define=AVATAR_UPLOAD_ENDPOINT=http://localhost:3001/upload-avatar
   ```

For a physical phone, replace `localhost` with the computer's LAN IP and make
sure ports 3000 and 9000 are reachable. The MinIO credentials remain in the
server environment and are never included in the Flutter app.
