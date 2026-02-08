
-- ==========================================================
-- SOMA APP MASTER INFRASTRUCTURE FIX
-- RUN THIS IN SUPABASE SQL EDITOR
-- ==========================================================

BEGIN;

-- 1. USER STATS (Missing in last error)
CREATE TABLE IF NOT EXISTS public.user_stats (
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  total_wins int DEFAULT 0,
  streak_days int DEFAULT 0,
  longest_streak int DEFAULT 0,
  last_active_date date,
  total_quizzes int DEFAULT 0,
  total_correct int DEFAULT 0,
  total_questions int DEFAULT 0,
  perfect_quizzes int DEFAULT 0,
  circles_joined int DEFAULT 0,
  updated_at timestamp with time zone DEFAULT now() NOT NULL
);

-- 2. CIRCLES SYSTEM
CREATE TABLE IF NOT EXISTS public.circles (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  host_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
  name text NOT NULL,
  from_lang text NOT NULL,
  to_lang text NOT NULL,
  mode text NOT NULL,
  level text NOT NULL,
  max_players int DEFAULT 5,
  questions_count int DEFAULT 0,
  time_per_q int DEFAULT 10,
  allow_spectators boolean DEFAULT true,
  status text DEFAULT 'lobby',
  questions jsonb DEFAULT '[]'::jsonb,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS public.circle_participants (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  circle_id uuid REFERENCES circles(id) ON DELETE CASCADE,
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
  role text DEFAULT 'player',
  is_ready boolean DEFAULT false,
  score int DEFAULT 0,
  joined_at timestamp with time zone DEFAULT now() NOT NULL,
  UNIQUE(circle_id, user_id)
);

-- 3. ENCEPTS HUB
CREATE TABLE IF NOT EXISTS public.concepts (
  id bigint PRIMARY KEY,
  created_at timestamp with time zone DEFAULT now()
);

-- 4. SECURITY (RLS)
ALTER TABLE public.user_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.circles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.circle_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.concepts ENABLE ROW LEVEL SECURITY;

-- 5. POLICIES (Safe re-run)
DO $$ 
BEGIN
  -- user_stats
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'user_stats' AND policyname = 'Allow self read') THEN
    CREATE POLICY "Allow self read" ON public.user_stats FOR SELECT USING (auth.uid() = user_id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'user_stats' AND policyname = 'Allow self insert') THEN
    CREATE POLICY "Allow self insert" ON public.user_stats FOR INSERT WITH CHECK (auth.uid() = user_id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'user_stats' AND policyname = 'Allow self update') THEN
    CREATE POLICY "Allow self update" ON public.user_stats FOR UPDATE USING (auth.uid() = user_id);
  END IF;

  -- circles
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'circles' AND policyname = 'Public read') THEN
    CREATE POLICY "Public read" ON public.circles FOR SELECT USING (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'circles' AND policyname = 'Authenticated insert') THEN
    CREATE POLICY "Authenticated insert" ON public.circles FOR INSERT WITH CHECK (auth.role() = 'authenticated');
  END IF;

  -- circle_participants
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'circle_participants' AND policyname = 'Public read') THEN
    CREATE POLICY "Public read" ON public.circle_participants FOR SELECT USING (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'circle_participants' AND policyname = 'Authenticated self insert') THEN
    CREATE POLICY "Authenticated self insert" ON public.circle_participants FOR INSERT WITH CHECK (auth.role() = 'authenticated');
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'circle_participants' AND policyname = 'Authenticated self update') THEN
    CREATE POLICY "Authenticated self update" ON public.circle_participants FOR UPDATE USING (auth.uid() = user_id);
  END IF;

  -- concepts
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'concepts' AND policyname = 'Public read') THEN
    CREATE POLICY "Public read" ON public.concepts FOR SELECT USING (true);
  END IF;
END $$;

COMMIT;

-- FORCE SCHEMA RELOAD
NOTIFY pgrst, 'reload schema';
