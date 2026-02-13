
-- 16. USER REPORTS
create table if not exists user_reports (
  id uuid default gen_random_uuid() primary key,
  reporter_id uuid references auth.users(id) on delete cascade not null,
  reported_user_id uuid references auth.users(id) on delete cascade not null,
  reason text,
  details text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(reporter_id, reported_user_id)
);
alter table user_reports enable row level security;
create policy "Users can create reports" on user_reports for insert with check (auth.uid() = reporter_id);
create policy "Users can see own reports" on user_reports for select using (auth.uid() = reporter_id);
create policy "Users can delete own reports" on user_reports for delete using (auth.uid() = reporter_id);

-- 17. ACCOUNT DELETION REQUESTS
create table if not exists account_deletion_requests (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  status text default 'pending', -- pending, processed
  requested_at timestamp with time zone default timezone('utc'::text, now()) not null,
  processed_at timestamp with time zone,
  unique(user_id)
);
alter table account_deletion_requests enable row level security;
create policy "Users can request deletion" on account_deletion_requests for insert with check (auth.uid() = user_id);
create policy "Users can see own deletion requests" on account_deletion_requests for select using (auth.uid() = user_id);
