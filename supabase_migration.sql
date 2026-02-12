create table if not exists profiles (
  id uuid references auth.users on delete cascade not null primary key,
  username text unique,
  display_name text,
  bio text,
  location text,
  avatar_url text,
  daily_goal_minutes int default 10,
  total_xp int default 0,
  settings jsonb default '{}'::jsonb,
  updated_at timestamp with time zone,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Evolve existing profiles if needed
do $$ begin
  alter table public.profiles add column if not exists bio text;
  alter table public.profiles add column if not exists location text;
  alter table public.profiles add column if not exists settings jsonb default '{}'::jsonb;
exception when others then null; end $$;

alter table profiles enable row level security;
do $$ begin
  create policy "Public profiles are viewable by everyone." on profiles for select using (true);
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "Users can insert their own profile." on profiles for insert with check (auth.uid() = id);
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "Users can update own profile." on profiles for update using (auth.uid() = id);
exception when duplicate_object then null; end $$;

-- 1.1 AUTO-PROFILE TRIGGER
-- This function will run whenever a new user signs up
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, username, display_name, avatar_url)
  values (
    new.id,
    new.raw_user_meta_data->>'username', -- Extract username if provided in metadata
    new.raw_user_meta_data->>'display_name',
    new.raw_user_meta_data->>'avatar_url'
  );
  return new;
end;
$$ language plpgsql security definer;

-- Trigger the function on every signup
create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- 2. COURSES
create table if not exists courses (
  id text primary key,
  title text not null,
  subtitle text,
  source_lang text not null,
  target_lang text not null,
  icon_url text,
  xp_reward int default 10,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);
alter table courses enable row level security;
create policy "Allow public read access" on courses for select using (true);

create table if not exists vocabulary (
  id uuid default gen_random_uuid() primary key,
  concept_id int,
  lang text,
  word text,
  article text,
  gender text,
  romanization text,
  pinyin text,
  transliteration text,
  level text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(concept_id, lang)
);

-- Evolve vocabulary if it exists with old schema
do $$ begin
  alter table public.vocabulary add column if not exists concept_id int;
  alter table public.vocabulary add column if not exists lang text;
  alter table public.vocabulary add column if not exists word text;
  alter table public.vocabulary add column if not exists romanization text;
  alter table public.vocabulary add column if not exists pinyin text;
  alter table public.vocabulary add column if not exists transliteration text;
exception when others then null; end $$;

do $$ begin
  alter table public.vocabulary add constraint vocabulary_concept_lang_unique unique (concept_id, lang);
exception when duplicate_table or others then null; end $$;

alter table vocabulary enable row level security;
do $$ begin
  create policy "Allow public read access" on vocabulary for select using (true);
exception when duplicate_object then null; end $$;

create table if not exists sentences (
  id uuid default gen_random_uuid() primary key,
  concept_id int,
  lang_code text,
  lang_name text,
  sentence text,
  romanization text,
  pinyin text,
  transliteration text,
  level text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(concept_id, lang_code)
);

-- Evolve sentences if it exists with old schema
do $$ begin
  alter table public.sentences add column if not exists concept_id int;
  alter table public.sentences add column if not exists lang_code text;
  alter table public.sentences add column if not exists lang_name text;
  alter table public.sentences add column if not exists sentence text;
exception when others then null; end $$;

do $$ begin
  alter table public.sentences add constraint sentences_concept_lang_unique unique (concept_id, lang_code);
exception when duplicate_table or others then null; end $$;

alter table sentences enable row level security;
do $$ begin
  create policy "Allow public read access" on sentences for select using (true);
exception when duplicate_object then null; end $$;

-- 5. USER COURSES (Progress)
create table if not exists user_courses (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  course_id text references courses(id) on delete cascade not null,
  progress_xp int default 0,
  last_accessed timestamp with time zone default timezone('utc'::text, now()),
  unique(user_id, course_id)
);
alter table user_courses enable row level security;
create policy "Users can see own progress" on user_courses for select using (auth.uid() = user_id);
create policy "Users can update own progress" on user_courses for insert with check (auth.uid() = user_id);
create policy "Users can update own progress update" on user_courses for update using (auth.uid() = user_id);

