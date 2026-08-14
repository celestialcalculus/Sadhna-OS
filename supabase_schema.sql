-- SĀDHANA OS Cloud Database
-- Run in Supabase SQL Editor.

create table if not exists public.sankalps (
 id uuid primary key, user_id uuid not null references auth.users(id) on delete cascade,
 name text not null, type text not null, mantra text not null, deity text, purpose text,
 unit text not null, target numeric not null default 0, reps numeric not null default 108,
 "dailyTarget" numeric not null default 0, start date not null, deadline date,
 status text not null default 'active', "defaultSession" text,
 created timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz
);
create table if not exists public.sessions (
 id uuid primary key, user_id uuid not null references auth.users(id) on delete cascade,
 "sankalpId" uuid not null references public.sankalps(id) on delete cascade,
 date date not null, amount numeric not null, session text, duration numeric not null default 0,
 created timestamptz not null default now(), updated_at timestamptz not null default now(), deleted_at timestamptz
);
create table if not exists public.milestones (
 id uuid primary key, user_id uuid not null references auth.users(id) on delete cascade,
 "sankalpId" uuid not null references public.sankalps(id) on delete cascade,
 amount numeric not null, label text, created timestamptz not null default now(),
 updated_at timestamptz not null default now(), deleted_at timestamptz
);
create table if not exists public.events (
 id uuid primary key, user_id uuid not null references auth.users(id) on delete cascade,
 at timestamptz not null default now(), type text, "sankalpId" uuid references public.sankalps(id) on delete cascade,
 text text, updated_at timestamptz not null default now(), deleted_at timestamptz
);

alter table public.sankalps enable row level security;
alter table public.sessions enable row level security;
alter table public.milestones enable row level security;
alter table public.events enable row level security;

drop policy if exists "users own sankalps" on public.sankalps;
create policy "users own sankalps" on public.sankalps for all to authenticated using (auth.uid()=user_id) with check (auth.uid()=user_id);
drop policy if exists "users own sessions" on public.sessions;
create policy "users own sessions" on public.sessions for all to authenticated using (auth.uid()=user_id) with check (auth.uid()=user_id);
drop policy if exists "users own milestones" on public.milestones;
create policy "users own milestones" on public.milestones for all to authenticated using (auth.uid()=user_id) with check (auth.uid()=user_id);
drop policy if exists "users own events" on public.events;
create policy "users own events" on public.events for all to authenticated using (auth.uid()=user_id) with check (auth.uid()=user_id);

create index if not exists sankalps_user_idx on public.sankalps(user_id);
create index if not exists sessions_user_idx on public.sessions(user_id);
create index if not exists sessions_sankalp_idx on public.sessions("sankalpId");
create index if not exists milestones_user_idx on public.milestones(user_id);
create index if not exists events_user_idx on public.events(user_id);

alter publication supabase_realtime add table public.sankalps;
alter publication supabase_realtime add table public.sessions;
alter publication supabase_realtime add table public.milestones;
alter publication supabase_realtime add table public.events;
