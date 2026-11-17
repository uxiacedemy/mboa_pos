# MboaPOS mobile architecture and data lifecycle

## Current architecture

The Flutter app uses Riverpod, GoRouter, Firebase Auth/Firestore/Functions,
Flutter Secure Storage, and Drift in the feature-first structure under
`lib/features`. Firebase Functions are configured for `europe-west1`. Drift
stores product and organization-settings caches, checkout outbox entries,
receipts, and local stock movements. The Android and Web builds both compile;
Web uses the release-matched Drift worker and SQLite WASM assets.

## Identity and authorization

- Organization and role are sourced from refreshed Firebase Auth claims and
  checked against the staff membership document at sign-in.
- A stable secure-storage device UUID is an identifier, not authorization.
- Checkout sends organization, actor, and device identifiers, which the
  callable checks against the authenticated identity.
- Firestore reads require an active, recognized staff role and matching tenant.
  Settings updates are field-scoped; product price and profile fields require
  manager/admin roles. Clients cannot write transactions or stock movements.
- Completed transactions are immutable under the rules. Rules are default-deny
  for unknown paths.

## Catalog lifecycle

1. The POS loads the organization's cached Drift products.
2. Firestore snapshots refresh that organization's cache; inactive or deleted
   documents are removed from the local catalog.
3. Pending and needs-review sale quantities remain reserved when a server
   snapshot refreshes cached stock.
4. Catalog refresh failures preserve cached products and expose an error/retry
   state.

## Checkout lifecycle

1. The cashier reviews item snapshots, integer XAF amounts, and a payment
   recording label. Tax settings come from cached organization settings, not a
   rate entered in checkout.
2. A UUID idempotency key and deterministic request fingerprint identify one
   immutable checkout command.
3. One Drift transaction guards cached stock, decrements its local projection,
   and stores the provisional receipt, stock movements, and outbox command.
4. The client submits the same command to `commitCheckout`.
5. The callable revalidates the active tenant, product state/price/stock,
   organization tax settings, discount and totals. One Firestore transaction
   decrements stock and writes movements, transaction, idempotency record, and
   per-terminal/per-Cameroon-day receipt counter.
6. On acknowledgement, the client atomically replaces provisional receipt
   metadata with the server receipt and removes the outbox entry.
7. Retryable failures leave the outbox record pending. Other server failures
   become `needsReview`; the current receipt indicates this state but a
   dedicated review/resolve workflow is not implemented.
8. Pending records are retried after a valid session is established. There is
   not yet a connectivity-triggered background worker or platform work manager.

## Tax and receipts

- New organizations start with tax disabled and a stored default rate of 19.25%.
  Owners can enable tax and edit or clear the rate.
- The server settings document is authoritative; the callable recalculates tax
  and total before accepting a sale.
- The callable allocates receipt numbers in the form
  `YYYYMMDD-{terminalId}-{sequence:05d}` using the `Africa/Douala` business day
  and returns a server issue time.
- Provisional/offline receipts use a local reference/time and display that they
  are provisional. A server-accepted receipt uses the allocated number and
  server time.
- Receipts explicitly remain non-fiscal unless the merchant fiscal profile is
  verified. NIU/address values are merchant-configured and have not been
  independently verified; printing/sharing does not establish fiscal validity.

## Verified limits and release gaps

- Drift schema version is currently `1`; migration and backup/restore strategy
  needs an upgrade path before broad rollout.
- Firebase Functions are covered by local emulator tests but are not confirmed
  deployed to the production Firebase project.
- No dedicated `needsReview` resolution UI, connectivity worker, or
  physical-printer integration exists.
- Firebase auth requires a valid session; offline sign-in and device recovery
  behavior have not been validated on the target Android device.
- Emulator and APK builds are not substitutes for staging rules review,
  merchant fiscal verification, or a physical Android offline test.
