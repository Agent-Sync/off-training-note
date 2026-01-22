-- Tricks table (air/jib)
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
