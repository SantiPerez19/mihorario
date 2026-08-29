-- Esquema para "Mi Horario"
-- Ejecuta esto en Supabase Dashboard > SQL Editor > New query y pulsa Run.

-- Si ya creaste la tabla antes, esto agrega las columnas nuevas (idempotente).
alter table public.modules
  add column if not exists type text not null default 'once';
alter table public.modules
  add column if not exists days text not null default '';

create table if not exists public.modules (
  id text primary key,
  user_id uuid not null default auth.uid(),
  title text not null,
  place text not null default '',
  notes text not null default '',
  day int not null default 0,
  date text not null,
  start_hour int not null default 0,
  end_hour int not null default 1,
  color text not null default '#6366f1',
  type text not null default 'once',
  days text not null default '',
  updated_at timestamptz not null default now()
);

alter table public.modules enable row level security;

drop policy if exists "users select own modules" on public.modules;
create policy "users select own modules" on public.modules
  for select using (auth.uid() = user_id);

drop policy if exists "users insert own modules" on public.modules;
create policy "users insert own modules" on public.modules
  for insert with check (auth.uid() = user_id);

drop policy if exists "users update own modules" on public.modules;
create policy "users update own modules" on public.modules
  for update using (auth.uid() = user_id);

drop policy if exists "users delete own modules" on public.modules;
create policy "users delete own modules" on public.modules
  for delete using (auth.uid() = user_id);
