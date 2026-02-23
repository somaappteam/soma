# App Review Suggestions (2026-02-23)

## 1) Improve onboarding docs for contributors
- `README.md` is currently still the default template and does not explain setup, architecture, environment variables, or release flow.
- Add: local setup steps, required `.env`/`--dart-define` values, common commands (`flutter pub get`, `flutter analyze`, `flutter test`), and a short architecture map.

**Why this matters:** It lowers contributor ramp-up time and prevents setup drift.

## 2) Break down `dm_chat_screen.dart` into smaller feature widgets/controllers
- `lib/features/social/dm_chat_screen.dart` is very large (4,585 LOC), which increases risk for regressions and slows code review.
- There is also an in-file TODO about TURN relay handling in the RTC path.

**Suggested split:**
- `dm_chat_header.dart`
- `dm_message_list.dart`
- `dm_input_bar.dart`
- `dm_call_controls.dart`
- `dm_chat_controller.dart` (state + side effects)

**Why this matters:** Smaller files are easier to test, reason about, and refactor.

## 3) Move app-level sync UI state out of globals
- `lib/main.dart` keeps global `ValueNotifier`s (`syncStatusNotifier`, `syncMessageNotifier`) plus global `navigatorKey`.
- Consider moving sync status into a dedicated app-state/service layer exposed through DI (or a state framework already used by your team).

**Why this matters:** Global mutable state can be harder to test and can grow into hidden coupling over time.

## 4) Improve dependency registration maintainability
- `lib/core/di/locator.dart` manually registers many repositories one by one.
- This works, but it becomes fragile as features grow.

**Suggested improvement:**
- Group registrations by domain module (auth/social/quiz/etc.) in separate setup files.
- Optionally adopt codegen DI (if your team is open to it).

## 5) Add architecture/quality guardrails to CI
- Given the current app breadth (real-time, notifications, purchases, localization, offline queue), add lightweight CI checks if not already present:
  - `flutter analyze`
  - `flutter test`
  - optional changed-files formatting check

**Why this matters:** Catch issues before merge and reduce hotfix pressure.

## 6) Tighten release metadata and package identity
- `pubspec.yaml` still has generic metadata (`description: "A new Flutter project."`).
- Update app description and consider documenting semantic versioning + build numbering policy.

## 7) Consolidate planning docs into one index
- The `docs/` folder already contains many planning/recommendation documents.
- Add a single `docs/INDEX.md` that maps active vs archived plans and ownership.

**Why this matters:** Prevent duplicate planning efforts and make priorities easier to find.

## 8) Add explicit reliability backlog for offline + RTC edge cases
- You already have offline queue + realtime + voice/calls, which are reliability-sensitive surfaces.
- Maintain a dedicated reliability checklist for:
  - network flaps during calls
  - message retry idempotency
  - timezone/notification edge cases
  - reconnect behavior after app background/foreground cycles

---

If you'd like, I can turn these into a prioritized 2-week implementation roadmap (quick wins first, then structural refactors).
