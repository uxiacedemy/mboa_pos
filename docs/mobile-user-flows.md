# MboaPOS mobile user flows

Status reflects code and checks run for this change set; a local emulator or
build does not imply a production deployment or fiscal certification.

## Launch and authentication

- **Implemented:** On first use, the app shows a MboaPOS welcome screen, then
  offers staff sign-in, owner sign-in, or business creation. Welcome completion
  is stored on the device; later signed-out launches go straight to the choice
  screen, while authenticated users go to the POS.
- **Implemented:** English/French selection is available throughout the
  welcome, account-choice, sign-in, and registration screens. The rest of the
  app continues to use French after sign-in.
- **Implemented:** Firebase initialization, staff PIN sign-in, owner
  email/password registration, custom-claim organization/role provisioning, and
  membership checks.
- **Implemented:** GoRouter requires a staff session for POS and applies role
  gates to inventory, reports, and settings routes.
- **Partial:** Incomplete owner registration can be retried under the same UID.
  Authentication failures have localized categories, but production Functions
  and deployment are not confirmed.

## POS and checkout

- **Implemented:** The catalog loads from a tenant-scoped Drift cache and
  refreshes from Firestore. The POS has loading, error/retry, empty, and
  populated states; the demo product catalog has been removed.
- **Implemented:** Cart quantity changes, discount/delivery amounts, and
  Cash/MTN MoMo/Orange Money/Other recording labels.
- **Implemented:** Tax is read from organization settings and recomputed by the
  server. Tax is disabled for new organizations; an owner may edit the rate.
- **Implemented:** Checkout commits a provisional receipt, local stock
  projection, movement records, and idempotent outbox command in one local
  transaction before calling the server.
- **Implemented:** The callable verifies current prices, tax, totals, tenant,
  active staff claims, and stock, then writes the transaction, stock
  movements, and terminal/day receipt counter atomically.
- **Partial:** Retryable commands are durable and retried after sign-in.
  Connectivity-triggered background retry and a dedicated permanent-failure
  review workflow remain.

## Receipts and operations

- **Implemented:** Receipts persist locally and distinguish provisional,
  needs-review, and non-fiscal states. Server-accepted receipts use server
  numbering/time and carry server-returned organization details.
- **Partial:** PDF share/print actions are implemented, but no printer hardware
  validation or fiscal certification has been performed. Merchant NIU and tax
  values remain unverified configuration.
- **Planned:** Inventory management, reports, staff administration, returns,
  voids, refunds, and resolving `needsReview` sales.

## Validation status

- Flutter analyzer and the current Flutter test suite pass.
- Firebase Auth/Firestore/Functions emulator integration tests pass, including
  checkout concurrency/idempotency, tax authority, active-role checks,
  field-level settings permissions, cross-tenant access, and transaction
  immutability.
- Web and Android debug builds pass. Runtime startup was verified on the
  connected Samsung SM-G950F (Android 9/API 28): Firebase initialized,
  authentication restored as signed out, secure storage resolved, and the
  repaired startup route reached account selection. Android 9 was not the
  intended Android 10 baseline, and offline sign-in/production checkout remain
  unverified.
- Production Firebase callables/rules and a browser authenticated checkout have
  not been verified.
