
-- 1. Create concepts table
CREATE TABLE IF NOT EXISTS concepts (
  id bigint PRIMARY KEY,
  created_at timestamp with time zone DEFAULT now()
);

-- 2. Populate concepts table from existing data
INSERT INTO concepts (id)
SELECT DISTINCT concept_id FROM vocabulary WHERE concept_id IS NOT NULL
UNION
SELECT DISTINCT concept_id FROM sentences WHERE concept_id IS NOT NULL
ON CONFLICT (id) DO NOTHING;

-- 3. Add foreign key to vocabulary
ALTER TABLE vocabulary
DROP CONSTRAINT IF EXISTS fk_vocabulary_concepts;

ALTER TABLE vocabulary
ADD CONSTRAINT fk_vocabulary_concepts
FOREIGN KEY (concept_id) REFERENCES concepts(id)
ON DELETE CASCADE;

-- 4. Add foreign key to sentences
ALTER TABLE sentences
DROP CONSTRAINT IF EXISTS fk_sentences_concepts;

ALTER TABLE sentences
ADD CONSTRAINT fk_sentences_concepts
FOREIGN KEY (concept_id) REFERENCES concepts(id)
ON DELETE CASCADE;

-- 5. Add foreign key to user_learned_items
ALTER TABLE user_learned_items
DROP CONSTRAINT IF EXISTS fk_user_learned_items_concepts;

-- Note: We might need to ensure all concept_ids in user_learned_items exist in concepts first
INSERT INTO concepts (id)
SELECT DISTINCT concept_id FROM user_learned_items WHERE concept_id IS NOT NULL
ON CONFLICT (id) DO NOTHING;

ALTER TABLE user_learned_items
ADD CONSTRAINT fk_user_learned_items_concepts
FOREIGN KEY (concept_id) REFERENCES concepts(id)
ON DELETE CASCADE;
