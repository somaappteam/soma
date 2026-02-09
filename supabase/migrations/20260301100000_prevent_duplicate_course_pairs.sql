-- Prevent duplicate courses for the same source/target language pair.

update public.courses
set
  source_lang = nullif(lower(trim(source_lang)), ''),
  target_lang = nullif(lower(trim(target_lang)), '')
where source_lang is not null or target_lang is not null;

create unique index if not exists courses_source_target_pair_unique_idx
on public.courses ((lower(trim(source_lang))), (lower(trim(target_lang))))
where source_lang is not null and target_lang is not null;

do $$
begin
  alter table public.courses
    add constraint courses_source_target_different_chk
    check (
      source_lang is null
      or target_lang is null
      or lower(trim(source_lang)) <> lower(trim(target_lang))
    );
exception
  when duplicate_object then null;
end $$;
