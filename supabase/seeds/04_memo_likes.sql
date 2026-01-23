insert into public.memo_likes (
  memo_id,
  user_id,
  created_at
) values
(
  'cccccccc-cccc-cccc-cccc-ccccccccccc1',
  '38df4b07-e015-4d61-ab23-c65bf9d835c8',
  now() - interval '1 day'
),
(
  'dddddddd-dddd-dddd-dddd-ddddddddddd1',
  '38df4b07-e015-4d61-ab23-c65bf9d835c8',
  now() - interval '2 hours'
)
on conflict do nothing;
