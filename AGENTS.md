# MboaPOS Agent Instructions

## Product and scope

MboaPOS is a Flutter POS and inventory app for small and medium businesses in Cameroon. It is a seller-side recording tool, not an e-commerce platform or payment processor. The current default is Phase 3 MVP work.

Payment methods are recording labels only in the MVP: Cash, MTN MoMo, Orange Money, and Other. Do not add live mobile-money API calls, payment credentials, webhooks, or payment-state machinery unless the request explicitly targets a later payment-integration phase.

Design for the primary device reality: compact 5-inch 720p Android screens, 2 GB RAM, Android 10, slow 3G, and fully offline operation.

## Toolchain and commands

- Workspace: `C:\Users\EVERMATE\Desktop\mboa_pos`
- Flutter SDK: `C:\Users\EVERMATE\flutter`; Flutter is configured in User `PATH`, but this SDK install cannot launch its `.bat` entry point directly from PowerShell. Always invoke it through `cmd.exe /d /c`, for example `cmd.exe /d /c "C:\Users\EVERMATE\flutter\bin\flutter.bat analyze"`.
- Root cause verified 2026-09-15: PowerShell has normal `PATHEXT`, `RemoteSigned` execution policy, and the Flutter bin directory in User/current `PATH`; the batch file also resolves its internal scripts and Dart executable through absolute paths, yet direct PowerShell process launch still fails while `cmd.exe` succeeds. Treat the `cmd.exe /d /c` workaround as permanent for this SDK install.
- Common checks: `flutter pub get`, `flutter analyze`, `flutter test`, and `flutter run -d chrome --web-port 8080`.
- Do not combine `cd` and a Flutter command into one malformed command. Run them as separate commands or set the working directory.
- If Flutter reports a path or `DIR /B` problem, diagnose the SDK installation/path first; do not infer an application architecture failure from that warning.

## Repository shape

Use the feature-first structure under `lib/features/` (`auth`, `sales`, `inventory`, `reports`, `settings`, and `shell`). Shared routing and design tokens live under `lib/core/`. Riverpod is initialized in `lib/main.dart`; the router is in `lib/core/router/app_router.dart`.

Prefer existing patterns and small, focused changes. Inspect the actual implementation and nearby tests before editing. README claims and roadmap items may describe planned behavior that is not wired yet. In particular, verify persistence, Firebase, Firestore, authentication, stock movement, receipt, and sync behavior in code before relying on it or reporting it as complete.

Useful references:

- [README](README.md) for pilot scope and local commands
- [Security baseline](SECURITY.md)
- [Privacy policy](PRIVACY.md)
- [Terms](TERMS.md)
- [Firestore rules](firestore.rules)
- [Design tokens](lib/core/design/design_tokens.dart)
- [Routing](lib/core/router/app_router.dart)

## Current Implementation Status

This is the current Gate 1 baseline. Update this table whenever a feature is verified or changed; do not rely on README or roadmap claims when the code disagrees.

| Feature | Status | Blocked by | Last verified |
|---|---|---|---|
| Drift persistence | Missing | No local database layer | 2026-09-15 |
| Firebase initialization | Partial (SDK initialization added; platform project options are not configured) | Firebase platform configuration | 2026-09-15 |
| Firestore wiring | Partial (Product mapping, StockMovement model, stock exception, and checkout transaction added; project configuration and repository boundaries remain) | Firebase project configuration and repository boundaries | 2026-09-15 |
| Authentication | Partial (PIN sign-in, StaffUser session, secure device ID, and auth-only route redirect added; session restoration and platform configuration remain) | Firebase platform configuration and staff claim provisioning | 2026-09-16 |
| Stock deduction | Partial (guarded checkout transaction and movement write added) | Missing auth; no real staff identity to attach to actor/device fields | 2026-09-15 |
| Receipt persistence | Missing | No receipt persistence layer | 2026-09-15 |
| Receipt printing | Missing | No printer integration | 2026-09-15 |
| Sync | Missing | No durable local queue or sync worker | 2026-09-15 |
| Localization | Partial | Generated localization is not wired into `MaterialApp` and screens still contain hardcoded strings | 2026-09-15 |
| Route guards | Partial (authentication-only redirect for POS/sales routes) | Session restoration; role checks are intentionally out of scope | 2026-09-16 |
| Known minor issues | None; `flutter analyze` reports no issues | None | 2026-09-15 |

The current persistence target is deliberately limited to the minimum single-terminal Phase 3 flow: one product document, one guarded stock decrement, and one transaction record. Do not expand this work into Phase 4/5 infrastructure such as multi-branch synchronization, sharded counters, or Cloud Functions.

Phase 3 minimal auth = single-role PIN login only (`{staffId}@mboapos.internal` + PIN via Firebase Auth), populating real `actorId`/`deviceId`/`organizationId` in `payment_screen.dart`. Full `StaffRole` hierarchy (cashier/supervisor/manager/admin) and GoRouter role guards are explicitly Phase 3-later / Gate-1-adjacent, not part of this task.

## Non-negotiable domain rules

### Money and tax

- Store every FCFA/XAF monetary amount as an integer. Never use `double` or floating-point storage for money.
- Use integer arithmetic and explicit rounding for tax. Cameroon TVA defaults to 19.25%, but the shop tax rate must remain editable for future countries.
- Use `intl` with the `fr_CM` locale and zero decimal places for XAF display.
- Keep totals derived from integer line values and preserve discount and delivery fees as integers.

### Sale lifecycle

Allowed status transitions are only `draft -> active -> paymentPending -> completed`, with the permitted void/refund transitions defined by the domain model. Do not jump directly between arbitrary statuses.

