-- Fix RLS to allow service role inserts to vocabulary and sentences
-- These are content tables that should be writable by admin/service role

-- Option 1: Add insert policies for service role (bypassing RLS anyway)
-- Option 2: Disable RLS entirely for these static content tables

-- Disable RLS on content tables (they're read-only for app users anyway)
alter table public.vocabulary disable row level security;
alter table public.sentences disable row level security;

-- Grant full access to service role
grant all on table public.vocabulary to service_role;
grant all on table public.sentences to service_role;
