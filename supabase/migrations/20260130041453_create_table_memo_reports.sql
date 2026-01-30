create table if not exists public.memo_reports (
  id uuid primary key default gen_random_uuid(),
  memo_id uuid not null references public.memos(id) on delete cascade,
  reported_by uuid not null default auth.uid() references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (memo_id, reported_by)
);

create index if not exists memo_reports_memo_id_idx on public.memo_reports(memo_id);
create index if not exists memo_reports_reported_by_idx on public.memo_reports(reported_by);

alter table public.memo_reports enable row level security;

drop policy if exists "memo_reports_insert_self" on public.memo_reports;
create policy "memo_reports_insert_self"
on public.memo_reports
for insert
to public
with check (reported_by = auth.uid());

drop policy if exists "memo_reports_update_self" on public.memo_reports;
create policy "memo_reports_update_self"
on public.memo_reports
for update
to public
using (reported_by = auth.uid())
with check (reported_by = auth.uid());
