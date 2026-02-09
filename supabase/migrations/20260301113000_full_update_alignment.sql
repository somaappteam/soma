-- Full update alignment migration for current app wiring.
-- Safe to run on existing databases (idempotent guards included).

BEGIN;

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Ensure circles schema matches app usage.
ALTER TABLE public.circles ADD COLUMN IF NOT EXISTS from_lang text;
ALTER TABLE public.circles ADD COLUMN IF NOT EXISTS to_lang text;
ALTER TABLE public.circles ADD COLUMN IF NOT EXISTS mode text;
ALTER TABLE public.circles ADD COLUMN IF NOT EXISTS level text;
ALTER TABLE public.circles ADD COLUMN IF NOT EXISTS max_players int DEFAULT 5;
ALTER TABLE public.circles ADD COLUMN IF NOT EXISTS questions_count int DEFAULT 15;
ALTER TABLE public.circles ADD COLUMN IF NOT EXISTS time_per_q int DEFAULT 10;
ALTER TABLE public.circles ADD COLUMN IF NOT EXISTS allow_spectators boolean DEFAULT true;
ALTER TABLE public.circles ADD COLUMN IF NOT EXISTS questions jsonb DEFAULT '[]'::jsonb;
ALTER TABLE public.circles ADD COLUMN IF NOT EXISTS is_locked boolean DEFAULT false;

-- Ensure participant shape matches app usage.
ALTER TABLE public.circle_participants ADD COLUMN IF NOT EXISTS role text DEFAULT 'player';
ALTER TABLE public.circle_participants ADD COLUMN IF NOT EXISTS is_ready boolean DEFAULT false;
ALTER TABLE public.circle_participants ADD COLUMN IF NOT EXISTS score int DEFAULT 0;
ALTER TABLE public.circle_participants ADD COLUMN IF NOT EXISTS joined_at timestamptz DEFAULT now();

-- Ensure direct messages have read-state.
ALTER TABLE public.messages ADD COLUMN IF NOT EXISTS is_read boolean DEFAULT false;

-- Circle real-time chat + quiz payload tables.
CREATE TABLE IF NOT EXISTS public.chat_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  circle_id uuid NOT NULL REFERENCES public.circles(id) ON DELETE CASCADE,
  sender_id uuid NOT NULL,
  content text NOT NULL,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS public.live_quiz_questions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  circle_id uuid NOT NULL REFERENCES public.circles(id) ON DELETE CASCADE,
  question_index integer NOT NULL,
  concept_id integer,
  prompt text NOT NULL,
  correct_answer text NOT NULL,
  choices jsonb,
  choice_pool jsonb,
  created_at timestamptz DEFAULT now(),
  UNIQUE(circle_id, question_index)
);

CREATE TABLE IF NOT EXISTS public.live_quiz_answers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  circle_id uuid NOT NULL REFERENCES public.circles(id) ON DELETE CASCADE,
  question_id uuid REFERENCES public.live_quiz_questions(id) ON DELETE CASCADE,
  user_id uuid NOT NULL,
  answer text,
  is_correct boolean DEFAULT false,
  answered_at timestamptz DEFAULT now()
);

ALTER TABLE public.chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.live_quiz_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.live_quiz_answers ENABLE ROW LEVEL SECURITY;

DO $$ BEGIN
  CREATE POLICY "Chat messages are readable by authenticated users"
    ON public.chat_messages FOR SELECT TO authenticated USING (true);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY "Users can send chat messages"
    ON public.chat_messages FOR INSERT TO authenticated WITH CHECK (auth.uid() = sender_id);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY "Quiz questions are readable by authenticated users"
    ON public.live_quiz_questions FOR SELECT TO authenticated USING (true);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY "Host can insert quiz questions"
    ON public.live_quiz_questions FOR INSERT TO authenticated WITH CHECK (true);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY "Quiz answers are readable by authenticated users"
    ON public.live_quiz_answers FOR SELECT TO authenticated USING (true);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  CREATE POLICY "Users can insert their own answers"
    ON public.live_quiz_answers FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

GRANT SELECT, INSERT ON public.chat_messages TO authenticated;
GRANT SELECT, INSERT ON public.live_quiz_questions TO authenticated;
GRANT SELECT, INSERT ON public.live_quiz_answers TO authenticated;

-- Keep course language pair normalized and unique.
UPDATE public.courses
SET
  source_lang = nullif(lower(trim(source_lang)), ''),
  target_lang = nullif(lower(trim(target_lang)), '')
WHERE source_lang IS NOT NULL OR target_lang IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS courses_source_target_pair_unique_idx
  ON public.courses ((lower(trim(source_lang))), (lower(trim(target_lang))))
  WHERE source_lang IS NOT NULL AND target_lang IS NOT NULL;

DO $$ BEGIN
  ALTER TABLE public.courses
    ADD CONSTRAINT courses_source_target_different_chk
    CHECK (
      source_lang IS NULL
      OR target_lang IS NULL
      OR lower(trim(source_lang)) <> lower(trim(target_lang))
    );
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- Helpful runtime indexes.
CREATE INDEX IF NOT EXISTS idx_messages_receiver_unread
  ON public.messages (receiver_id, is_read, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_circle_participants_circle_joined
  ON public.circle_participants (circle_id, joined_at);
CREATE INDEX IF NOT EXISTS idx_chat_messages_circle_created
  ON public.chat_messages (circle_id, created_at);

COMMIT;
