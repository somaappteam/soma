-- Add questions column to circles table
ALTER TABLE public.circles ADD COLUMN IF NOT EXISTS questions JSONB DEFAULT '[]'::jsonb;

-- Verify the column was added
SELECT 
    column_name, 
    data_type, 
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'circles' 
AND column_name = 'questions';
