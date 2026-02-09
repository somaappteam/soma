BEGIN;

ALTER TABLE public.circles
ADD COLUMN IF NOT EXISTS is_locked boolean DEFAULT false;

COMMIT;
