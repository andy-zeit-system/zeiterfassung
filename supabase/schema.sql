-- Zeiterfassung: Datenbank-Schema für Supabase
-- Einmal im Supabase SQL Editor ausführen. Jede Person sieht nur ihre eigenen Daten (Row Level Security).

create table if not exists public.entries (
  user_id    uuid not null default auth.uid() references auth.users(id) on delete cascade,
  id         text not null default gen_random_uuid()::text,
  date       date not null,
  type       text not null check (type in ('Arbeit','Urlaub','Krankheit')),
  start_time text,
  end_time   text,
  pause      integer not null default 0,
  hours      numeric,
  reason     text,
  note       text,
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);
create index if not exists entries_user_date on public.entries (user_id, date);

create table if not exists public.settings (
  user_id    uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.entries  enable row level security;
alter table public.settings enable row level security;

drop policy if exists "eigene Eintraege" on public.entries;
create policy "eigene Eintraege" on public.entries for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

drop policy if exists "eigene Einstellungen" on public.settings;
create policy "eigene Einstellungen" on public.settings for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

revoke all on public.entries, public.settings from anon;
grant select, insert, update, delete on public.entries, public.settings to authenticated;
