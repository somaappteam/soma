begin;

drop table if exists public.sentences cascade;
drop table if exists public.vocabulary cascade;

create table public.vocabulary (
  voca_id integer primary key,
  concept_id integer,
  lang text,
  word text,
  article text,
  gender text,
  romanization text,
  pinyin text,
  transliteration text,
  level text
);

create table public.sentences (
  sentence_id integer primary key,
  concept_id integer,
  lang_code text,
  lang_name text,
  sentence text,
  romanization text,
  pinyin text,
  transliteration text,
  level text
);

alter table public.vocabulary enable row level security;
alter table public.sentences enable row level security;

create policy "Vocabulary is readable by everyone"
  on public.vocabulary
  for select
  using (true);

create policy "Sentences are readable by everyone"
  on public.sentences
  for select
  using (true);

grant select on table public.vocabulary to anon, authenticated;
grant select on table public.sentences to anon, authenticated;

commit;
