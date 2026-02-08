begin;

alter table if exists public.vocabulary rename to vocabulary_legacy;
alter table if exists public.sentences rename to sentences_legacy;

create table if not exists public.vocabulary (
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

create table if not exists public.sentences (
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

do $$
begin
  if to_regclass('public.vocabulary_legacy') is not null then
    insert into public.vocabulary (
      concept_id,
      lang,
      word,
      article,
      gender,
      romanization,
      pinyin,
      transliteration,
      level
    )
    select
      concept_id,
      lang,
      word,
      article,
      gender,
      romanization,
      pinyin,
      transliteration,
      level
    from public.vocabulary_legacy
    on conflict (concept_id, lang) do nothing;
  end if;
end $$;

do $$
begin
  if to_regclass('public.sentences_legacy') is not null then
    insert into public.sentences (
      concept_id,
      lang_code,
      lang_name,
      sentence,
      romanization,
      pinyin,
      transliteration,
      level
    )
    select
      concept_id,
      lang_code,
      lang_name,
      sentence,
      romanization,
      pinyin,
      transliteration,
      level
    from public.sentences_legacy
    on conflict (concept_id, lang_code) do nothing;
  end if;
end $$;

alter table public.vocabulary enable row level security;
do $$ begin
  create policy "Allow public read access" on public.vocabulary for select using (true);
exception when duplicate_object then null; end $$;

alter table public.sentences enable row level security;
do $$ begin
  create policy "Allow public read access" on public.sentences for select using (true);
exception when duplicate_object then null; end $$;

commit;
