insert into public.memo_likes (
  memo_id,
  user_id,
  created_at
) values
(
  '5afc81e9-ac02-40aa-9f16-04831119330f',
  '38df4b07-e015-4d61-ab23-c65bf9d835c8',
  now() - interval '1 day'
),
(
  '01abf228-9739-483e-9757-291836978425',
  '38df4b07-e015-4d61-ab23-c65bf9d835c8',
  now() - interval '2 hours'
)
on conflict do nothing;
