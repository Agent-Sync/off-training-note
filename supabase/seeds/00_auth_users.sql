insert into auth.users (
  id,
  instance_id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at
) values
(
  '38df4b07-e015-4d61-ab23-c65bf9d835c8',
  '00000000-0000-0000-0000-000000000000',
  'authenticated',
  'authenticated',
  'tengchuanheji@gmail.com',
  null,
  '2026-01-22 08:52:57.44943+00',
  '{"provider":"google","providers":["google"]}',
  '{"iss":"https://accounts.google.com","sub":"113063214262650760898","name":"Kazuki Fujikawa","email":"tengchuanheji@gmail.com","picture":"https://lh3.googleusercontent.com/a/ACg8ocJc0xmTuRqRwHl6icu5D494q3oOw0tw3wsXe70B2sbM92CJYxw0=s96-c","full_name":"Kazuki Fujikawa","avatar_url":"https://lh3.googleusercontent.com/a/ACg8ocJc0xmTuRqRwHl6icu5D494q3oOw0tw3wsXe70B2sbM92CJYxw0=s96-c","provider_id":"113063214262650760898","email_verified":true,"phone_verified":false}',
  '2026-01-22 08:52:57.438833+00',
  '2026-01-23 02:01:03.249488+00'
)
on conflict (id) do nothing;
