
-- ==========================================================
-- SOMA APP INFRASTRUCTURE FIX
-- Purpose: Creates missing user_stats and related tables.
-- ==========================================================

BEGIN;

-- 1. Create user_stats table
CREATE TABLE IF NOT EXISTS user_stats (
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

ALTER TABLE user_stats ENABLE ROW LEVEL SECURITY;

DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'user_stats' AND policyname = 'Users can read own stats') THEN
    CREATE POLICY "Users can read own stats" ON user_stats FOR SELECT USING (auth.uid() = user_id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'user_stats' AND policyname = 'Users can insert own stats') THEN
    CREATE POLICY "Users can insert own stats" ON user_stats FOR INSERT WITH CHECK (auth.uid() = user_id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'user_stats' AND policyname = 'Users can update own stats') THEN
    CREATE POLICY "Users can update own stats" ON user_stats FOR UPDATE USING (auth.uid() = user_id);
  END IF;
END $$;

-- 2. Ensure Circles system exists (Safety check)
CREATE TABLE IF NOT EXISTS circles (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  host_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
  name text NOT NULL,
  from_lang text NOT NULL,
  to_lang text NOT NULL,
  mode text NOT NULL, -- Vocabulary | Sentences
  level text NOT NULL,
  max_players int DEFAULT 5,
  questions_count int DEFAULT 0,
  time_per_q int DEFAULT 10,
  allow_spectators boolean DEFAULT true,
  status text DEFAULT 'lobby', -- lobby | active | ended
  questions jsonb DEFAULT '[]'::jsonb,
  created_at timestamp with time zone DEFAULT now() NOT NULL
);

ALTER TABLE circles ENABLE ROW LEVEL SECURITY;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'circles' AND policyname = 'Allow public read access') THEN
    CREATE POLICY "Allow public read access" ON circles FOR SELECT USING (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'circles' AND policyname = 'Allow authenticated insert') THEN
    CREATE POLICY "Allow authenticated insert" ON circles FOR INSERT WITH CHECK (auth.role() = 'authenticated');
  END IF;
END $$;

CREATE TABLE IF NOT EXISTS circle_participants (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  circle_id uuid REFERENCES circles(id) ON DELETE CASCADE,
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
  role text DEFAULT 'player', -- host | player | spectator
  is_ready boolean DEFAULT false,
  score int DEFAULT 0,
  joined_at timestamp with time zone DEFAULT now() NOT NULL,
  UNIQUE(circle_id, user_id)
);

ALTER TABLE circle_participants ENABLE ROW LEVEL SECURITY;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'circle_participants' AND policyname = 'Allow public read access') THEN
    CREATE POLICY "Allow public read access" ON circle_participants FOR SELECT USING (true);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'circle_participants' AND policyname = 'Allow authenticated update') THEN
    CREATE POLICY "Allow authenticated update" ON circle_participants FOR UPDATE USING (auth.uid() = user_id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'circle_participants' AND policyname = 'Allow authenticated insert') THEN
    CREATE POLICY "Allow authenticated insert" ON circle_participants FOR INSERT WITH CHECK (auth.role() = 'authenticated');
  END IF;
END $$;

COMMIT;

-- Refresh PostgREST cache (Dashboard usually does this, but good to have)
NOTIFY pgrst, 'reload schema';
