# App-wide Dynamic Experience Blueprint (Make Soma Feel Alive Everywhere)

Use this as a product + implementation guide to make the whole app feel responsive, intelligent, and premium — not just Inbox/DM.

## 1) Home: make momentum visible instantly

- Add a **Today Momentum strip** at the top:
  - streak, XP earned today, minutes practiced, next goal.
- Add **live cards** that react to user activity in-session:
  - “1 more lesson to keep streak”, “2 pending circle invites”, “3 new vocab from today”.
- Show **adaptive quick actions**:
  - Resume last lesson, join active circle, continue unfinished exchange.
- Add subtle motion states (count-up numbers, progress pulse, confetti micro-burst on milestones).

## 2) Onboarding/Auth: emotional energy + clear trajectory

- Turn onboarding into a **3-step journey** with dynamic preview of outcomes:
  - Step 1 goal, Step 2 interests/language, Step 3 commitment cadence.
- Add **instant personalization previews**:
  - “Your plan this week” generated before account creation finishes.
- Add **first-win in <60 seconds** flow:
  - after signup: one micro-lesson + one social interaction CTA.

## 3) Lessons/Courses: reduce static content feeling

- Add **session energy meter** (pace + confidence trend).
- Introduce **adaptive lesson branching**:
  - easier/harder follow-up cards based on answer speed + correctness.
- Show **dynamic recap tiles** after each session:
  - strongest topic, weakest topic, suggested next action.
- Add lightweight **celebration choreography** for completed units.

## 4) Circles/Social discovery: make rooms feel truly live

- Add **live room preview chips**:
  - participants count, active topic, language mix, quality signal.
- Show **real-time room events** in feed:
  - “3 joined”, “Topic switched to travel phrases”, “Voice room started”.
- Add **intent-based matchmaking states**:
  - “Looking for pronunciation partner now”, “Available for 10 min quick practice”.
- Add trust/status badges:
  - verified learner, reliable responder, mentor-style helper.

## 5) Profile/Progress: transform into a living progress narrative

- Replace static profile stats with **timeline milestones**:
  - weekly progress moments, streak saves, circle achievements.
- Add **skill radar chart** that updates after sessions.
- Include **dynamic goals**:
  - system adjusts next goals based on actual behavior (missed days, high performance bursts).
- Add **shareable progress cards** (optional social proof).

## 6) Settings: confidence + control center

- Introduce a compact **System Health section**:
  - sync status, last backup/sync, storage usage, current app version/build.
- Add **notification intelligence controls**:
  - “only high-value reminders”, quiet hours, personalized nudges.
- Add **privacy transparency cards**:
  - what data is used for recommendations and how to opt out.
- Keep settings short, route deep options to dedicated pages.

## 7) Monetization/Premium: premium should feel like capability, not paywall

- Show **capability deltas** in context:
  - when user hits a limit, preview immediate unlock value on current task.
- Add **premium usage dashboard**:
  - what premium features were used this week and outcomes.
- Add trust layer:
  - subscription status, renewal date, invoice/receipt, restore, cancel path.

## 8) Notifications: from noisy to smart and alive

- Build a **priority model** for notifications:
  - learning-critical, social-critical, optional.
- Add **adaptive send times**:
  - trigger reminders at user’s most responsive times.
- Make notifications action-first:
  - “Reply now”, “Join room”, “Resume lesson” with deep links.

## 9) UX motion system: coherent animation language across pages

- Define 4 motion types only: `enter`, `status-change`, `reward`, `urgent`.
- Set duration ranges:
  - micro (120–180ms), standard (180–260ms), celebration (300–450ms).
- Use motion to communicate state, never decoration-only.

## 10) Audio/Haptics: subtle sensory feedback

- Add optional **signature micro-sounds** for achievements, send success, lesson completion.
- Add haptic categories:
  - light tap (selection), medium success (goal completion), warning pulse (failed sync/action).
- Keep everything toggleable in accessibility/settings.

## 11) Reliability cues: visible professionalism

- Add user-facing states globally:
  - syncing, offline queueing, retrying, resolved.
- Surface one-tap recovery actions everywhere errors can happen.
- Add clear fallback copy and avoid dead ends.

## 12) Accessibility + localization as premium multipliers

- Ensure all dynamic components have semantic labels and screen-reader updates.
- Avoid global text scaling suppression patterns that block large-text users.
- Run pseudo-localization to catch truncation in dynamic cards/chips.

## App-wide implementation architecture (recommended)

- Create a centralized `LiveExperienceController` responsible for:
  - momentum stats,
  - dynamic recommendations,
  - notification timing hints,
  - cross-page event feed.
- Create `ExperienceEvent` taxonomy:
  - `lesson_completed`, `streak_saved`, `circle_joined`, `message_replied`, `goal_missed`, etc.
- Build reusable widgets:
  - `MomentumStrip`, `LiveStatusChip`, `RecoveryBanner`, `ProgressMilestoneCard`.

## KPI framework to validate “alive” improvements

- Activation: first meaningful action in session (`<60s`).
- Engagement: actions/session, feature depth/session, return rate D1/D7.
- Learning outcomes: sessions/week, lesson completion rate, streak consistency.
- Social vitality: circle joins/week, reply latency, conversations sustained >3 turns.
- Reliability perception: error recovery success %, sync-failure drop-off rate.
- Premium conversion: conversion after hitting contextual limits, premium retention D30.

## 4-sprint rollout plan

- **Sprint 1 (Foundation):** momentum strip, live status chips, reliability cues.
- **Sprint 2 (Learning vitality):** adaptive lesson branching + dynamic recaps.
- **Sprint 3 (Social vitality):** live circles events + trust badges + smarter notifications.
- **Sprint 4 (Premium polish):** premium usage dashboard, motion/haptics pass, accessibility+L10N QA.

## Product principle checklist (use before every release)

- Does this screen show meaningful live state?
- Does user see immediate next best action?
- Is there recovery guidance when something fails?
- Does motion/sound reinforce state change clearly?
- Does this remain accessible and localized at high quality?

