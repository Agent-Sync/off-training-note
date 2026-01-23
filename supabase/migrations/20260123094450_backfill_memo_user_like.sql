alter table public.memos
  add column if not exists user_id uuid,
  add column if not exists like_count int not null default 0;

update public.memos m
set user_id = t.user_id
from public.tricks t
where t.id = m.trick_id
  and m.user_id is null;

do $$
begin
  if exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'memos'
      and column_name = 'user_id'
      and is_nullable = 'YES'
  ) then
    alter table public.memos alter column user_id set not null;
  end if;

  if not exists (
    select 1
    from pg_constraint
    where conname = 'memos_user_id_fkey'
  ) then
    alter table public.memos
      add constraint memos_user_id_fkey
      foreign key (user_id) references public.profiles(id) on delete cascade;
  end if;
end $$;

update public.memos m
set like_count = coalesce(lc.cnt, 0)
from (
  select memo_id, count(*)::int as cnt
  from public.memo_likes
  group by memo_id
) lc
where lc.memo_id = m.id;
