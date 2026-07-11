# ABE Sprint 1 Backend

This package contains the smallest backend implementation for the first ABE dashboard endpoint.

## Demo workspace

```txt
00000000-0000-0000-0000-000000000001
```

## Install

```bash
npm install
cp .env.example .env
```

Update `DATABASE_URL` in `.env` if needed.

## Run migration

```bash
export DATABASE_URL="postgres://postgres:postgres@localhost:5432/abe_demo"
npm run db:migrate
```

## Run seed

```bash
npm run db:seed
```

## Verify seed

```bash
npm run db:verify
```

Expected seeded counts:

```txt
business_identity_profiles: 1
live_metrics: 5
live_signals: 2
business_facts: 1
business_goals: 1
business_state_snapshots: 1
business_state_scores: 4
recommendations: 1
evidence: 8
activity_timeline_events: 4
```

## Start backend

```bash
npm start
```

## Dashboard endpoint

```txt
GET http://localhost:3001/api/workspaces/00000000-0000-0000-0000-000000000001/dashboard
```

## Invalid workspace test

```txt
GET http://localhost:3001/api/workspaces/11111111-1111-1111-1111-111111111111/dashboard
```

Expected response:

```json
{
  "error": {
    "code": "DASHBOARD_NOT_FOUND",
    "message": "Dashboard data was not found for this workspace."
  }
}
```

## Contract test

```bash
npm test
```
