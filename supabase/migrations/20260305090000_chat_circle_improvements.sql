-- DM typing + message requests and circle live chat moderation/reactions

alter table public.chat_messages
  add column if not exists reactions jsonb not null default '{}'::jsonb;

alter table public.circles
  add column if not exists chat_muted_user_ids uuid[] not null default '{}',
  add column if not exists chat_slow_mode_seconds integer not null default 0,
  add column if not exists chat_highlight_text text;

create table if not exists public.dm_typing (
  user_id uuid not null references auth.users(id) on delete cascade,
  other_user_id uuid not null references auth.users(id) on delete cascade,
  is_typing boolean not null default false,
  updated_at timestamptz not null default now(),
  primary key (user_id, other_user_id)
);

alter table public.dm_typing enable row level security;

drop policy if exists "dm_typing_select_pair" on public.dm_typing;
create policy "dm_typing_select_pair"
on public.dm_typing
for select
using (auth.uid() = user_id or auth.uid() = other_user_id);

drop policy if exists "dm_typing_upsert_own" on public.dm_typing;
create policy "dm_typing_upsert_own"
on public.dm_typing
for all
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create table if not exists public.message_requests (
  id bigserial primary key,
  requester_id uuid not null references auth.users(id) on delete cascade,
  recipient_id uuid not null references auth.users(id) on delete cascade,
  status text not null default 'pending' check (status in ('pending','accepted','declined')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (requester_id, recipient_id)
);

alter table public.message_requests enable row level security;

drop policy if exists "message_requests_select_pair" on public.message_requests;
create policy "message_requests_select_pair"
on public.message_requests
for select
using (auth.uid() = requester_id or auth.uid() = recipient_id);

drop policy if exists "message_requests_insert_requester" on public.message_requests;
create policy "message_requests_insert_requester"
on public.message_requests
for insert
with check (auth.uid() = requester_id);

drop policy if exists "message_requests_update_recipient_or_requester" on public.message_requests;
create policy "message_requests_update_recipient_or_requester"
on public.message_requests
for update
using (auth.uid() = requester_id or auth.uid() = recipient_id)
with check (auth.uid() = requester_id or auth.uid() = recipient_id);

do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'dm_typing'
  ) then
    alter publication supabase_realtime add table public.dm_typing;
  end if;
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'message_requests'
  ) then
    alter publication supabase_realtime add table public.message_requests;
  end if;
end $$;
