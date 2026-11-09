# Firebase Emulator Suite

The local setup runs Auth, Firestore, and Functions without contacting the
production Firebase project.

## Prerequisites

- Firebase CLI installed and authenticated.
- Node.js 20 installed at the path documented in `AGENTS.md`.
- Dependencies installed in `functions/`.

## Start the emulators

From the repository root, run:

```powershell
.\scripts\start_emulators.ps1
```

The emulator ports are:

| Service | Port |
| --- | ---: |
| Auth | 9099 |
| Firestore | 8080 |
| Functions | 5001 |
| Emulator UI | 4000 |

Open `http://127.0.0.1:4000` for the Emulator UI.

The script builds `functions/` before starting the emulators so the callable
Functions source is current.

## Run the Flutter app against emulators

Debug builds automatically connect Auth, Firestore, and the
`europe-west1` Functions client to the emulator host. Desktop and web builds
use `127.0.0.1` by default:

```powershell
flutter run -d chrome
```

For an Android emulator, use the host gateway:

```powershell
flutter run -d emulator-5554 --dart-define=FIREBASE_EMULATOR_HOST=10.0.2.2
```

For a physical Android device, replace the host with the development
computer's LAN IP address:

```powershell
flutter run -d <device-id> --dart-define=FIREBASE_EMULATOR_HOST=192.168.1.100
```

Release builds do not connect to emulators because the wiring is guarded by
Flutter's `kDebugMode`.

## Emulator data

The emulator data is in-memory by default and is discarded when the emulator
process stops. Use the Firebase CLI's export/import flags when a repeatable
seed dataset is needed.
