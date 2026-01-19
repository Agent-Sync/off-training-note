create table public.tricks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  type text not null,
  jib_custom_name text null,
  stance text null,
  takeoff text null,
  axis text null,
  spin int null,
  grab text null,
  direction text null,
  created_at timestamptz not null default now(),
  constraint tricks_type_check check (type in ('air', 'jib')),
  constraint tricks_air_fields_check check (
    (type = 'air'
      and stance is not null
      and spin is not null
      and grab is not null
      and jib_custom_name is null)
    or
    (type = 'jib'
      and jib_custom_name is not null
      and stance is null
      and takeoff is null
      and axis is null
      and spin is null
      and grab is null
      and direction is null)
  ),
  constraint tricks_takeoff_check check (
    takeoff is null or takeoff in ('straight', 'carving')
  ),
  constraint tricks_stance_check check (
    stance is null or stance in ('regular', 'switch')
  ),
  constraint tricks_direction_check check (
    direction is null or direction in ('left', 'right')
  ),
  constraint tricks_spin_check check (
    spin is null or spin >= 0
  )
);

create index tricks_user_created_at_idx
  on public.tricks (user_id, created_at desc);

create table public.tech_logs (
  id uuid primary key default gen_random_uuid(),
  trick_id uuid not null references public.tricks(id) on delete cascade,
  focus text not null,
  outcome text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index tech_logs_trick_created_at_idx
  on public.tech_logs (trick_id, created_at desc);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger set_tech_logs_updated_at
before update on public.tech_logs
for each row
execute function public.set_updated_at();
