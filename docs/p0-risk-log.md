# MboaPOS pilot risk log

| Risk | Severity | Evidence | Status / next action |
|---|---|---|---|
| Production backend is unverified | Critical | Auth, Firestore, and Functions passed local emulator integration; this does not prove deployment, production claims, or production rules | Verify deployment and configuration in the intended Firebase project before pilot |
| Merchant fiscal profile is unverified | Critical | NIU/address are editable settings; fiscal verification defaults false; receipts display non-fiscal until the server profile is verified | Confirm merchant details and fiscal requirements with an authorized accounting source; do not claim fiscal readiness |
| Offline sales can remain unresolved | High | Durable outbox retries after sign-in; non-retryable server failures become `needsReview`, but there is no dedicated review/resolve UI or connectivity worker | Add an operator review flow and controlled retry/void handling before relying on long offline periods |
| Android runtime baseline is unverified | High | `flutter build apk --debug` succeeds; no physical Android device/emulator was available for runtime validation | Test on compact Android 10 / 720p / 2 GB RAM hardware, including restart and offline recovery |
| Drift migrations and backup policy are incomplete | High | Local schema version is `1`; no migration or local-data recovery policy is defined | Add migration, retention, and backup/recovery policy before schema changes or broad rollout |
| Product and settings caches are device-local | High | Drift cache is tenant-scoped on reads and updates; no device-to-device catalog synchronization is included | Confirm local data lifecycle and merchant device recovery expectations |
| Receipt presentation is not fiscal certification | High | PDF share/print exists; no printer hardware or fiscal authority validation was performed | Keep receipts marked non-fiscal until profile and legal workflow are verified |
| Automated sync trigger is limited | Medium | Outbox sync runs after establishing a valid session; no connectivity observer/background scheduler exists | Add resilient background scheduling after platform constraints and conflict handling are specified |
| Functions deployment may require billing | High | Prior deployment attempt was blocked by the Firebase project's plan requirement | Confirm plan/quota and deploy through the approved production process |
| Raw technical error details may not be localized | Medium | User-facing wrappers are localized, but server/network exception details can still contain technical text | Keep technical detail available for diagnosis without presenting it as user guidance; review copy in both locales |
| Android release configuration is incomplete | Medium | Debug APK builds; signing/release packaging was not validated | Configure and verify release signing outside source control |
