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
  'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee1',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa4',
  'air',
  '踏み切りで視線を先に回す',
  '回転の入りが速くなった',
  'snow',
  'big',
  now() - interval '5 days',
  now() - interval '5 days'
),
(
  'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeee2',
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb3',
  'jib',
  'オンで腰を低く保つ',
  'レールの安定感が上がった',
  null,
  null,
  now() - interval '4 days',
  now() - interval '4 days'
),
(
  'ffffffff-ffff-ffff-ffff-fffffffffff1',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa5',
  'air',
  'スイッチ踏み切りで肩を平行に',
  '軸がぶれずに回れた',
  'snow',
  'middle',
  now() - interval '7 days',
  now() - interval '7 days'
),
(
  'ffffffff-ffff-ffff-ffff-fffffffffff2',
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb4',
  'jib',
  'プレス中に視線を出口へ',
  'オフの回しがスムーズ',
  null,
  null,
  now() - interval '6 days',
  now() - interval '6 days'
),
(
  'abababab-abab-abab-abab-abababababab',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaa6',
  'air',
  '肩のラインを保って回転開始',
  '900でも軸が抜けなくなった',
  'brush',
  'big',
  now() - interval '11 days',
  now() - interval '11 days'
),
(
  'bcbcbcbc-bcbc-bcbc-bcbc-bcbcbcbcbcbc',
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbb5',
  'jib',
  'ノーズから抜ける前に目線を上げる',
  '360オフの回転が安定',
  null,
  null,
  now() - interval '10 days',
  now() - interval '10 days'
)
on conflict (id) do nothing;
