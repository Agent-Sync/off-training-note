-- Tricks table (air/jib)
create table if not exists public.tricks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  type text not null check (type in ('air', 'jib')),
  custom_name text,
  trick_name_ja text,
  trick_name_en text,
  stance text,
  takeoff text,
  axis text references public.axes(code),
  spin integer references public.spins(value),
  grab text references public.grabs(code),
  direction text,
  is_public boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists tricks_user_id_idx on public.tricks(user_id);
