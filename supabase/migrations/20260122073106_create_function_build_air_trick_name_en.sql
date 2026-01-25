create or replace function public.build_air_trick_name_en(
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
  axis_label text := (select label_en from public.axes where code = axis);
  grab_label text := (select label_en from public.grabs where code = grab);
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
    direction_label := 'Left';
  elsif direction = 'right' then
    direction_label := 'Right';
  else
    direction_label := null;
  end if;

  if stance = 'regular' and coalesce(spin, 0) = 0 then
    if takeoff = 'carving' then
      parts := array_append(parts, 'Carving');
      if is_flat then
        parts := array_append(parts, 'Straight');
      end if;
    elsif is_flat then
      parts := array_append(parts, 'Straight');
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
    parts := array_append(parts, 'Switch');
    if direction_label is not null then
      parts := array_append(parts, direction_label);
    end if;
    if takeoff = 'carving' then
      parts := array_append(parts, 'Carving');
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
    parts := array_append(parts, 'Switch');
  end if;
  if direction_label is not null then
    parts := array_append(parts, direction_label);
  end if;
  if takeoff = 'carving' then
    parts := array_append(parts, 'Carving');
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
    return 'Straight';
  end if;
  return array_to_string(parts, ' ');
end;
$$ language plpgsql stable;
