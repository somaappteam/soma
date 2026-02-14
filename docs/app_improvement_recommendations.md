# Soma App Improvement Recommendations (Code-Informed)

This roadmap is based on the current codebase structure and focuses on fixes that improve reliability, security, and velocity.

## Top 5 improvements to start this week

1. **Move Supabase config out of `main.dart` and rotate keys immediately**
   - Put URL/key in compile-time config (`--dart-define`) or a secure env strategy.
   - Add startup validation to fail fast when config is missing.
   - Rotate the currently committed anon key after migration.

2. **Fix sync error reporting so failures are not hidden**
   - `syncEverything()` currently catches and logs internal errors without rethrowing.
   - Return a sync result object (`success`, `failedSteps`, `durationMs`) and use it in the banner UI.
   - Add retry/backoff for transient network failures.

3. **Normalize locale persistence to language codes**
   - Store `language_ui` as canonical codes (`en`, `es`, etc.) rather than display labels (`English`, `Spanish`).
   - Replace large switch mapping with a map-driven implementation.
   - Add migration logic for existing persisted values.

4. **Remove duplicate auth API surface**
   - `signOut` and `signOutWithSessionEnd` currently do the same thing.
   - Keep one public method and document behavior clearly.
   - Add auth error analytics for failed sign-in/sign-out/reset-password operations.

5. **Add a minimum CI quality gate**
   - Required checks: static analysis, unit tests for repositories/services, smoke widget tests for login/home navigation.
   - Add code coverage reporting and define a low initial threshold that can be raised over time.

---

## Detailed recommendations by category

### A) Security & configuration

- Externalize backend configuration from source code.
- Add a `Config` abstraction to centralize access to environment variables.
- Include a short security checklist in contributor docs:
  - no secrets in commits
  - key rotation process
  - incident response for accidental key exposure

### B) Data sync reliability

- Replace "log-only" catches with structured error propagation.
- Track per-table sync metrics (`courses`, `vocabulary`, `sentences`, profile data) to identify slow/failing paths.
- Add incremental sync markers (`updated_at` cursors) to reduce startup load.
- Add a manual "retry sync" action in settings/profile.

### C) Settings model and consistency

- Define a typed settings model instead of raw map lookups for common keys.
- Merge guest defaults with server settings so missing keys always receive safe defaults.
- Persist guest bulk updates in local storage in `updateSettings` as well.

### D) App architecture and maintainability

- Keep startup orchestration in a dedicated bootstrap service instead of growing `main.dart`.
- Define a consistent state-management rule per feature area (and document it).
- Move feature-specific domain logic out of screens into services/use-cases.

### E) Observability

- Add structured event logs for:
  - app start latency
  - sync duration and failure reasons
  - auth flow outcomes
  - first lesson completion and day-1/day-7 retention signals
- Add crash reporting + performance traces on startup and network-heavy screens.

### F) UX and accessibility

- Audit contrast and semantics labels on key interactive elements.
- Expand support for larger text sizes while preserving layout stability.
- Make sync banners actionable (retry button + error detail CTA).

---

## Suggested implementation sequence (2 sprints)

### Sprint 1 (stability/security)

1. Config externalization + key rotation.
2. Sync error propagation + retry/backoff.
3. Auth API deduplication.
4. Add core observability events.

### Sprint 2 (quality/maintainability)

1. Locale code migration + map-based locale resolver.
2. Typed settings model + guest/server merge defaults.
3. CI quality gates and baseline tests.
4. UX/accessibility fixes from audit pass.

---

## Definition of Done for this roadmap

- No runtime secrets in source.
- Sync failures are visible, retryable, and measurable.
- Locale/settings logic uses canonical codes and typed access.
- Auth/session API has no duplicate methods.
- CI blocks merges on critical regressions.

