-- Backfill RLS policies for chat/analytics/privacy tables that are used by the app
-- but were not covered in earlier migrations.

-- conversations
alter table if exists public.conversations enable row level security;
do $$
begin
  if to_regclass('public.conversations') is not null then
    if not exists (
      select 1 from pg_policies where schemaname='public' and tablename='conversations' and policyname='conversations_select_own'
    ) then
      create policy conversations_select_own on public.conversations
        for select using (auth.uid() = user_id);
    end if;

    if not exists (
      select 1 from pg_policies where schemaname='public' and tablename='conversations' and policyname='conversations_insert_own'
    ) then
      create policy conversations_insert_own on public.conversations
        for insert with check (auth.uid() = user_id);
    end if;

    if not exists (
      select 1 from pg_policies where schemaname='public' and tablename='conversations' and policyname='conversations_update_own'
    ) then
      create policy conversations_update_own on public.conversations
        for update using (auth.uid() = user_id)
        with check (auth.uid() = user_id);
    end if;

    if not exists (
      select 1 from pg_policies where schemaname='public' and tablename='conversations' and policyname='conversations_delete_own'
    ) then
      create policy conversations_delete_own on public.conversations
        for delete using (auth.uid() = user_id);
    end if;
  end if;
end
$$;

-- dm_typing
alter table if exists public.dm_typing enable row level security;
do $$
begin
  if to_regclass('public.dm_typing') is not null then
    if not exists (
      select 1 from pg_policies where schemaname='public' and tablename='dm_typing' and policyname='dm_typing_select_participants'
    ) then
      create policy dm_typing_select_participants on public.dm_typing
        for select using (auth.uid() = user_id or auth.uid() = other_user_id);
    end if;

    if not exists (
      select 1 from pg_policies where schemaname='public' and tablename='dm_typing' and policyname='dm_typing_insert_sender'
    ) then
      create policy dm_typing_insert_sender on public.dm_typing
        for insert with check (auth.uid() = user_id);
    end if;

    if not exists (
      select 1 from pg_policies where schemaname='public' and tablename='dm_typing' and policyname='dm_typing_update_sender'
    ) then
      create policy dm_typing_update_sender on public.dm_typing
        for update using (auth.uid() = user_id)
        with check (auth.uid() = user_id);
    end if;

    if not exists (
      select 1 from pg_policies where schemaname='public' and tablename='dm_typing' and policyname='dm_typing_delete_sender'
    ) then
      create policy dm_typing_delete_sender on public.dm_typing
        for delete using (auth.uid() = user_id);
    end if;
  end if;
end
$$;

-- message_requests
alter table if exists public.message_requests enable row level security;
do $$
begin
  if to_regclass('public.message_requests') is not null then
    if not exists (
      select 1 from pg_policies where schemaname='public' and tablename='message_requests' and policyname='message_requests_select_participants'
    ) then
      create policy message_requests_select_participants on public.message_requests
        for select using (auth.uid() = requester_id or auth.uid() = recipient_id);
    end if;

    if not exists (
      select 1 from pg_policies where schemaname='public' and tablename='message_requests' and policyname='message_requests_insert_requester'
    ) then
      create policy message_requests_insert_requester on public.message_requests
        for insert with check (auth.uid() = requester_id);
    end if;

    if not exists (
      select 1 from pg_policies where schemaname='public' and tablename='message_requests' and policyname='message_requests_update_participants'
    ) then
      create policy message_requests_update_participants on public.message_requests
        for update using (auth.uid() = requester_id or auth.uid() = recipient_id)
        with check (auth.uid() = requester_id or auth.uid() = recipient_id);
    end if;

    if not exists (
      select 1 from pg_policies where schemaname='public' and tablename='message_requests' and policyname='message_requests_delete_participants'
    ) then
      create policy message_requests_delete_participants on public.message_requests
        for delete using (auth.uid() = requester_id or auth.uid() = recipient_id);
    end if;
  end if;
