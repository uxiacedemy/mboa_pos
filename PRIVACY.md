# MboaPOS Privacy Notice

**Status:** pilot template. Replace the placeholder contact and legal entity details before public launch.

MboaPOS processes information needed to operate a merchant point of sale: organization details, staff identity and role, products, stock movements, sales, receipts, payment references, device identifiers, and synchronization status.

## Offline storage

The web pilot stores catalog and pending sales in the browser on the merchant device so checkout can continue without connectivity. A merchant must not use a shared or public browser profile. Clearing browser storage can remove unsynchronized local data; the application must show pending status before a user clears data.

## Synchronization and security

When configured, synchronized data is stored in the merchant organization's Firebase project. Access must be protected with Firebase Authentication and tenant-isolated Firestore rules. Payment credentials, PINs, tokens, and webhook secrets must never be stored in browser storage or committed to source control.

## Retention and rights

The merchant organization controls its business records and is responsible for lawful collection of customer information. Requests for access, correction, export, or deletion should be sent to the verified data controller at `privacy@mboapos.example` until the operator publishes a real address. Legal retention obligations for accounting and tax records may limit deletion.

## Cookies and analytics

The pilot should use only essential storage. Analytics, marketing cookies, and third-party tracking require a documented purpose and appropriate consent before activation.

This notice is operational documentation, not legal advice. Confirm Cameroon data-protection, tax, consumer, and electronic-transactions obligations with qualified counsel before launch.