create or replace function public.update_memo_like_count()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op = 'INSERT' then
    update public.memos
    set like_count = like_count + 1
    where id = new.memo_id;
    return new;
  elsif tg_op = 'DELETE' then
    update public.memos
    set like_count = greatest(like_count - 1, 0)
    where id = old.memo_id;
    return old;
  end if;
  return null;
end;
$$;