end
$$;

-- chat_reports
alter table if exists public.chat_reports enable row level security;
do $$
begin
  if to_regclass('public.chat_reports') is not null then
    if not exists (
      select 1 from pg_policies where schemaname='public' and tablename='chat_reports' and policyname='chat_reports_insert_reporter'
    ) then
      create policy chat_reports_insert_reporter on public.chat_reports
        for insert with check (auth.uid() = reporter_id);
    end if;

    if not exists (
      select 1 from pg_policies where schemaname='public' and tablename='chat_reports' and policyname='chat_reports_select_own'
    ) then
      create policy chat_reports_select_own on public.chat_reports
        for select using (auth.uid() = reporter_id);
    end if;
  end if;
end
$$;

-- exchange_events
alter table if exists public.exchange_events enable row level security;
do $$
begin
  if to_regclass('public.exchange_events') is not null then
    if not exists (
      select 1 from pg_policies where schemaname='public' and tablename='exchange_events' and policyname='exchange_events_insert_own'
    ) then
      create policy exchange_events_insert_own on public.exchange_events
        for insert with check (user_id is null or auth.uid() = user_id);
    end if;

    if not exists (
      select 1 from pg_policies where schemaname='public' and tablename='exchange_events' and policyname='exchange_events_select_own'
    ) then
      create policy exchange_events_select_own on public.exchange_events
        for select using (auth.uid() = user_id);
    end if;
  end if;
end
$$;

-- chat_latency_events
alter table if exists public.chat_latency_events enable row level security;
do $$
begin
  if to_regclass('public.chat_latency_events') is not null then
    if not exists (
      select 1 from pg_policies where schemaname='public' and tablename='chat_latency_events' and policyname='chat_latency_events_insert_own'
    ) then
      create policy chat_latency_events_insert_own on public.chat_latency_events
        for insert with check (auth.uid() = user_id);
    end if;

    if not exists (
      select 1 from pg_policies where schemaname='public' and tablename='chat_latency_events' and policyname='chat_latency_events_select_own'
    ) then
      create policy chat_latency_events_select_own on public.chat_latency_events
        for select using (auth.uid() = user_id);
    end if;
  end if;
end
$$;

-- app_events
alter table if exists public.app_events enable row level security;
do $$
begin
  if to_regclass('public.app_events') is not null then
    if not exists (
      select 1 from pg_policies where schemaname='public' and tablename='app_events' and policyname='app_events_insert_own_or_anon'
    ) then
      create policy app_events_insert_own_or_anon on public.app_events
        for insert with check (user_id is null or auth.uid() = user_id);
    end if;

    if not exists (
      select 1 from pg_policies where schemaname='public' and tablename='app_events' and policyname='app_events_select_own'
    ) then
      create policy app_events_select_own on public.app_events
        for select using (auth.uid() = user_id);
    end if;
  end if;
end
$$;