Completed transactions are immutable. A void or refund creates a new record. Use a UUID and an authoritative server timestamp for persisted transactions; never treat the device clock as authoritative.

### Inventory and receipts

- Stock changes must be atomic and guarded against negative stock. Never perform an unguarded read-modify-write update. Use this exact Firestore transaction pattern, adapting only identifiers and domain types as required:

```dart
await db.runTransaction((txn) async {
	final snap = await txn.get(productRef);
	final current = snap.data()!['stockQty'] as int;
	if (current < saleQty) throw InsufficientStockException(...);
	txn.update(productRef, {'stockQty': FieldValue.increment(-saleQty)});
	txn.set(movementRef, movement.toFirestore());
});
```

When implementing checkout stock deduction, follow this instruction literally: **DELETE the current stock deduction logic in `lib/features/sales/presentation/screens/payment_screen.dart`, REPLACE with this exact transaction pattern.** Do not interpret this as a vague request to "make it atomic" and do not improvise an unguarded read-modify-write alternative.
- Log every stock change with actor, item, time, device, and movement type.
- Receipt numbers are unique per terminal per day: `YYYYMMDD-{terminalId}-{sequence:05d}`. Never use one global counter.
- Receipts must persist, show TVA separately, include the organization's NIU, and use `DD/MM/YYYY HH:mm` formatting. The current receipt model/check-out wiring must be audited before claiming fiscal compliance.
- Do not claim that receipt printing, checkout persistence, stock deduction, or sync exists unless the current code proves it.

### Offline-first and security

Write locally first, then enqueue durable background sync. Sync state must survive restarts and failures must not block cashier workflows. Keep conflict policy explicit: sales client-wins, price updates server-wins, stock adjustments require manual review.

Use the role hierarchy `cashier < supervisor < manager < admin`. Enforce authorization in GoRouter redirects and backend rules, not only by hiding controls. Discounts above threshold require supervisor approval; voids require supervisor authorization; price overrides require manager authorization. Never put secrets or API keys in source code.

Firestore must be default-deny and tenant-isolated. Completed transactions must reject update and delete at the rules layer. Cloud Functions, when added, belong in `europe-west1`, must be idempotent, and must not log sensitive payment details.

## Flutter conventions

- Use Material 3 (`useMaterial3: true`), Riverpod for application state, and GoRouter for navigation.
- Use `ref.watch` in builds and `ref.read` in event handlers. Keep business logic out of `build()` and keep widgets focused; split screens that grow beyond roughly 100 lines.
- Use immutable domain models and generated `copyWith` where Freezed is introduced. Do not hand-write generated model plumbing.
- Use `ListView.builder` or `GridView.builder` for dynamic lists with more than 20 items.
- Await all futures or handle them explicitly. Use bounded network timeouts and preserve errors for the UI; do not replace failures with unexplained generic success behavior.
- Use `CachedNetworkImage` with bounded cache dimensions for product images when network images are introduced.
- Keep `setState` for small ephemeral UI state only, and check `mounted` after async gaps.

## Design and localization

All visual values should come from `lib/core/design/design_tokens.dart`: `AppColors`, `AppSpacing`, `AppRadius`, `AppTypography`, `AppElevation`, and `AppDuration` when available. Do not add `Color(0xFF...)` literals or arbitrary pixel values in widget code. Maintain a minimum 48x48 dp touch target and WCAG AA text contrast.

User-visible strings belong in `lib/l10n/app_fr.arb` and `lib/l10n/app_en.arb`, with generated localization classes regenerated as needed. French is the primary locale. Do not add hardcoded English or French UI strings to widgets. Use `AppLocalizations.of(context)` and locale-aware date/currency formatting.

For every data-driven screen, provide explicit loading, error with retry, empty, and populated states. Design compact layouts first; keep one clear primary action per screen and make Android back navigation work.

## Change workflow

New terminal sessions default to `C:\Windows\system32` — always confirm `pwd`/`Get-Location` before running git or Flutter commands directly.

1. Identify the owning provider, repository, model, route, or security rule before editing.
2. Read the nearest implementation and test; distinguish implemented behavior from planned behavior.
	State which file(s) you opened and what you found before describing any feature as implemented.
3. Make the smallest change that preserves public APIs and existing design patterns.
4. Update both ARB files for user-visible copy and update focused tests for behavior changes.
5. Run the narrowest useful check, then `flutter analyze` and relevant tests when practical.
6. Report any unrelated pre-existing failures separately; do not silently work around them.

## Remaining Build Order

- [ ] (1) Firestore rules emulator validation for Stage 2 changes — Deferred: verify manually via staging Firestore project before first real merchant; not blocking local development
- [ ] (2) Minimal auth — staff PIN login, StaffUser session, route redirect — Partial: sign-in/session/device identity and authentication-only redirect added; session restoration remains
- [ ] (3) Provision `organizationId`/role via Cloud Function custom claims (Admin SDK)
- [ ] (4) Thread real organizationId/actorId/deviceId into payment_screen.dart
- [ ] (5) Idempotency key on checkout transaction
- [ ] (6) Confirm-button loading/disabled state during async transaction
- [ ] (7) Drift offline persistence — products, pending sales, receipts, sync queue
- [ ] (8) Receipt construction and persistence — numbering, NIU, TVA, timestamps
- [ ] (9) Receipt printing/sharing
- [ ] (10) Test suite — money/tax rounding, insufficient stock, multi-item checkout, idempotency, auth session, receipt numbering, offline recovery, rules emulator
- [ ] (11) Localization wiring in main.dart + remove hardcoded strings
- [ ] (12) Android signing/app config for release

Do not build Phase 4 or Phase 5 features, including AI, multi-branch scaling, subscription billing, embedded finance, or live mobile-money collection, unless the request explicitly unlocks that phase.
