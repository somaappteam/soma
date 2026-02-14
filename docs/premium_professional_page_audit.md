# Premium & Professional UX Improvements (Detailed Page-by-Page Explanation)

This guide explains **what to improve**, **why it matters**, and **how to implement it** for each major page in Soma.

Goal:
- Make users feel: "this app is polished, serious, and worth paying for."
- Improve conversion without locking core learning behind paywalls.

---

## 1) App Shell / Navigation

Current behavior:
- Users switch between Home, Circles, and Profile.
- Guests are blocked when opening Circles.

### What to improve
1. **Turn the guest block dialog into a value dialog**
   - Instead of only saying "you must sign in," explain benefits:
     - Live circles with real learners
     - Voice rooms
     - Friend challenges
2. **Add one-tap "Quick Resume"**
   - A visible action to continue the last unfinished lesson.
3. **Upgrade tab professionalism**
   - Unread badges (Inbox / notifications), consistent transitions, tactile feedback.

### Why this feels premium
- Premium products are clear and intentional at navigation level.
- "Resume" removes friction and increases daily consistency.

### Implementation idea
- Save the last lesson context (`course`, `mode`, `checkpoint`) in local cache.
- Render a resume chip/button globally when context exists.

---

## 2) Home Page (Learning Command Center)

Current behavior:
- Shows courses list with edit/add flow.

### What to improve
1. **Today Plan card (top of page)**
   - Show daily target: minutes + XP + suggested exercise.
2. **Weakness recovery strip**
   - Example: "Past tense accuracy dropped 12% this week."
   - CTA: "Fix now (5 min)".
3. **Progress intelligence**
   - Weekly mini chart: streak, retention, accuracy trend.
4. **Premium teaser placement**
   - Keep learning actions free.
   - Upsell advanced coaching/analytics only.

### Why this feels premium
- Premium language apps feel like a coach, not a static content list.
- Users see exactly what to do next.

### Implementation idea
- Create `home_summary` DTO:
  - `todayMinutesTarget`
  - `todayXpTarget`
  - `recommendedDrill`
  - `weakSkills[]`
  - `weeklyStats`

---

## 3) Solo Course Detail (Mode Selection)

Current behavior:
- Users choose Vocabulary / Sentences / Review.

### What to improve
1. **Outcome labels on each mode**
   - Add chips: "~6 min", "+40 XP", "Focus: comprehension".
2. **Adaptive "Recommended now" label**
   - Automatically highlight the best mode based on recent mistakes.
3. **Explainable Review mode**
   - Show why review set was generated:
     - Recent errors
     - Low confidence words
     - Long time since last review
4. **Pro-only Coach Session mode**
   - Short adaptive drill + end-of-session weakness report.

### Why this feels premium
- Premium experiences explain decisions and show measurable outcomes.

### Implementation idea
- Add `mode_recommendation_reason` string from backend logic.
- Show reason text directly under selected recommendation.

---

## 4) Circles Page (Social Learning Core)

Current behavior:
- Filters by course/mode/level and lists open circles.

### What to improve
1. **Join confidence indicators**
   - Show estimated latency/quality before joining room.
2. **Premium room categories**
   - Add chips: Ranked / Tournament / Coach-led.
3. **Host trust metadata**
   - Host completion rate, moderation score, reputation badge.
4. **Better zero-results UX**
   - If no room matches filters: one-tap "Create room with these filters".

### Why this feels premium
- Users trust the experience when quality and credibility are visible.
- Competitive formats make subscription feel meaningful.

### Implementation idea
- Add room list fields:
  - `quality_score`
  - `host_completion_rate`
  - `room_type`

---

## 5) Profile Page (Identity + Proof)

Current behavior:
- Social actions, achievements, and moderation tools exist.

### What to improve
1. **Professional identity card**
   - CEFR estimate, strongest skill, weekly consistency score.
2. **Achievement credibility**
   - Timestamped milestones and verified challenge badges.
3. **Premium identity layer**
   - Subscription badge + tooltip that explains active benefits.
4. **Trust/safety clarity**
   - Better block/report dialogs with outcome preview and undo cues.

### Why this feels premium
- Professional apps make progress visible and credible.
- Identity/status matters in social learning ecosystems.

---

## 6) Settings Page (Account Confidence)

Current behavior:
- Rich control panel for preferences and plan selection.

### What to improve
1. **Account center section**
   - Subscription, invoice history, restore purchase, manage plan.
2. **Saved learning presets**
   - Example presets: Exam Mode, Casual Mode, Speaking Sprint.
3. **Support upgrade**
   - In-app support form (category + screenshot/attachment).
4. **Trust footer**
   - Last sync time, app version, service status.

### Why this feels premium
- Professional apps make billing and support transparent.

---

## 7) Social Pages (Friends / Inbox / DM)

### What to improve
1. **Messaging quality baseline**
   - Typing indicators, optional read receipts, translate/copy/pin actions.
2. **Pro messaging suite**
   - Voice note transcription, searchable attachments, larger upload cap.
3. **Safety controls**
   - Per-user permissions, quick mute/report.

### Why this feels premium
- Communication feels modern, safe, and powerful.

---

## 8) Auth + Onboarding

### What to improve
1. **3-screen onboarding story**
   - Learn faster → practice with real people → track mastery.
2. **Faster sign-up**
   - Add SSO where possible; complete profile progressively later.
3. **Credibility signals**
   - Short privacy/security assurances + outcome-oriented proof.

### Why this feels premium
- First impression decides trust and conversion.

---

## 9) Cross-App Polish That Quickly Raises Perception

1. **Consistency system**
   - Standardize loading, empty state, error + retry patterns.
2. **Accessibility quality**
   - Better contrast, text scaling resilience, semantic labels.
3. **Performance confidence**
   - Skeleton loaders, optimistic updates, retry feedback.
4. **Product instrumentation**
   - Track onboarding completion, first lesson, first circle join, trial start, conversion.

---

## 10) Practical 30-Day Execution Plan

### Week 1 (Immediate impact)
- Home Today Plan card.
- Solo mode outcome labels.
- Empty/error/retry consistency pass.

### Week 2 (Social trust)
- Circles quality indicators.
- Host trust metadata.
- Better no-results flow.

### Week 3 (Professional account layer)
- Settings account center.
- In-app support form.
- Profile identity card MVP.

### Week 4 (Premium differentiation)
- Pro Coach Session MVP.
- Premium badge/tooltips.
- Funnel dashboard for conversion insights.

---

## 11) If You Build Only 5 Things First

1. Home Today Plan + weakness recovery.
2. Solo adaptive recommendation + explainable review.
3. Circles quality indicators + premium room types.
4. Settings account center (billing + restore).
5. Profile professional identity card.

---

## 12) Simple Rule for Monetization Quality

- **Free:** core learning must stay useful.
- **Plus:** removes limits and adds convenience.
- **Pro:** gives intelligence, performance, and status advantages.

If users can clearly feel that difference in under 60 seconds, your app will feel both **premium** and **professional**.
