# Premium + Dynamic Messaging Backlog (Inbox & DM)

This backlog focuses on making messaging feel alive, premium, and more professional than typical chat apps while staying shippable in phases.

## North-star experience goals

- **Feels alive in real time:** rich presence, typing context, live states, and meaningful activity indicators.
- **Feels premium:** polished transitions, powerful controls, clarity around trust/privacy, and high reliability.
- **Feels professional:** fast triage, zero-clutter workflows, and collaboration-friendly message organization.

## Priority roadmap

## P0 — High impact, low-to-medium effort (ship first)

1. **Smart inbox sections**
   - Add sections: `Priority`, `Unread`, `Pinned`, `Recent`.
   - Use behavior signals (unread count, mentions, recent replies, pin state) for ranking.
   - Keep existing sort as an override, but default to smart ranking.

2. **Presence quality upgrade**
   - Add states beyond online/offline: `active now`, `last seen`, `in call`, `do not disturb`.
   - Show confidence-safe timestamps like “active 2m ago”.
   - Add graceful privacy fallback when users disable visibility.

3. **Rich typing + recording indicators**
   - Typing indicator with animated dots and context labels:
     - “typing…”, “recording voice…”, “uploading image…”.
   - Display as inline status under chat title and in inbox preview rows.

4. **Message actions bar (pro workflow)**
   - Add quick actions for each message: reply, copy, pin, forward, translate, save.
   - Keep long-press sheet, but surface most-used actions directly.

5. **Conversation health cards**
   - Mini cards in DM for: media upload failures, connection quality, pending sync, message retry.
   - Include one-tap recovery actions (`Retry`, `Re-send`, `Report issue`).

## P1 — Premium differentiation (core)

6. **AI smart compose + reply tones**
   - Suggested replies with tone presets: `friendly`, `professional`, `concise`, `supportive`.
   - Optional rewrite button before sending.
   - Always user-controlled with clear “generated” badge.

7. **Dynamic theme modes in DM**
   - Per-conversation themes: `Calm`, `Focus`, `Neon`, `Minimal`.
   - Context-aware visual accents (subtle gradients, not distracting).
   - Auto mode by time of day (optional).

8. **Voice notes 2.0**
   - Waveform preview before send.
   - Playback speed and transcript snippet.
   - Noise reduction toggle for premium plans.

9. **Professional search**
   - Unified search facets: `photos`, `files`, `links`, `mentions`, `pinned`, `date range`.
   - Saved searches for repeated workflows.
   - Search highlights with jump-to-message timeline markers.

10. **Message scheduling + reminders**
    - Send later by timezone.
    - Follow-up reminders if no response in X time.
    - Optional smart nudges for unanswered priority threads.

## P2 — Advanced, “beyond mainstream apps”

11. **Threading inside DM**
    - Lightweight sub-threads for focused topic replies.
    - Collapse/expand thread view to reduce chat noise.

12. **Inbox command palette**
    - Keyboard-first command launcher (`⌘K` / `Ctrl+K`) for power users.
    - Actions: archive, mute, pin, jump to chat, start call, open media.

13. **Shared workspace primitives**
    - Pinned resources panel (files/links/notes/tasks) per conversation.
    - Hand-off notes for team/circle contexts.

14. **Trust center in messaging**
    - Per-chat trust score: account age, verification badge, report history signal.
    - Safe-open mode for links/files from unknown contacts.

15. **Quality-of-service overlays**
    - Live network badge (`Excellent`, `Unstable`, `Offline`), queue visibility, and delivery trace.
    - Transparent, premium-grade reliability communication.

## UX quality guardrails

- Keep animations subtle and under 250ms where possible.
- Avoid feature overload in main UI; move advanced tools into expandable sections.
- Maintain accessibility parity (large text, screen reader labels, contrast, touch target sizes).
- Ensure every premium feature has an obvious free-plan fallback experience.

## Metrics to prove “alive + premium” impact

- `time_to_first_reply`, `threads_opened_per_day`, `unread_resolution_rate`.
- `message_retry_rate`, `media_send_failure_rate`, `typing_to_send_conversion`.
- `feature_adoption`: pin/search/schedule/voice transcript usage.
- `retention_d7/d30` for users who use 2+ advanced messaging features.

## Suggested delivery plan

- **Sprint 1:** Smart inbox sections, richer presence states, typing/recording indicators.
- **Sprint 2:** Pro message action bar, conversation health cards, search facets.
- **Sprint 3:** AI smart compose, DM dynamic themes, voice notes 2.0.
- **Sprint 4:** Scheduling/reminders, command palette, trust center + QoS overlays.
