-- Premium chat foundation: conversations, prefs, summary sync, and retention helper.

create table if not exists public.conversations (
  id bigserial primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  other_user_id uuid not null references auth.users(id) on delete cascade,
  is_pinned boolean not null default false,
  is_muted boolean not null default false,
  is_archived boolean not null default false,
  unread_count integer not null default 0,
  last_message text,
  last_message_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, other_user_id)
);

alter table public.conversations enable row level security;

drop policy if exists "conversations_select_own" on public.conversations;
create policy "conversations_select_own"
on public.conversations
for select
using (auth.uid() = user_id);

drop policy if exists "conversations_update_own" on public.conversations;
create policy "conversations_update_own"
on public.conversations
for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "conversations_insert_own" on public.conversations;
create policy "conversations_insert_own"
on public.conversations
for insert
with check (auth.uid() = user_id);

create or replace function public.sync_conversations_from_message()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.conversations (
    user_id, other_user_id, unread_count, last_message, last_message_at, updated_at
  ) values (
    new.sender_id, new.receiver_id, 0, new.content, new.created_at, now()
  )
  on conflict (user_id, other_user_id)
  do update set
    last_message = excluded.last_message,
    last_message_at = excluded.last_message_at,
    updated_at = now();

  insert into public.conversations (
    user_id, other_user_id, unread_count, last_message, last_message_at, updated_at
  ) values (
    new.receiver_id, new.sender_id, 1, new.content, new.created_at, now()
  )
  on conflict (user_id, other_user_id)
  do update set
    unread_count = conversations.unread_count + 1,
    last_message = excluded.last_message,
    last_message_at = excluded.last_message_at,
    updated_at = now();

  return new;
end;
$$;

drop trigger if exists trg_sync_conversations_from_message on public.messages;
create trigger trg_sync_conversations_from_message
after insert on public.messages
for each row
execute function public.sync_conversations_from_message();

create or replace function public.sync_conversation_read_state()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.is_read = true and old.is_read is distinct from new.is_read then
    update public.conversations
    set unread_count = greatest(0, unread_count - 1),
        updated_at = now()
    where user_id = new.receiver_id
      and other_user_id = new.sender_id;
  end if;
  return new;
end;
$$;

drop trigger if exists trg_sync_conversation_read_state on public.messages;
create trigger trg_sync_conversation_read_state
after update of is_read on public.messages
for each row
execute function public.sync_conversation_read_state();

-- Retention helper for starter budgets.
create or replace function public.cleanup_old_chat_media(retention_days integer default 30)
returns integer
language plpgsql
security definer
set search_path = public
as $$
declare
  deleted_count integer;
begin
  delete from public.messages
  where created_at < now() - make_interval(days => retention_days)
    and (
      content like '{"type":"image"%' or
      content like '{"type":"voice"%' or
      content like '[img]%'
    );

  get diagnostics deleted_count = row_count;
  return deleted_count;
end;
$$;
