
-- ==========================================================
-- SOMA APP CONSOLIDATED MANUAL MIGRATION
-- Purpose: Fixes schema connections and establishes the concepts model.
-- ==========================================================

BEGIN;

-- 1. Create Concepts Table (Central hub for vocab/sentences)
CREATE TABLE IF NOT EXISTS concepts (
  id bigint PRIMARY KEY,
  created_at timestamp with time zone DEFAULT now()
);

-- 2. Populate concepts from existing vocabulary and sentences
-- This ensures that any data already in Supabase is linked.
INSERT INTO concepts (id)
SELECT DISTINCT concept_id FROM vocabulary WHERE concept_id IS NOT NULL
UNION
SELECT DISTINCT concept_id FROM sentences WHERE concept_id IS NOT NULL
ON CONFLICT (id) DO NOTHING;

-- 3. Ensure foreign keys for Vocabulary
ALTER TABLE vocabulary 
DROP CONSTRAINT IF EXISTS fk_vocabulary_concepts;

ALTER TABLE vocabulary
ADD CONSTRAINT fk_vocabulary_concepts
FOREIGN KEY (concept_id) REFERENCES concepts(id)
ON DELETE CASCADE;

-- 4. Ensure foreign keys for Sentences
ALTER TABLE sentences 
DROP CONSTRAINT IF EXISTS fk_sentences_concepts;

ALTER TABLE sentences
ADD CONSTRAINT fk_sentences_concepts
FOREIGN KEY (concept_id) REFERENCES concepts(id)
ON DELETE CASCADE;

-- 5. Link User Learned Items (SRS)
INSERT INTO concepts (id)
SELECT DISTINCT concept_id FROM user_learned_items WHERE concept_id IS NOT NULL
ON CONFLICT (id) DO NOTHING;

ALTER TABLE user_learned_items
DROP CONSTRAINT IF EXISTS fk_user_learned_items_concepts;

ALTER TABLE user_learned_items
ADD CONSTRAINT fk_user_learned_items_concepts
FOREIGN KEY (concept_id) REFERENCES concepts(id)
ON DELETE CASCADE;

-- 6. Enable RLS for the new concepts table
ALTER TABLE concepts ENABLE ROW LEVEL SECURITY;

DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'concepts' AND policyname = 'Allow public read access'
  ) THEN
    CREATE POLICY "Allow public read access" ON concepts FOR SELECT USING (true);
  END IF;
END $$;

COMMIT;
