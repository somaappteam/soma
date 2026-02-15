# Suggested Improvement: Localize Sync Status Messaging

## Why this is a high-impact next improvement

The app already supports many locales via generated localization files and ARB translations, but the sync banner messaging in `lib/main.dart` is currently hardcoded in English. This creates an inconsistent experience for non-English users at a critical trust moment (when data sync is retrying or failing).

## What to improve

Move all sync-banner strings to `AppLocalizations` and use localized copy for:

- syncing state label (`"Syncing…"`)
- failure title (`"Sync failed"`)
- retry CTA (`"Retry"`)
- dynamic retry message
- final error fallback message

## Recommended implementation steps

1. Add new localization keys in `lib/l10n/app_en.arb` for all sync-banner strings.
2. Propagate those keys to other locale ARB files over time (or use fallback to English where translation is pending).
3. Refactor `lib/main.dart` to build sync messages using `AppLocalizations.of(context)` instead of inline string literals.
4. Keep dynamic parts structured (e.g., failed step list and retry attempt count) with interpolation placeholders in ARB.
5. Add a small widget test that verifies the banner uses localized values in at least one non-English locale.

## Success criteria

- Sync messaging appears localized when the app locale changes.
- No user-facing sync banner text remains hardcoded in `main.dart`.
- Existing sync retry behavior is unchanged.