-- 6. FRIENDSHIPS
create table if not exists friendships (
  id uuid default gen_random_uuid() primary key,
  requester_id uuid references profiles(id) on delete cascade not null,
  addressee_id uuid references profiles(id) on delete cascade not null,
  status text default 'pending', -- pending, accepted
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(requester_id, addressee_id)
);
alter table friendships enable row level security;
create policy "Users can see their own friendships" on friendships for select using (auth.uid() = requester_id or auth.uid() = addressee_id);
create policy "Users can request friendship" on friendships for insert with check (auth.uid() = requester_id);
create policy "Only addressee can accept friendship" on friendships for update using (auth.uid() = addressee_id);
create policy "Users can delete own friendships" on friendships for delete using (auth.uid() = requester_id or auth.uid() = addressee_id);

-- 7. MESSAGES
create table if not exists messages (
  id uuid default gen_random_uuid() primary key,
  sender_id uuid references profiles(id) on delete cascade not null,
  receiver_id uuid references profiles(id) on delete cascade not null,
  content text not null,
  is_read boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);
alter table messages enable row level security;
create policy "Users can see their own messages" on messages for select using (auth.uid() = sender_id or auth.uid() = receiver_id);
create policy "Users can send messages" on messages for insert with check (auth.uid() = sender_id);
create policy "Receivers can mark messages as read" on messages for update using (auth.uid() = receiver_id);
create policy "Users can delete own messages" on messages for delete using (auth.uid() = sender_id);

-- 8. CIRCLES
create table if not exists circles (
  id uuid default gen_random_uuid() primary key,
  host_id uuid references profiles(id) on delete cascade not null,
  name text not null,
  from_lang text,
  to_lang text,
  mode text,
  level text,
  max_players int default 5,
  questions_count int default 15,
  time_per_q int default 10,
  allow_spectators boolean default true,
  status text default 'lobby', -- lobby, active, ended
  questions jsonb default '[]'::jsonb, 
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);
alter table circles enable row level security;
create policy "Public circles are viewable" on circles for select using (true);
create policy "Field host can insert" on circles for insert with check (auth.uid() = host_id);
create policy "Host can update circle" on circles for update using (auth.uid() = host_id);

-- 9. CIRCLE PARTICIPANTS
create table if not exists circle_participants (
  id uuid default gen_random_uuid() primary key,
  circle_id uuid references circles(id) on delete cascade not null,
  user_id uuid references profiles(id) on delete cascade not null,
  role text default 'player', -- host, player, spectator
  is_ready boolean default false,
  score int default 0,
  joined_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(circle_id, user_id)
);
alter table circle_participants enable row level security;
create policy "Public view participants" on circle_participants for select using (true);
create policy "Users can join" on circle_participants for insert with check (auth.uid() = user_id);
create policy "Users can update self" on circle_participants for update using (auth.uid() = user_id);
create policy "Host can update participants" on circle_participants for update using (
  exists (select 1 from circles where id = circle_participants.circle_id and host_id = auth.uid())
);

-- 10. NOTIFICATIONS
create table if not exists notifications (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references profiles(id) on delete cascade not null,
  type text not null,
  title text,
  body text,
  metadata jsonb,
  is_read boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);
alter table notifications enable row level security;
create policy "Users see own notifications" on notifications for select using (auth.uid() = user_id);
create policy "Authenticated users can send notifications" on notifications for insert with check (auth.uid() is not null);
create policy "Users can update own notifications" on notifications for update using (auth.uid() = user_id);
create policy "Users can delete own notifications" on notifications for delete using (auth.uid() = user_id);

-- 11. USER LEARNED ITEMS (SRS Progress)
create table if not exists user_learned_items (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  course_id text references courses(id) on delete cascade not null,
  concept_id int not null,
  interval_days int default 1,
  due_at timestamp with time zone default timezone('utc'::text, now()) + interval '1 day' not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(user_id, course_id, concept_id)
);
alter table user_learned_items enable row level security;
do $$ begin
  create policy "Users can see own learned items" on user_learned_items for select using (auth.uid() = user_id);
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "Users can update own learned items" on user_learned_items for insert with check (auth.uid() = user_id);
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "Users can update own learned items update" on user_learned_items for update using (auth.uid() = user_id);
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "Users can delete own learned items" on user_learned_items for delete using (auth.uid() = user_id);
exception when duplicate_object then null; end $$;

