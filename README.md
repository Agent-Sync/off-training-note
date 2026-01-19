# Off Training Note (Flutter base)

This repo is a minimal, simple Flutter app structure with a small home screen.

## Run
```bash
flutter pub get
flutter run
```

## Supabase (backend scaffold)
This repo includes a minimal Supabase CLI scaffold at `supabase/`.

1) Install the Supabase CLI.
2) Set your project ref in `supabase/config.toml`.
3) Copy `.env.example` to `.env` and fill in your project keys.
4) Run `supabase start` to bring up the local stack.

## lib/ layout (simple)
```
lib/
  main.dart
  app.dart
  screens/
  widgets/
  theme/
  models/
  services/
  state/
  utils/
```
