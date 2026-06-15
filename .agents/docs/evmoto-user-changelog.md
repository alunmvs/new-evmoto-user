# Changelog — Evmoto User

> A plain-language summary of app updates for Evmoto passengers. Written for non-technical readers — no developer jargon.

---

## How to Read This Document

Each new version is added **at the top** (the latest version is always first). Changes are grouped into:

| Category | What it means |
|----------|---------------|
| **New Features** | New capabilities or screens you can use right away |
| **Fixes** | Problems that have been resolved for a more stable app |
| **Look & Feel** | Visual, text, or flow changes that make the app easier to use |

**Tip:** After updating, check your version number under **Account → About** (or in the Play Store / App Store) to confirm you are on the latest release.

---

## Version 1.2.10

**Release date:** 12 June 2026  
**Build:** 54

### Summary

This release introduces **advance booking** so you can schedule rides ahead of time, adds clearer **waiting-time fee** details on trip invoices, and fixes several issues related to logout, maps, notifications, and order status.

---

### New Features

- **Advance booking** — You can now book a ride in advance from the checkout screen. Track your scheduled trip on the **Activity** tab, view full details (route, driver, fare), cancel when allowed, or **order again** after a completed or cancelled booking.
- **Waiting time fee info** — On trip history and advance booking detail screens, the invoice now shows a separate **waiting time fee** line so you can see how much of the total fare comes from waiting charges.

---

### Fixes

- **Cleaner logout** — After signing out, your login session is fully reset and any leftover background requests are stopped, so your next login is smoother and more reliable.
- **Login screen after auto sign-out** — Fixed an issue where the login form could appear blank after you were automatically signed out (for example, when your account is used to log in on another device).
- **Order timeout** — Fixed an issue where active orders could time out incorrectly.
- **Map markers** — Pickup and destination pins on the map now appear in the correct positions.
- **Invoice display** — Fixed a display issue on advance booking invoices when no waiting fee was charged.
- **Notifications** — Opening the app from a push notification now refreshes the order or booking status correctly, so you see up-to-date information right away.

---

### Look & Feel

- **Driver cancellation info** — On the activity detail screen, you can now clearly see when a trip was **cancelled by the driver**.
- **Faster maps** — Map screens load and respond more smoothly during booking and while tracking your ride.
- **Smarter map zoom** — The checkout map automatically adjusts its zoom level based on how far your pickup and destination are, so both locations are easier to see.
- **Advance booking cards** — Redesigned booking history cards and checkout layout make scheduled trips easier to read and manage.
- **Snackbar & copywriting** — Updated alert messages and in-app text for clearer, more consistent wording.

---

## Template for the Next Version

> Copy the block below each time a new version is released, then fill in the user-facing changes.

```markdown
## Version X.Y.Z

**Release date:** DD Month YYYY  
**Build:** N

### Summary

[One or two sentences: what is this release mainly about?]

---

### New Features

- **[Short title]** — [Explain the benefit for passengers, without technical terms.]

---

### Fixes

- **[Short title]** — [What problem no longer happens.]

---

### Look & Feel

- **[Short title]** — [What looks or feels different when using the app.]
```

### Guidelines for writing new entries

1. Write from the **passenger’s** point of view, not the developer’s.
2. Avoid terms like *API*, *controller*, *refactor*, *endpoint*.
3. Explain the **benefit**: “You can now …”, “It’s easier to …”, “You no longer need to …”.
4. One bullet = one change that can be described in a single sentence.
5. Internal-only changes (automated tests, team documentation) do **not** need to be listed.

---

*This document starts from version 1.2.10. Future version notes are added above the “Template for the Next Version” section.*
