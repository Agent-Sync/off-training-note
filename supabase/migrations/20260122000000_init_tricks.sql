-- Core tables for tricks + memos (no RLS for now)

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.tricks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  type text not null check (type in ('air', 'jib')),
  custom_name text,
  stance text,
  takeoff text,
  axis text,
  spin integer,
  grab text,
  direction text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists tricks_user_id_idx on public.tricks(user_id);

create table if not exists public.memos (
  id uuid primary key default gen_random_uuid(),
  trick_id uuid not null references public.tricks(id) on delete cascade,
  type text not null check (type in ('air', 'jib')),
  focus text not null,
  outcome text not null,
  condition text,
  size text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (
    (type = 'air') or
    (type = 'jib' and condition is null and size is null)
  )
);

create index if not exists memos_trick_id_idx on public.memos(trick_id);
