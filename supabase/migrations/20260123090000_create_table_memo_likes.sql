create table if not exists public.memo_likes (
  id uuid primary key default gen_random_uuid(),
  memo_id uuid not null references public.memos(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (memo_id, user_id)
);

create index if not exists memo_likes_memo_id_idx on public.memo_likes(memo_id);
create index if not exists memo_likes_user_id_idx on public.memo_likes(user_id);
