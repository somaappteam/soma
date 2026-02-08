
-- ============================================================================
-- SOMA APPLICATION - TOTAL APP MIGRATION & RE-WIRING
-- ============================================================================
-- Description: This script sets up the entire database schema AND ensures
-- all tables are properly connected (Foreign Keys) even if data already exists.
-- ============================================================================

BEGIN;

-- ----------------------------------------------------------------------------
-- 1. EXTENSIONS & SETUP
-- ----------------------------------------------------------------------------
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ----------------------------------------------------------------------------
-- 2. CORE IDENTITY (Profiles & Auth Trigger)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.profiles (
  id uuid REFERENCES auth.users ON DELETE CASCADE NOT NULL PRIMARY KEY,
  username text UNIQUE,
  display_name text,
  bio text,
  location text,
  avatar_url text,
  daily_goal_minutes int DEFAULT 10,
  total_xp int DEFAULT 0,
  settings jsonb DEFAULT '{}'::jsonb,
  updated_at timestamp with time zone DEFAULT now(),
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

-- Ensure all columns exist for migration/update
DO $$ BEGIN
  ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS bio text;
  ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS location text;
  ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS settings jsonb DEFAULT '{}'::jsonb;
EXCEPTION WHEN OTHERS THEN NULL; END $$;

-- Auth Trigger Function
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, username, display_name, avatar_url)
  VALUES (
    new.id,
    new.raw_user_meta_data->>'username',
    new.raw_user_meta_data->>'display_name',
    new.raw_user_meta_data->>'avatar_url'
  ) ON CONFLICT (id) DO NOTHING;
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger Setup
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- ----------------------------------------------------------------------------
-- 3. CONTENT INFRASTRUCTURE (The "Wiring" Central)
-- ----------------------------------------------------------------------------

-- Concepts Hub (The source of truth for IDs)
CREATE TABLE IF NOT EXISTS public.concepts (
  id bigint PRIMARY KEY,
  created_at timestamp with time zone DEFAULT now()
);

-- 3.1. VOCABULARY
CREATE TABLE IF NOT EXISTS public.vocabulary (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  concept_id bigint, -- Will link below
  lang text NOT NULL,
  word text NOT NULL,
  article text,
  gender text,
  romanization text,
  pinyin text,
  transliteration text,
  level text,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

-- 3.2. SENTENCES
CREATE TABLE IF NOT EXISTS public.sentences (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  concept_id bigint, -- Will link below
  lang_code text NOT NULL,
  lang_name text,
  sentence text NOT NULL,
  romanization text,
  pinyin text,
  transliteration text,
  level text,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

-- ----------------------------------------------------------------------------
-- 4. THE WIRING (Connecting existing CSV data to Concepts)
-- ----------------------------------------------------------------------------

-- A. Auto-populate Concepts from any existing data in vocab/sentences
INSERT INTO public.concepts (id)
SELECT DISTINCT concept_id FROM public.vocabulary WHERE concept_id IS NOT NULL
UNION
SELECT DISTINCT concept_id FROM public.sentences WHERE concept_id IS NOT NULL
ON CONFLICT (id) DO NOTHING;

-- B. Force Foreign Keys (Cleaning up any "orphan" data first)
DO $$ 
BEGIN
    -- Linking Vocabulary
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'fk_vocab_concepts') THEN
        -- Delete rows that refer to non-existent concepts to avoid FK errors during wiring
        DELETE FROM public.vocabulary WHERE concept_id NOT IN (SELECT id FROM public.concepts);
        ALTER TABLE public.vocabulary ADD CONSTRAINT fk_vocab_concepts FOREIGN KEY (concept_id) REFERENCES public.concepts(id) ON DELETE CASCADE;
    END IF;

    -- Linking Sentences
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'fk_sentences_concepts') THEN
        DELETE FROM public.sentences WHERE concept_id NOT IN (SELECT id FROM public.concepts);
        ALTER TABLE public.sentences ADD CONSTRAINT fk_sentences_concepts FOREIGN KEY (concept_id) REFERENCES public.concepts(id) ON DELETE CASCADE;
    END IF;

    -- Add uniques for upsert support
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'vocab_concept_lang_unique') THEN
        ALTER TABLE public.vocabulary ADD CONSTRAINT vocab_concept_lang_unique UNIQUE(concept_id, lang);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'sentences_concept_lang_unique') THEN
        ALTER TABLE public.sentences ADD CONSTRAINT sentences_concept_lang_unique UNIQUE(concept_id, lang_code);
    END IF;
END $$;

-- ----------------------------------------------------------------------------
-- 5. PROGRESS & SRS
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.courses (
  id text PRIMARY KEY,
  title text NOT NULL,
  subtitle text,
  source_lang text NOT NULL,
  target_lang text NOT NULL,
  icon_url text,
  xp_reward int DEFAULT 10,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.user_courses (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  course_id text REFERENCES public.courses(id) ON DELETE CASCADE NOT NULL,
  progress_xp int DEFAULT 0,
  last_accessed timestamp with time zone DEFAULT now(),
  UNIQUE(user_id, course_id)
);

CREATE TABLE IF NOT EXISTS public.user_learned_items (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  course_id text REFERENCES public.courses(id) ON DELETE CASCADE NOT NULL,
  concept_id bigint REFERENCES public.concepts(id) ON DELETE CASCADE NOT NULL,
  interval_days int DEFAULT 1,
  due_at timestamp with time zone DEFAULT now() + interval '1 day' NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  UNIQUE(user_id, course_id, concept_id)
);

-- ----------------------------------------------------------------------------
-- 6. SYSTEM, SOCIAL & MULTIPLAYER
-- ----------------------------------------------------------------------------
-- (Ensuring these also use correct foreign keys)

CREATE TABLE IF NOT EXISTS public.circles (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  host_id uuid REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  name text NOT NULL,
  status text DEFAULT 'lobby',
  questions jsonb DEFAULT '[]'::jsonb,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.circle_participants (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  circle_id uuid REFERENCES public.circles(id) ON DELETE CASCADE NOT NULL,
  user_id uuid REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
  UNIQUE(circle_id, user_id)
);

CREATE TABLE IF NOT EXISTS public.user_stats (
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  total_xp int DEFAULT 0,
  circles_joined int DEFAULT 0,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

-- ----------------------------------------------------------------------------
-- 7. SECURITY & ACCESS
-- ----------------------------------------------------------------------------
DO $$ 
DECLARE
    t text;
BEGIN
    FOR t IN SELECT tablename FROM pg_tables WHERE schemaname = 'public' LOOP
        EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', t);
    END LOOP;
END $$;

-- Policies (Safe re-run)
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Public read concepts') THEN
        CREATE POLICY "Public read concepts" ON public.concepts FOR SELECT USING (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Public read vocab') THEN
        CREATE POLICY "Public read vocab" ON public.vocabulary FOR SELECT USING (true);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'Public read sentences') THEN
        CREATE POLICY "Public read sentences" ON public.sentences FOR SELECT USING (true);
    END IF;
END $$;

COMMIT;

-- FORCE SCHEMA RELOAD
NOTIFY pgrst, 'reload schema';
