create or replace function public.set_trick_name()
returns trigger as $$
begin
  if new.type = 'jib' then
    new.trick_name = coalesce(new.custom_name, '');
    new.trick_name_en = coalesce(new.custom_name, '');
  else
    new.trick_name = public.build_air_trick_name(
      new.stance,
      new.takeoff,
      new.axis,
      new.spin,
      new.grab,
      new.direction
    );
    new.trick_name_en = public.build_air_trick_name_en(
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
