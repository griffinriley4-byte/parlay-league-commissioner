-- Riley Parley Pick'em — Supabase schema
-- Run this once in your Supabase project's SQL Editor (Project > SQL Editor > New query).

-- One row holds the whole league's shared state: the roster and every week's picking
-- order, picks, and results. There's no login here, so any anon request can read or
-- update it — access control for this app is "only people with the link know it exists."
create table if not exists public.league_state (
  id int primary key,
  data jsonb not null,
  updated_at timestamptz not null default now()
);

-- Seed the single row with 6 blank players and 15 empty regular-season weeks, matching
-- this app's defaults. Safe to re-run: does nothing if the row already exists.
insert into public.league_state (id, data)
values (
  1,
  jsonb_build_object(
    'players', (
      select jsonb_agg(jsonb_build_object('id', 'p' || n, 'name', 'Player ' || n))
      from generate_series(1, 6) as n
    ),
    'weeks', (
      select jsonb_agg(jsonb_build_object(
        'num', n, 'order', null, 'picks', '{}'::jsonb, 'results', '{}'::jsonb,
        'finalized', false, 'combinedOdds', '', 'toWin', ''
      ))
      from generate_series(1, 15) as n
    )
  )
)
on conflict (id) do nothing;

alter table public.league_state enable row level security;

create policy "anyone can read league state" on public.league_state
  for select using (true);

create policy "anyone can update league state" on public.league_state
  for update using (true) with check (true);

-- Realtime: lets every open browser tab pick up another player's edits live.
alter publication supabase_realtime add table public.league_state;
