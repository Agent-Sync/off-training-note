-- Memos table (air/jib)
create table if not exists public.memos (
  id uuid primary key default gen_random_uuid(),
  trick_id uuid not null references public.tricks(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  type text not null check (type in ('air', 'jib')),
  focus text not null,
  outcome text not null,
  condition text,
  size text,
  like_count int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (
    (type = 'air') or
    (type = 'jib' and condition is null and size is null)
  )
);

create index if not exists memos_trick_id_idx on public.memos(trick_id);
create index if not exists memos_user_id_idx on public.memos(user_id);