-- circle chat messages
alter table if exists public.chat_messages enable row level security;
do $$
begin
  if to_regclass('public.chat_messages') is not null then
    if not exists (
      select 1 from pg_policies where schemaname='public' and tablename='chat_messages' and policyname='chat_messages_select_circle_participants'
    ) then
      create policy chat_messages_select_circle_participants on public.chat_messages
        for select using (
          exists (
            select 1
            from public.circle_participants cp
            where cp.circle_id = chat_messages.circle_id
              and cp.user_id = auth.uid()
          )
        );
    end if;

    if not exists (
      select 1 from pg_policies where schemaname='public' and tablename='chat_messages' and policyname='chat_messages_insert_sender_participant'
    ) then
      create policy chat_messages_insert_sender_participant on public.chat_messages
        for insert with check (
          auth.uid() = sender_id
          and exists (
            select 1
            from public.circle_participants cp
            where cp.circle_id = chat_messages.circle_id
              and cp.user_id = auth.uid()
          )
        );
    end if;

    if not exists (
      select 1 from pg_policies where schemaname='public' and tablename='chat_messages' and policyname='chat_messages_update_circle_participants'
    ) then
      create policy chat_messages_update_circle_participants on public.chat_messages
        for update using (
          exists (
            select 1
            from public.circle_participants cp
            where cp.circle_id = chat_messages.circle_id
              and cp.user_id = auth.uid()
          )
        )
        with check (
          exists (
            select 1
            from public.circle_participants cp
            where cp.circle_id = chat_messages.circle_id
              and cp.user_id = auth.uid()
          )
        );
    end if;

    if not exists (
      select 1 from pg_policies where schemaname='public' and tablename='chat_messages' and policyname='chat_messages_delete_sender_or_host'
    ) then
      create policy chat_messages_delete_sender_or_host on public.chat_messages
        for delete using (
          auth.uid() = sender_id
          or exists (
            select 1
            from public.circles c
            where c.id = chat_messages.circle_id
              and c.host_user_id = auth.uid()
          )
        );
    end if;
  end if;
end
$$;

-- Storage bucket object policies used by app uploads.
do $$
begin
  if exists (select 1 from pg_class c join pg_namespace n on n.oid=c.relnamespace where n.nspname='storage' and c.relname='objects') then
    if not exists (
      select 1 from pg_policies where schemaname='storage' and tablename='objects' and policyname='avatars_insert_own_folder'
    ) then
      create policy avatars_insert_own_folder on storage.objects
        for insert to authenticated
        with check (bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text);
    end if;

    if not exists (
      select 1 from pg_policies where schemaname='storage' and tablename='objects' and policyname='avatars_update_own_folder'
    ) then
      create policy avatars_update_own_folder on storage.objects
        for update to authenticated
        using (bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text)
        with check (bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text);
    end if;

    if not exists (
      select 1 from pg_policies where schemaname='storage' and tablename='objects' and policyname='avatars_delete_own_folder'
    ) then
      create policy avatars_delete_own_folder on storage.objects
        for delete to authenticated
        using (bucket_id = 'avatars' and (storage.foldername(name))[1] = auth.uid()::text);
    end if;

    if not exists (
      select 1 from pg_policies where schemaname='storage' and tablename='objects' and policyname='avatars_select_own_or_public'
    ) then
      create policy avatars_select_own_or_public on storage.objects
        for select to authenticated
        using (bucket_id = 'avatars');
    end if;

    if not exists (
      select 1 from pg_policies where schemaname='storage' and tablename='objects' and policyname='chat_assets_insert_own_folder'
    ) then
      create policy chat_assets_insert_own_folder on storage.objects
        for insert to authenticated
        with check (bucket_id = 'chat_assets' and (storage.foldername(name))[2] = auth.uid()::text);
    end if;

    if not exists (
      select 1 from pg_policies where schemaname='storage' and tablename='objects' and policyname='chat_assets_update_own_folder'
    ) then
      create policy chat_assets_update_own_folder on storage.objects
        for update to authenticated
        using (bucket_id = 'chat_assets' and (storage.foldername(name))[2] = auth.uid()::text)
        with check (bucket_id = 'chat_assets' and (storage.foldername(name))[2] = auth.uid()::text);
    end if;

    if not exists (
      select 1 from pg_policies where schemaname='storage' and tablename='objects' and policyname='chat_assets_delete_own_folder'
    ) then
      create policy chat_assets_delete_own_folder on storage.objects
        for delete to authenticated
        using (bucket_id = 'chat_assets' and (storage.foldername(name))[2] = auth.uid()::text);
    end if;

    if not exists (
      select 1 from pg_policies where schemaname='storage' and tablename='objects' and policyname='chat_assets_select_authenticated'
    ) then
      create policy chat_assets_select_authenticated on storage.objects
        for select to authenticated
        using (bucket_id = 'chat_assets');
    end if;
  end if;
end
$$;
