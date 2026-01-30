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

drop policy if exists "memo_reports_select_self" on public.memo_reports;
create policy "memo_reports_select_self"
on public.memo_reports
for select
to public
using (reported_by = auth.uid());
