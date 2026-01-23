create or replace function public.update_memo_like_count()
returns trigger as $$
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
$$ language plpgsql;

drop trigger if exists memo_likes_update_count on public.memo_likes;
create trigger memo_likes_update_count
after insert or delete on public.memo_likes
for each row
execute function public.update_memo_like_count();
