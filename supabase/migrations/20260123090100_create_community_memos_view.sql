create or replace view public.community_memos as
select
  memos.id as memo_id,
  memos.trick_id,
  memos.type as memo_type,
  memos.focus,
  memos.outcome,
  memos.condition,
  memos.size,
  memos.created_at as memo_created_at,
  memos.updated_at as memo_updated_at,
  tricks.type as trick_type,
  tricks.custom_name,
  tricks.stance,
  tricks.takeoff,
  tricks.axis,
  tricks.spin,
  tricks.grab,
  tricks.direction,
  tricks.user_id,
  tricks.created_at as trick_created_at,
  profiles.display_name,
  profiles.avatar_url,
  coalesce(like_counts.like_count, 0) as like_count,
  trim(both from concat_ws(' ', tricks.custom_name, tricks.spin::text, tricks.grab, tricks.axis))
    as trick_search
from public.memos
join public.tricks on tricks.id = memos.trick_id
join public.profiles on profiles.id = tricks.user_id
left join (
  select memo_id, count(*)::int as like_count
  from public.memo_likes
  group by memo_id
) like_counts on like_counts.memo_id = memos.id
where tricks.is_public = true;
