# Additional Improvement Suggestions (Post `PremiumScreenScaffold` rollout)

These are targeted follow-ups to strengthen consistency, maintainability, and UX quality after the first scaffold/token pass.

## 1) Move all “magic spacing values” to tokens
- Replace literal values like `SizedBox(height: 6/10/12/14/18/24)` and ad-hoc paddings with `SectionGap`, `CardGap`, and `PremiumLayout.screenPadding(...)` everywhere.
- Add missing token roles for:
  - horizontal in-card spacing (`inlineGap`)
  - icon-to-label spacing (`labelGap`)
  - toolbar/control spacing (`controlGap`)
- Outcome: easier rhythm tuning and fewer one-off spacing regressions.

## 2) Normalize header architecture with a dedicated `PremiumHeader`
- Extract repeated top rows into one component with explicit slots:
  - `leading`, `title`, `subtitle`, `trailing`
  - `dense` vs `regular` modes
- Enforce typography contract (title weight/size, subtitle style, truncation).
- Outcome: removes duplicated row logic and keeps visual identity consistent.

## 3) Add breakpoint-aware typography scaling
- Pair current width tiers with text-size tiers so headings/body text adapt on tablets/desktop.
- Example roles:
  - `Display`, `ScreenTitle`, `SectionTitle`, `BodyStrong`, `BodyMuted`, `Caption`
- Outcome: better readability across devices and reduced oversized/undersized text edge cases.

## 4) Add a shared `PremiumList` wrapper
- Centralize list defaults:
  - bounce physics
  - separator spacing from `PremiumLayout.listGap(...)`
  - optional top/bottom insets
  - keyboard dismiss behavior
- Outcome: every list screen gets coherent behavior and spacing with less boilerplate.

## 5) Improve AppShell slot ownership boundaries
- Clarify which layer owns overlays (global shell vs per-screen scaffold) and document precedence.
- Add a lightweight slot policy doc:
  - global call pill = shell-owned
  - per-screen FAB/context action = screen-owned
- Outcome: fewer z-order and overlap bugs when new overlays are added.

## 6) Introduce golden/screenshot regression checks for layout rhythm
- Add a small golden test matrix for key screens:
  - Home, Leaderboard, Profile, Solo Result
  - compact phone width, regular phone width, tablet width
- Validate key invariants:
  - top padding
  - header spacing
  - card gap consistency
  - max content width constraints
- Outcome: catches visual drift early during refactors.

## 7) Add lint rules or CI checks for layout consistency
- Optional custom lint patterns:
  - discourage direct `EdgeInsets.fromLTRB(...)` in feature screens unless justified
  - flag repeated literal gap values if token exists
- Outcome: prevents design-system drift over time.

## 8) Improve accessibility and semantics in scaffold/header
- Ensure all header controls include semantic labels and minimum tap targets.
- Verify contrast/opacity choices for muted text in dark/light themes.
- Outcome: better assistive-tech support and clearer visual hierarchy.

## 9) Add migration checklist for remaining screens
- Create a short checklist for untouched screens (settings/auth/inbox/friends/etc.):
  - uses `PremiumScreenScaffold`
  - tokenized spacing only
  - list density via `PremiumLayout.listGap`
  - max-width constraints applied
- Outcome: predictable rollout with measurable completion.

## 10) Reduce nested `MediaQuery.of(context)` lookups
- Prefer getting width once in `LayoutBuilder` and passing derived density/padding down.
- Outcome: cleaner builds and fewer repeated computations.

---

## Suggested execution order
1. Token cleanup + `PremiumHeader` extraction.
2. `PremiumList` wrapper + AppShell slot policy doc.
3. Remaining screen migration.
4. Golden test coverage + CI lint guardrails.

## More suggestions (extended backlog)

11. **Introduce a `LayoutDebugOverlay` (dev-only)**
- Toggle a visual baseline grid, content max-width guides, and spacing markers in debug mode.
- Helps catch off-token spacing and misalignment quickly during QA.

12. **Define page-level density overrides**
- Keep global auto-density, but allow screen-level overrides for special contexts (e.g., quiz/result screens).
- Avoids forcing one density rule across fundamentally different interaction models.

13. **Create a `PremiumCardGroup` helper**
- A wrapper that enforces internal/external card spacing and shared section headers.
- Useful for Profile/Home where multiple cards should read as one group.

14. **Add motion accessibility presets**
- Respect reduced-motion settings with lighter/faster animations and optional effect suppression.
- Ensure `StaggeredIn`, page transitions, and button pulse animations degrade gracefully.

15. **Unify empty/loading/error states**
- Build reusable `PremiumStateView` variants for loading, empty, and error.
- Standardize icon, title, body text, and action layout for all list/detail screens.

16. **Adopt semantic elevation levels in docs + code comments**
- Explicitly map `GlassDepth` levels to use cases (interactive card, modal, nav chrome).
- Reduces inconsistent depth usage and visual noise.

17. **Add interaction response budget targets**
- Document target durations (tap feedback, nav transition, stagger delay ceilings).
- Keep UI snappy and avoid stacked animations feeling sluggish on low-end devices.

18. **Create a screen composition checklist in PR template**
- Add checklist items: scaffold used, spacing tokenized, max width constrained, semantics added.
- Improves review quality and consistency for future migrations.

19. **Add per-breakpoint visual acceptance snapshots**
- Beyond golden tests, store reviewer-friendly screenshots for mobile/tablet/desktop in CI artifacts.
- Speeds human QA for layout changes.

20. **Standardize top action hit areas**
- Ensure icon actions in headers are at least 44x44 logical pixels with consistent visual framing.
- Reduces accidental misses and improves perceived polish.

21. **Extract reusable “title + meta + actions” row pattern**
- Common in results, cards, and profile sections.
- Centralizing this pattern improves consistency and typography hierarchy.

22. **Improve keyboard-aware layout behavior**
- Audit screens with search/inputs to ensure paddings and overlays adapt when keyboard opens.
- Prevents clipped content and awkward floating action overlap.

23. **Define dark-mode contrast thresholds by token role**
- Validate muted/medium/high text tones against WCAG targets for both themes.
- Prevents low-contrast regressions from opacity tuning.

24. **Instrument UI performance for animation-heavy screens**
- Add profiling notes and optional perf counters for heavy areas (leaderboard/profile/results).
- Catch frame drops from layered blurs, shadows, and simultaneous transitions.

25. **Plan gradual migration of legacy widgets to semantic tokens**
- Track legacy components that still rely on hardcoded colors/spacing.
- Move incrementally to semantic tokens to avoid broad risky rewrites.

26. **Document slot collision handling rules**
- Define what happens if both shell and screen request top-right overlays simultaneously.
- Include priority/fallback behavior to avoid overlap bugs.

27. **Introduce `PremiumInset` utilities for safe paddings**
- Reusable helpers for horizontal/page/list/modal insets by density and breakpoint.
- Avoids repeated `EdgeInsets` declarations.

28. **Audit localization stress-cases for headers/buttons**
- Test long strings in major locales to ensure truncation and wrapping remain stable.
- Prevents overflow and clipped actions in constrained layouts.

29. **Create design-token changelog discipline**
- Any token value change should include rationale and impacted screens list.
- Improves traceability for visual regressions.

30. **Add “layout debt” labels in issue tracker**
- Tag non-token spacing, legacy scaffold use, and ad-hoc max-width logic as cleanup items.
- Enables systematic cleanup over ad-hoc fixes.
