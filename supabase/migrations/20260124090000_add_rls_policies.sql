-- Enable RLS
alter table public.profiles enable row level security;
alter table public.tricks enable row level security;
alter table public.memos enable row level security;
alter table public.memo_likes enable row level security;

-- Profiles: public read, self write
drop policy if exists "profiles_select_public" on public.profiles;
create policy "profiles_select_public"
on public.profiles
for select
to public
using (true);

drop policy if exists "profiles_insert_self" on public.profiles;
create policy "profiles_insert_self"
on public.profiles
for insert
to public
with check (id = auth.uid());

drop policy if exists "profiles_update_self" on public.profiles;
create policy "profiles_update_self"
on public.profiles
for update
to public
using (id = auth.uid())
with check (id = auth.uid());

drop policy if exists "profiles_delete_self" on public.profiles;
create policy "profiles_delete_self"
on public.profiles
for delete
to public
using (id = auth.uid());

-- Tricks: public read for public tricks, self read/write for private
drop policy if exists "tricks_select_public_or_owner" on public.tricks;
create policy "tricks_select_public_or_owner"
on public.tricks
for select
to public
using (is_public = true or user_id = auth.uid());

drop policy if exists "tricks_insert_self" on public.tricks;
create policy "tricks_insert_self"
on public.tricks
for insert
to public
with check (user_id = auth.uid());

drop policy if exists "tricks_update_self" on public.tricks;
create policy "tricks_update_self"
on public.tricks
for update
to public
using (user_id = auth.uid())
with check (user_id = auth.uid());

drop policy if exists "tricks_delete_self" on public.tricks;
create policy "tricks_delete_self"
on public.tricks
for delete
to public
using (user_id = auth.uid());

-- Memos: public read when parent trick is public, self read/write
drop policy if exists "memos_select_public_or_owner" on public.memos;
create policy "memos_select_public_or_owner"
on public.memos
for select
to public
using (
  user_id = auth.uid()
  or exists (
    select 1
    from public.tricks t
    where t.id = memos.trick_id
      and t.is_public = true
  )
);

drop policy if exists "memos_insert_owner" on public.memos;
create policy "memos_insert_owner"
on public.memos
for insert
to public
with check (
  exists (
    select 1
    from public.tricks t
    where t.id = memos.trick_id
      and t.user_id = auth.uid()
  )
);

drop policy if exists "memos_update_self" on public.memos;
create policy "memos_update_self"
on public.memos
for update
to public
using (user_id = auth.uid())
with check (user_id = auth.uid());

drop policy if exists "memos_delete_self" on public.memos;
create policy "memos_delete_self"
on public.memos
for delete
to public
using (user_id = auth.uid());

-- Memo likes: public read, self write
drop policy if exists "memo_likes_select_public" on public.memo_likes;
create policy "memo_likes_select_public"
on public.memo_likes
for select
to public
using (true);

drop policy if exists "memo_likes_insert_self" on public.memo_likes;
create policy "memo_likes_insert_self"
on public.memo_likes
for insert
to public
with check (
  user_id = auth.uid()
  and exists (
    select 1
    from public.memos m
    join public.tricks t on t.id = m.trick_id
    where m.id = memo_likes.memo_id
      and t.is_public = true
  )
);

drop policy if exists "memo_likes_delete_self" on public.memo_likes;
create policy "memo_likes_delete_self"
on public.memo_likes
for delete
to public
using (user_id = auth.uid());
