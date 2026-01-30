-- RLS for user blocks
alter table public.user_blocks enable row level security;

-- User blocks: self manage
drop policy if exists "user_blocks_select_self" on public.user_blocks;
create policy "user_blocks_select_self"
on public.user_blocks
for select
to public
using (blocker_id = auth.uid());

drop policy if exists "user_blocks_insert_self" on public.user_blocks;
create policy "user_blocks_insert_self"
on public.user_blocks
for insert
to public
with check (blocker_id = auth.uid());

drop policy if exists "user_blocks_delete_self" on public.user_blocks;
create policy "user_blocks_delete_self"
on public.user_blocks
for delete
to public
using (blocker_id = auth.uid());

-- Update select policies to hide blocked users
-- Tricks: public read for public tricks, self read for private
-- Blocked users are hidden from public reads.
drop policy if exists "tricks_select_public_or_owner" on public.tricks;
create policy "tricks_select_public_or_owner"
on public.tricks
for select
to public
using (
  user_id = auth.uid()
  or (
    is_public = true
    and not exists (
      select 1
      from public.user_blocks ub
      where ub.blocker_id = auth.uid()
        and ub.blocked_id = tricks.user_id
    )
  )
);

-- Memos: public read when parent trick is public, self read
-- Blocked users are hidden from public reads.
drop policy if exists "memos_select_public_or_owner" on public.memos;
create policy "memos_select_public_or_owner"
on public.memos
for select
to public
using (
  user_id = auth.uid()
  or (
    exists (
      select 1
      from public.tricks t
      where t.id = memos.trick_id
        and t.is_public = true
    )
    and not exists (
      select 1
      from public.user_blocks ub
      where ub.blocker_id = auth.uid()
        and ub.blocked_id = memos.user_id
    )
  )
);
