# Riley Parlay Pick'em

Commissioner dashboard for a 6-player weekly college football parlay pick'em league. Static HTML/JS front end backed by Supabase (Postgres), deployed on Vercel from this GitHub repo.

No login — anyone with the site's link can view and edit picks/results, and changes sync live to everyone else's open tab.

## Setup (one-time)

### 1. Supabase

1. Create a project at supabase.com (any region/plan is fine for this app's size).
2. Open **SQL Editor > New query**, paste in the contents of [schema.sql](schema.sql), and run it.
   - This creates the `league_state` table (one row holding the roster and all 15 weeks' picks/results) and seeds it with 6 blank players.
3. Go to **Project Settings > API** and copy the **Project URL** and the **anon public** key.
4. Paste those two values into [config.js](config.js) in this repo (replacing the placeholders), commit, and push.

### 2. Vercel

1. Import this GitHub repo into Vercel ("Add New... > Project").
2. Framework preset: **Other** (it's a static site, no build step needed).
3. Deploy. Every push to `main` redeploys automatically.

## How it works

- Until `config.js` has real Supabase values, the app falls back to `localStorage` — usable on one device, but not shared. Once `config.js` is filled in and pushed, all league data (roster, picking order, picks, results) lives in Supabase and syncs across every device automatically.
- The Supabase anon key in `config.js` is meant to be public; there's no auth on this app, so the `league_state` table is open to read/write by anyone who has the key (i.e. anyone loading this site).
- Which tab is open (Roster, a given week, Season Stats) is a per-browser preference, not shared — switching tabs on your phone doesn't change what someone else sees on their laptop.
