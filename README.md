# MboaPOS

Offline-first point of sale and inventory management for Cameroonian SMEs.

## Current pilot scope

The web pilot supports a local product catalog, XAF integer totals, Cameroon TVA calculation at 19.25%, offline cash checkout, a persisted pending-sale record, and a receipt reference. It is not yet connected to Firebase and must not be used for production fiscal or mobile-money processing.

## Run locally

```text
flutter pub get
flutter run -d chrome
flutter test
flutter analyze
```

The current browser adapter uses local storage for non-sensitive pilot data. Before production, replace it with the planned Drift web database and add Firebase Authentication, Firestore sync, Cloud Functions, and emulator-tested rules.

## Compliance blockers before launch

- Replace placeholder operator details and email in [PRIVACY.md](PRIVACY.md) and [TERMS.md](TERMS.md).
- Confirm receipt and NIU requirements with a Cameroonian accountant.
- Configure Firebase Authentication, tenant claims, rules, backups, and Cloud Functions in `europe-west1`.
- Implement verified MTN Mobile Money and Orange Money callbacks in Cloud Functions; never put credentials in Flutter.
- Complete security review, data-retention policy, incident process, and merchant data-processing terms.

See [SECURITY.md](SECURITY.md) for the minimum security baseline.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
