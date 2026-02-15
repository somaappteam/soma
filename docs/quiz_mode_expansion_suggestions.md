# Quiz Mode Expansion Suggestions

This revision turns the original brainstorm into a more implementation-ready plan for the two quiz modes.

## Design goals

- Increase **active recall** (not only recognition).
- Improve **real-world transfer** (listening, production, context).
- Keep gameplay compatible with both **Solo** and **Circles** sessions.
- Feed stronger signals into adaptive selection (accuracy, speed, confidence, error type).

---

## Vocabulary mode: suggested new quiz types

| Quiz type | Learner action | Why it helps | Build complexity | Solo | Circles |
|---|---|---|---|---:|---:|
| Reverse Recall (L1 -> L2) | See source meaning, choose/enter target word | Prevents one-way memorization from target->source only | Low | ✅ | ✅ |
| Article + Noun Pairing | Match article with noun (or pick correct pair) | Strengthens grammatical gender accuracy | Low | ✅ | ✅ |
| Audio-to-Word Match | Hear TTS, choose matching written word | Adds listening discrimination to vocab practice | Low | ✅ | ✅ |
| Spelling Sprint (Typed) | Type the target word from a prompt | High active recall and orthography training | Medium | ✅ | ⚠️* |
| Near-Miss Distractors | Choose between very similar forms | Improves precision and attention to detail | Medium | ✅ | ✅ |
| Synonym / Variant Accept | Multiple valid answers accepted | Reflects real language variation and flexibility | Medium | ✅ | ✅ |
| Word Family Builder | Pick derived form (verb/noun/adjective) | Builds morphology and lexical network depth | Medium | ✅ | ✅ |
| Confidence Check | Answer + confidence rating | Improves personalization and SRS prioritization | Low | ✅ | ✅ |

\* For Circles, typed answers need anti-cheat/synchronization rules; can start as multiple choice first.

### Vocabulary mode implementation notes

1. **Phase V1 (fast shipping)**
   - Reverse Recall
   - Audio-to-Word Match
   - Article + Noun Pairing
   - Confidence Check

2. **Phase V2 (higher impact)**
   - Spelling Sprint
   - Near-Miss Distractors
   - Word Family Builder

3. **Phase V3 (content sophistication)**
   - Synonym / Variant Accept with curated accepted-answer sets.

---

## Sentences mode: suggested new quiz types

| Quiz type | Learner action | Why it helps | Build complexity | Solo | Circles |
|---|---|---|---|---:|---:|
| Sentence Reordering | Arrange shuffled tokens into valid sentence | Direct syntax and word-order training | Medium | ✅ | ✅ |
| Dual Blank Fill | Fill two blanks in one sentence | Trains agreement + context dependencies | Medium | ✅ | ✅ |
| Error Detection & Fix | Identify and correct one mistake | Production-oriented grammar awareness | Medium | ✅ | ⚠️* |
| Context-Aware Translation Choice | Pick best translation by tone/context | Moves beyond literal equivalence | Low | ✅ | ✅ |
| Dialogue Continuation | Select best next utterance | Builds pragmatic conversational ability | Low | ✅ | ✅ |
| Listening Cloze | Hear audio, fill missing words | Blends listening + recall under context | Medium | ✅ | ✅ |
| Paraphrase Equivalence | Decide if two sentences mean same thing | Strengthens semantic understanding | Low | ✅ | ✅ |
| Register Switch | Convert/select formal vs casual variant | Practical sociolinguistic competence | Medium | ✅ | ✅ |

\* In Circles, free-form corrections should start with constrained answer sets or rubric-based scoring.

### Sentences mode implementation notes

1. **Phase S1 (quick wins)**
   - Context-Aware Translation Choice
   - Dialogue Continuation
   - Paraphrase Equivalence

2. **Phase S2 (core learning gains)**
   - Sentence Reordering
   - Dual Blank Fill
   - Listening Cloze

3. **Phase S3 (advanced production)**
   - Error Detection & Fix
   - Register Switch

---

## Scoring and analytics updates (recommended)

Track these for each new quiz type:

- **First-try correctness** (primary mastery signal)
- **Response latency** (fluency signal)
- **Hints/reveals used** (support dependence)
- **Confidence vs correctness gap** (metacognition quality)
- **Error taxonomy** (spelling, morphology, agreement, word order, lexical choice, register)

Use these signals to:

- Increase frequency of weak skill areas in subsequent sessions.
- Prioritize low-confidence correct items for short-term review.
- Route learners to targeted micro-drills (e.g., gender or word-order specific drills).

---

## Suggested content/data prerequisites

To avoid brittle quiz generation, prepare:

- **Vocabulary metadata**: article, lemma, POS, acceptable variants/synonyms, difficulty.
- **Sentence metadata**: register, intent (question/request/statement), grammar tags, distractor quality tier.
- **Audio coverage**: reliable TTS fallback + optional human audio for high-frequency items.
- **Distractor banks**: near-miss pairs and pedagogically meaningful wrong options.

---

## Recommended rollout order (combined)

1. Reverse Recall (V1)
2. Context-Aware Translation Choice (S1)
3. Audio-to-Word Match (V1)
4. Dialogue Continuation (S1)
5. Sentence Reordering (S2)
6. Spelling Sprint (V2)
7. Dual Blank Fill (S2)
8. Error Detection & Fix (S3)

This sequence balances speed-to-release, learning impact, and implementation risk.
