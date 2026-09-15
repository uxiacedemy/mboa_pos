# Security baseline

- Firestore must use default-deny rules and validate `organizationId` against authenticated claims.
- Payment initiation and webhook verification belong in Cloud Functions, never in Flutter web code.
- Never commit Firebase service-account keys, Mobile Money credentials, PINs, tokens, or `.env` files.
- Pending local sales require an explicit sync state and idempotency key before retry.
- Completed transactions are immutable; voids and refunds create separate auditable records.
- Production launch requires a threat model, Firestore rules emulator tests, dependency audit, backup/restore drill, and a reviewed privacy notice.