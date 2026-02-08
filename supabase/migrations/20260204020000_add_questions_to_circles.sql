-- Add questions column to circles table if it's missing
ALTER TABLE public.circles ADD COLUMN IF NOT EXISTS questions JSONB;
