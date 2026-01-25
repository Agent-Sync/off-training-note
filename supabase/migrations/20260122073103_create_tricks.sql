-- Tricks table (air/jib)
create table if not exists public.tricks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  type text not null check (type in ('air', 'jib')),
  custom_name text,
  trick_name text,
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

create or replace function public.build_air_trick_name(
  stance text,
  takeoff text,
  axis text,
  spin integer,
  grab text,
  direction text
)
returns text as $$
declare
  parts text[] := '{}';
  axis_label text := (select label_ja from public.axes where code = axis);
  grab_label text := (select label_ja from public.grabs where code = grab);
  is_flat boolean := axis = 'upright';
  is_flip boolean := axis in ('backflip', 'frontflip');
  direction_label text;
begin
  if axis_label is null then
    axis_label := axis;
  end if;
  if grab_label is null or grab = 'none' then
    grab_label := null;
  end if;
  if direction = 'left' then
    direction_label := 'レフト';
  elsif direction = 'right' then
    direction_label := 'ライト';
  else
    direction_label := null;
  end if;

  if stance = 'regular' and coalesce(spin, 0) = 0 then
    if takeoff = 'carving' then
      parts := array_append(parts, 'カービング');
      if is_flat then
        parts := array_append(parts, 'ストレート');
      end if;
    elsif is_flat then
      parts := array_append(parts, 'ストレート');
    end if;
    if not is_flat then
      parts := array_append(parts, axis_label);
      if not is_flip then
        parts := array_append(parts, coalesce(spin, 0)::text);
      end if;
    end if;
    if grab_label is not null then
      parts := array_append(parts, grab_label);
    end if;
    return array_to_string(parts, ' ');
  end if;

  if stance = 'switchStance' and coalesce(spin, 0) = 0 then
    parts := array_append(parts, 'スイッチ');
    if direction_label is not null then
      parts := array_append(parts, direction_label);
    end if;
    if takeoff = 'carving' then
      parts := array_append(parts, 'カービング');
    end if;
    if not is_flat then
      parts := array_append(parts, axis_label);
      if not is_flip then
        parts := array_append(parts, coalesce(spin, 0)::text);
      end if;
    else
      parts := array_append(parts, '0');
    end if;
    if grab_label is not null then
      parts := array_append(parts, grab_label);
    end if;
    return array_to_string(parts, ' ');
  end if;

  if stance = 'switchStance' then
    parts := array_append(parts, 'スイッチ');
  end if;
  if direction_label is not null then
    parts := array_append(parts, direction_label);
  end if;
  if takeoff = 'carving' then
    parts := array_append(parts, 'カービング');
  end if;
  if not is_flat then
    parts := array_append(parts, axis_label);
  end if;
  if coalesce(spin, 0) > 0 and not is_flip then
    parts := array_append(parts, spin::text);
  end if;
  if grab_label is not null then
    parts := array_append(parts, grab_label);
  end if;
  if array_length(parts, 1) is null then
    return 'ストレート';
  end if;
  return array_to_string(parts, ' ');
end;
$$ language plpgsql stable;

create or replace function public.set_trick_name()
returns trigger as $$
begin
  if new.type = 'jib' then
    new.trick_name = coalesce(new.custom_name, '');
  else
    new.trick_name = public.build_air_trick_name(
      new.stance,
      new.takeoff,
      new.axis,
      new.spin,
      new.grab,
      new.direction
    );
  end if;
  return new;
end;
$$ language plpgsql;

drop trigger if exists tricks_set_trick_name on public.tricks;
create trigger tricks_set_trick_name
before insert or update of type, custom_name, stance, takeoff, axis, spin, grab, direction
on public.tricks
for each row
execute function public.set_trick_name();
