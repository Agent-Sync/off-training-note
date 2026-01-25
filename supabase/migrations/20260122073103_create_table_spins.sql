create table if not exists public.spins (
  value int primary key,
  label_ja text not null,
  label_en text not null,
  sort_order int not null
);
