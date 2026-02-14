-- Product polish: latency instrumentation and dm message metadata

alter table public.messages
  add column if not exists read_at timestamptz,
  add column if not exists reactions jsonb not null default '{}'::jsonb;

create table if not exists public.chat_latency_events (
  id bigserial primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  peer_user_id uuid references auth.users(id) on delete set null,
  message_id text,
  metric text not null,
  value_ms integer not null,
  created_at timestamptz not null default now()
);

alter table public.chat_latency_events enable row level security;

drop policy if exists "chat_latency_insert_own" on public.chat_latency_events;
create policy "chat_latency_insert_own"
on public.chat_latency_events
for insert
with check (auth.uid() = user_id);

drop policy if exists "chat_latency_select_own" on public.chat_latency_events;
create policy "chat_latency_select_own"
on public.chat_latency_events
for select
using (auth.uid() = user_id);

create index if not exists idx_chat_latency_user_created
  on public.chat_latency_events (user_id, created_at desc);
