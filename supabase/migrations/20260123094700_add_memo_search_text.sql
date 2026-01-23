alter table public.memos
  add column if not exists search_text text;

update public.memos m
set search_text = trim(both from concat_ws(
  ' ',
  t.custom_name,
  t.spin::text,
  t.grab,
  t.axis,
  t.stance,
  t.takeoff,
  t.direction
))
from public.tricks t
where t.id = m.trick_id;

create or replace function public.set_memo_user_id_and_search_text()
returns trigger as $$
declare
  t_user_id uuid;
  t_custom_name text;
  t_spin integer;
  t_grab text;
  t_axis text;
  t_stance text;
  t_takeoff text;
  t_direction text;
begin
  select user_id, custom_name, spin, grab, axis, stance, takeoff, direction
    into t_user_id, t_custom_name, t_spin, t_grab, t_axis, t_stance, t_takeoff, t_direction
  from public.tricks
  where id = new.trick_id;

  if new.user_id is null then
    new.user_id = t_user_id;
  end if;

  new.search_text = trim(both from concat_ws(
    ' ',
    t_custom_name,
    t_spin::text,
    t_grab,
    t_axis,
    t_stance,
    t_takeoff,
    t_direction
  ));
  return new;
end;
$$ language plpgsql;

drop trigger if exists memos_set_user_id on public.memos;
create trigger memos_set_user_id
before insert on public.memos
for each row
execute function public.set_memo_user_id_and_search_text();

create or replace function public.update_memo_search_text_from_trick()
returns trigger as $$
begin
  update public.memos
  set search_text = trim(both from concat_ws(
    ' ',
    new.custom_name,
    new.spin::text,
    new.grab,
    new.axis,
    new.stance,
    new.takeoff,
    new.direction
  ))
  where trick_id = new.id;
  return new;
end;
$$ language plpgsql;

drop trigger if exists tricks_update_memo_search_text on public.tricks;
create trigger tricks_update_memo_search_text
after update of custom_name, spin, grab, axis, stance, takeoff, direction on public.tricks
for each row
execute function public.update_memo_search_text_from_trick();
