# MboaPOS

MboaPOS is an offline-first point-of-sale and inventory recording app for
Cameroonian small and medium businesses. It records payment methods; it is not
a payment processor or e-commerce platform.

## Current implementation

- Flutter app with French-first generated localization, Riverpod state, and
  GoRouter navigation.
- Firebase Auth sessions, organization claims, Firestore-backed catalog, and
  `europe-west1` checkout/owner-provisioning callables.
- Drift local cache for products and organization settings, with transactional
  local checkout, receipt, stock projection, and durable outbox records.
- Server checkout validates current prices, tax settings, totals, and stock;
  receipt number and issue time come from the server. Provisional offline
  receipts are clearly marked and never treated as fiscal.
- Firestore rules deny direct client writes to transactions and stock
  movements, require active staff claims, and restrict updates by field and
  role.

The implementation is still a pilot. Firebase production deployment, verified
merchant tax/NIU details, review handling for permanently rejected offline
sales, and physical-device validation remain release gates. Tax is disabled
for new organizations by default; the owner can enable it and edit the rate.
Payment methods (Cash, MTN MoMo, Orange Money, Other) are recording labels
only; no live payment collection is implemented.

## Local development

```powershell
cmd.exe /d /c "C:\Users\EVERMATE\flutter\bin\flutter.bat pub get"
cmd.exe /d /c "C:\Users\EVERMATE\flutter\bin\flutter.bat analyze"
cmd.exe /d /c "C:\Users\EVERMATE\flutter\bin\flutter.bat test"
cmd.exe /d /c "C:\Users\EVERMATE\flutter\bin\flutter.bat build apk --debug"
```

See [Firebase Emulator Suite](docs/firebase-emulator.md) for running Auth,
Firestore, and Functions locally, and [SECURITY.md](SECURITY.md) for the
security baseline.

## Before a merchant pilot

- Deploy and verify Firebase callables and rules in the intended Firebase
  project; local emulator success does not prove production deployment.
- Configure and verify the merchant's NIU and tax profile with the appropriate
  accounting authority. Receipts remain non-fiscal until then.
- Exercise the app on the supported compact Android device and verify offline
  restart/recovery behavior.
- Establish backup, retention, incident-response, and merchant data-processing
  procedures. Replace placeholder operator details in [PRIVACY.md](PRIVACY.md)
  and [TERMS.md](TERMS.md).

Receipt printing and sharing do not establish fiscal compliance. See the
[mobile architecture](docs/mobile-architecture-and-data-lifecycle.md),
[user flows](docs/mobile-user-flows.md), and [risk log](docs/p0-risk-log.md)
for verified behavior and remaining gaps.
