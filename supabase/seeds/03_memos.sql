insert into public.memos (
  id,
  trick_id,
  type,
  focus,
  outcome,
  condition,
  size,
  created_at,
  updated_at
) values
(
  'cccccccc-cccc-cccc-cccc-ccccccccccc1',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1',
  'air',
  'テイクオフで肩のラインを水平に保つ',
  '軸が安定して回転がスムーズになった',
  'snow',
  'big',
  now() - interval '2 days',
  now() - interval '2 days'
),
(
  'cccccccc-cccc-cccc-cccc-ccccccccccc2',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa1',
  'air',
  '360の時点でランディングを見る',
  '着地が完璧に決まった',
  'snow',
  'middle',
  now() - interval '5 days',
  now() - interval '5 days'
),
(
  'cccccccc-cccc-cccc-cccc-ccccccccccc3',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa2',
  'air',
  '右肩を下げながら抜ける',
  'しっかり軸が入った',
  'snow',
  'big',
  now() - interval '1 day',
  now() - interval '1 day'
),
(
  'cccccccc-cccc-cccc-cccc-ccccccccccc4',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa3',
  'air',
  '目線を先行させる',
  '回転不足が解消',
  'brush',
  'small',
  now() - interval '3 days',
  now() - interval '3 days'
),
(
  'dddddddd-dddd-dddd-dddd-ddddddddddd1',
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb1',
  'jib',
  '目線と肩を先行させる',
  '乗り込みがスムーズになった',
  null,
  null,
  now() - interval '1 day',
  now() - interval '1 day'
),
(
  'dddddddd-dddd-dddd-dddd-ddddddddddd2',
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb2',
  'jib',
  'トップシートをフラットに保つ',
  'バタつきが減った',
  null,
  null,
  now() - interval '3 days',
  now() - interval '3 days'
)
on conflict (id) do nothing;
