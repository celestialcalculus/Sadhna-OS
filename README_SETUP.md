# SĀDHANA OS — Installable PWA + Cloud Sync

This package turns the current SĀDHANA OS into an installable PWA with Supabase Auth, PostgreSQL, RLS and Realtime.

## Setup

1. Create a Supabase project.
2. Open Supabase SQL Editor and run `supabase_schema.sql`.
3. Host this entire folder over HTTPS. GitHub Pages, Cloudflare Pages, Netlify or Vercel are suitable.
4. Open the hosted app.
5. Go to **Cloud Sync → Configure / Sign in**.
6. Enter the Supabase project URL and publishable/anon key.
7. Create/sign in to your account.
8. On the computer that contains your existing SĀDHANA OS records, choose **Upload local data**.
9. On iPhone, open the same HTTPS URL in Safari and use **Share → Add to Home Screen**.

## Why HTTPS matters

PWA installation requires a secure origin such as HTTPS (localhost is allowed for development). Opening the HTML directly as a `file://` document is not the correct deployment method.

## Data model

The cloud has four tables: `sankalps`, `sessions`, `milestones`, and `events`. Every row belongs to the authenticated user and is protected with Row Level Security.

## Offline behavior

The app shell is cached by the service worker. LocalStorage remains the local cache. When online and signed in, changes are pushed to Supabase and Realtime changes cause a cloud re-pull.

## Security

Only the Supabase project URL and publishable/anon key belong in browser code. Never put a Supabase service-role/secret key in the PWA.

## Current conflict model

For a single-user multi-device application this uses upsert + realtime re-pull. A more advanced conflict/tombstone system can be added later if simultaneous offline edits become important.
