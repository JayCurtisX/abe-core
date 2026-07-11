# ABE Core

Deterministic business execution engine powering ABE Lite. This repository contains the Sprint 1 dashboard API, its PostgreSQL schema and demo seed data, plus contract tests.

## Requirements

- Node.js 20 or later
- PostgreSQL with a database available through `DATABASE_URL`

## Setup

```bash
npm install
cp .env.example .env
```

Set `DATABASE_URL` in `.env` (or export it in your shell), for example:

```bash
postgres://postgres:postgres@localhost:5432/abe_demo
```

## Database

```bash
npm run db:migrate
npm run db:seed
npm run db:verify
```

The demo workspace ID is `00000000-0000-0000-0000-000000000001`.

## Run and test

```bash
npm start
npm test
```

The dashboard endpoint is:

```txt
GET http://localhost:3001/api/workspaces/00000000-0000-0000-0000-000000000001/dashboard
```

## Repository layout

- `src/` — HTTP server and dashboard data mapping
- `db/` — migrations, demo seed, and database verification script
- `tests/` — Node.js contract tests
- `SPRINT1_HANDOFF_TO_IOS.md` — client integration details
