-- Set memo user_id from parent trick (search_text removed).
create or replace function public.set_memo_user_id()
returns trigger as $$
declare
  t_user_id uuid;
begin
  select user_id into t_user_id
  from public.tricks
  where id = new.trick_id;

  if new.user_id is null then
    new.user_id = t_user_id;
  end if;

  return new;
end;
$$ language plpgsql;

drop trigger if exists memos_set_user_id on public.memos;
create trigger memos_set_user_id
before insert on public.memos
for each row
execute function public.set_memo_user_id();