-- 12. USER STATS
create table if not exists user_stats (
  user_id uuid references auth.users(id) on delete cascade primary key,
  total_wins int default 0,
  streak_days int default 0,
  longest_streak int default 0,
  last_active_date date,
  total_quizzes int default 0,
  total_correct int default 0,
  total_questions int default 0,
  perfect_quizzes int default 0,
  circles_joined int default 0,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);
alter table user_stats enable row level security;
create policy "Users can read own stats" on user_stats for select using (auth.uid() = user_id);
create policy "Users can insert own stats" on user_stats for insert with check (auth.uid() = user_id);
create policy "Users can update own stats" on user_stats for update using (auth.uid() = user_id);

-- 13. ACHIEVEMENTS
create table if not exists achievements (
  id text primary key,
  title text not null,
  description text,
  icon text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);
alter table achievements enable row level security;
create policy "Public achievements are viewable" on achievements for select using (true);

create table if not exists user_achievements (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  achievement_id text references achievements(id) on delete cascade not null,
  unlocked_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(user_id, achievement_id)
);
alter table user_achievements enable row level security;
create policy "Users can see own achievements" on user_achievements for select using (auth.uid() = user_id);
create policy "Users can unlock achievements" on user_achievements for insert with check (auth.uid() = user_id);

-- 14. USER SESSIONS
create table if not exists user_sessions (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  device_id text not null,
  device_name text,
  platform text,
  last_seen timestamp with time zone default timezone('utc'::text, now()) not null,
  is_current boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(user_id, device_id)
);
alter table user_sessions enable row level security;
create policy "Users can see own sessions" on user_sessions for select using (auth.uid() = user_id);
create policy "Users can insert own sessions" on user_sessions for insert with check (auth.uid() = user_id);
create policy "Users can update own sessions" on user_sessions for update using (auth.uid() = user_id);

-- 15. LEADERBOARD VIEW
create or replace view leaderboard as
  select id, username, display_name, avatar_url, total_xp as xp
  from profiles;


-- SEED DATA (Global catalog)
-- Example inserts for the new schema
insert into achievements (id, title, description, icon)
values
('top3', 'Top 3', 'Reach the global top 3', 'emoji_events'),
('fast', 'Fast', 'Perfect score on a quiz', 'flash_on'),
('level_up', 'Level Up', 'Reach 1,000 XP', 'star'),
('social', 'Social', 'Add your first friend', 'group'),
('study', 'Study', 'Complete 20 quizzes', 'school'),
('voice', 'Voice', 'Join a circle', 'mic')
on conflict do nothing;

insert into vocabulary (concept_id, lang, word, level)
values 
(1, 'en', 'to be', 'A'),
(1, 'es', 'ser', 'A'),
(1, 'fr', 'être', 'A'),
(2, 'en', 'and', 'A'),
(2, 'es', 'y', 'A')
on conflict do nothing;

insert into sentences (concept_id, lang_code, lang_name, sentence, level)
values
(1, 'en', 'English', 'I woke up early this morning', 'A'),
(1, 'es', 'Spanish', 'Me desperté temprano esta mañana', 'A'),
(2, 'en', 'English', 'Can you pass me the salt, please?', 'A'),
(2, 'es', 'Spanish', '¿Me pasas la sal, por favor?', 'A')
on conflict do nothing;

-- 13. REALTIME ENABLING
do $$ begin
  alter publication supabase_realtime add table messages;
exception when others then null; end $$;
do $$ begin
  alter publication supabase_realtime add table circles;
exception when others then null; end $$;
do $$ begin
  alter publication supabase_realtime add table circle_participants;
exception when others then null; end $$;
do $$ begin
  alter publication supabase_realtime add table notifications;
exception when others then null; end $$;
do $$ begin
  alter publication supabase_realtime add table profiles;
exception when others then null; end $$;
do $$ begin
  alter publication supabase_realtime add table friendships;
exception when others then null; end $$;
do $$ begin
  alter publication supabase_realtime add table user_sessions;
