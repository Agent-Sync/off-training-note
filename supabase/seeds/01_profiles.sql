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
on conflict (id) do nothing;
