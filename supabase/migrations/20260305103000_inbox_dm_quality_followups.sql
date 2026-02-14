-- Inbox/DM quality followups: gate RPC + contextual DM reports

create table if not exists public.chat_reports (
  id bigserial primary key,
  reporter_id uuid not null references auth.users(id) on delete cascade,
  reported_user_id uuid not null references auth.users(id) on delete cascade,
  message_id text,
  message_preview text,
  reason text,
  created_at timestamptz not null default now()
);

alter table public.chat_reports enable row level security;

drop policy if exists "chat_reports_insert_own" on public.chat_reports;
create policy "chat_reports_insert_own"
on public.chat_reports
for insert
with check (auth.uid() = reporter_id);

drop policy if exists "chat_reports_select_own" on public.chat_reports;
create policy "chat_reports_select_own"
on public.chat_reports
for select
using (auth.uid() = reporter_id);

create index if not exists idx_chat_reports_reported_created
  on public.chat_reports (reported_user_id, created_at desc);

create or replace function public.get_dm_gate_state(target_user_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  me uuid := auth.uid();
  dm_permission text := 'friendsOnly';
  is_friend boolean := false;
  sent_status text;
  incoming_status text;
  can_chat boolean := false;
  reason text := 'needs_request';
begin
  if me is null then
    return jsonb_build_object('can_chat', false, 'reason', 'not_logged_in');
  end if;

  select coalesce((settings->>'dm_permission'), 'friendsOnly')
    into dm_permission
  from public.profiles
  where id = target_user_id;

  select exists (
    select 1
    from public.friendships
    where status = 'accepted'
      and ((requester_id = me and addressee_id = target_user_id)
           or (requester_id = target_user_id and addressee_id = me))
  ) into is_friend;

  if dm_permission = 'everyone' or is_friend then
    can_chat := true;
    reason := null;
  else
    select status into sent_status
    from public.message_requests
    where requester_id = me and recipient_id = target_user_id;

    select status into incoming_status
    from public.message_requests
    where requester_id = target_user_id and recipient_id = me;

    can_chat := coalesce(sent_status = 'accepted', false)
      or coalesce(incoming_status = 'accepted', false);
  end if;

  return jsonb_build_object(
    'can_chat', can_chat,
    'reason', reason,
    'sent_request_status', sent_status,
    'incoming_request_status', incoming_status
  );
end;
$$;

grant execute on function public.get_dm_gate_state(uuid) to authenticated;
