
-- REMEDIATION SCRIPT: SOMA APP ALIGNMENT 2026-02-09
-- Purpose: Add missing columns and ensure correct Primary Keys for app wiring.

-- 1. Profiles: User daily goals
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS daily_goal_minutes integer DEFAULT 30;

-- 2. Messages: Read status for chat threads
ALTER TABLE public.messages ADD COLUMN IF NOT EXISTS is_read boolean DEFAULT false;

-- 3. Circles: Ensure standard locking default
ALTER TABLE public.circles ALTER COLUMN is_locked SET DEFAULT false;

-- 4. Vocabulary/Sentences: Add UUID Primary Keys for better sync/indexing
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='vocabulary' AND column_name='id') THEN
        ALTER TABLE public.vocabulary ADD COLUMN id uuid DEFAULT gen_random_uuid();
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='sentences' AND column_name='id') THEN
        ALTER TABLE public.sentences ADD COLUMN id uuid DEFAULT gen_random_uuid();
    END IF;
END $$;

-- 5. Indexes for common searches (Performance optimization)
CREATE INDEX IF NOT EXISTS idx_vocabulary_lang ON public.vocabulary(lang);
CREATE INDEX IF NOT EXISTS idx_sentences_lang_code ON public.sentences(lang_code);
CREATE INDEX IF NOT EXISTS idx_messages_conversation ON public.messages(sender_id, receiver_id);
