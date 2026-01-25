-- Master tables for labels
create table if not exists public.grabs (
  code text primary key,
  label_ja text not null,
  label_en text not null,
  sort_order int not null
);

create table if not exists public.axes (
  code text primary key,
  label_ja text not null,
  label_en text not null,
  sort_order int not null
);

create table if not exists public.spins (
  value int primary key,
  label_ja text not null,
  label_en text not null,
  sort_order int not null
);
