insert into public.profiles (
  id,
  display_name,
  avatar_url,
  created_at,
  updated_at
) values
(
  '38df4b07-e015-4d61-ab23-c65bf9d835c8',
  'Kazuki Fujikawa',
  'https://lh3.googleusercontent.com/a/ACg8ocJc0xmTuRqRwHl6icu5D494q3oOw0tw3wsXe70B2sbM92CJYxw0=s96-c',
  '2026-01-22 08:52:57.438833+00',
  '2026-01-23 02:01:03.249488+00'
)
on conflict (id) do update set
  display_name = excluded.display_name,
  avatar_url = excluded.avatar_url,
  updated_at = excluded.updated_at;

insert into public.profiles (
  id,
  display_name,
  avatar_url,
  created_at,
  updated_at
) values
(
  '7c1d4e2e-5f6a-4b7e-8f2c-6f2d1b2a3c4d',
  'Yuto Aoki',
  null,
  now() - interval '7 days',
  now() - interval '1 day'
),
(
  '9a3c2b1d-4e5f-6a7b-8c9d-0e1f2a3b4c5d',
  'Rin Nakata',
  null,
  now() - interval '10 days',
  now() - interval '2 days'
),
(
  '2b4c6d8e-1f3a-5b7c-9d0e-1f2a3b4c5d6e',
  'Haru Sato',
  null,
  now() - interval '14 days',
  now() - interval '3 days'
)
on conflict (id) do update set
  display_name = excluded.display_name,
  avatar_url = excluded.avatar_url,
  updated_at = excluded.updated_at;