exception when others then null; end $$;
 
 - -   1 6 .   U S E R   R E P O R T S  
 c r e a t e   t a b l e   i f   n o t   e x i s t s   u s e r _ r e p o r t s   (  
     i d   u u i d   d e f a u l t   g e n _ r a n d o m _ u u i d ( )   p r i m a r y   k e y ,  
     r e p o r t e r _ i d   u u i d   r e f e r e n c e s   a u t h . u s e r s ( i d )   o n   d e l e t e   c a s c a d e   n o t   n u l l ,  
     r e p o r t e d _ u s e r _ i d   u u i d   r e f e r e n c e s   a u t h . u s e r s ( i d )   o n   d e l e t e   c a s c a d e   n o t   n u l l ,  
     r e a s o n   t e x t ,  
     d e t a i l s   t e x t ,  
     c r e a t e d _ a t   t i m e s t a m p   w i t h   t i m e   z o n e   d e f a u l t   t i m e z o n e ( ' u t c ' : : t e x t ,   n o w ( ) )   n o t   n u l l ,  
     u n i q u e ( r e p o r t e r _ i d ,   r e p o r t e d _ u s e r _ i d )  
 ) ;  
 a l t e r   t a b l e   u s e r _ r e p o r t s   e n a b l e   r o w   l e v e l   s e c u r i t y ;  
 c r e a t e   p o l i c y   " U s e r s   c a n   c r e a t e   r e p o r t s "   o n   u s e r _ r e p o r t s   f o r   i n s e r t   w i t h   c h e c k   ( a u t h . u i d ( )   =   r e p o r t e r _ i d ) ;  
 c r e a t e   p o l i c y   " U s e r s   c a n   s e e   o w n   r e p o r t s "   o n   u s e r _ r e p o r t s   f o r   s e l e c t   u s i n g   ( a u t h . u i d ( )   =   r e p o r t e r _ i d ) ;  
 c r e a t e   p o l i c y   " U s e r s   c a n   d e l e t e   o w n   r e p o r t s "   o n   u s e r _ r e p o r t s   f o r   d e l e t e   u s i n g   ( a u t h . u i d ( )   =   r e p o r t e r _ i d ) ;  
  
 - -   1 7 .   A C C O U N T   D E L E T I O N   R E Q U E S T S  
 c r e a t e   t a b l e   i f   n o t   e x i s t s   a c c o u n t _ d e l e t i o n _ r e q u e s t s   (  
     i d   u u i d   d e f a u l t   g e n _ r a n d o m _ u u i d ( )   p r i m a r y   k e y ,  
     u s e r _ i d   u u i d   r e f e r e n c e s   a u t h . u s e r s ( i d )   o n   d e l e t e   c a s c a d e   n o t   n u l l ,  
     s t a t u s   t e x t   d e f a u l t   ' p e n d i n g ' ,   - -   p e n d i n g ,   p r o c e s s e d  
     r e q u e s t e d _ a t   t i m e s t a m p   w i t h   t i m e   z o n e   d e f a u l t   t i m e z o n e ( ' u t c ' : : t e x t ,   n o w ( ) )   n o t   n u l l ,  
     p r o c e s s e d _ a t   t i m e s t a m p   w i t h   t i m e   z o n e ,  
     u n i q u e ( u s e r _ i d )  
 ) ;  
 a l t e r   t a b l e   a c c o u n t _ d e l e t i o n _ r e q u e s t s   e n a b l e   r o w   l e v e l   s e c u r i t y ;  
 c r e a t e   p o l i c y   " U s e r s   c a n   r e q u e s t   d e l e t i o n "   o n   a c c o u n t _ d e l e t i o n _ r e q u e s t s   f o r   i n s e r t   w i t h   c h e c k   ( a u t h . u i d ( )   =   u s e r _ i d ) ;  
 c r e a t e   p o l i c y   " U s e r s   c a n   s e e   o w n   d e l e t i o n   r e q u e s t s "   o n   a c c o u n t _ d e l e t i o n _ r e q u e s t s   f o r   s e l e c t   u s i n g   ( a u t h . u i d ( )   =   u s e r _ i d ) ;  
 