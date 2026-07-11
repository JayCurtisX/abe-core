# ABE Sprint 1 Backend Handoff to IOS

## Files created

```txt
db/migrations/001_create_abe_intelligence_foundation.sql
db/seeds/002_seed_demo_business.sql
db/verification/003_verify_demo_seed.sql
src/db.js
src/dashboard.mapper.js
src/dashboard.service.js
src/dashboard.route.example.ts
src/server.js
tests/dashboard.contract.test.js
package.json
.env.example
README.md
example-dashboard-response.json
```

## Commands to run migrations

```bash
export DATABASE_URL="postgres://postgres:postgres@localhost:5432/abe_demo"
npm install
npm run db:migrate
```

Equivalent direct command:

```bash
psql "$DATABASE_URL" -f db/migrations/001_create_abe_intelligence_foundation.sql
```

## Commands to seed the database

```bash
npm run db:seed
npm run db:verify
```

Equivalent direct commands:

```bash
psql "$DATABASE_URL" -f db/seeds/002_seed_demo_business.sql
psql "$DATABASE_URL" -f db/verification/003_verify_demo_seed.sql
```

## Commands to start the backend

```bash
export DATABASE_URL="postgres://postgres:postgres@localhost:5432/abe_demo"
export PORT=3001
npm start
```

## Dashboard endpoint URL

```txt
GET http://localhost:3001/api/workspaces/00000000-0000-0000-0000-000000000001/dashboard
```

Invalid workspace check:

```txt
GET http://localhost:3001/api/workspaces/11111111-1111-1111-1111-111111111111/dashboard
```

## Test results

Local contract tests passed:

```txt
pass: dashboard response matches Developer B contract
pass: invalid workspace returns no dashboard payload for route-level 404 handling
pass: dashboard service queries are scoped by workspace_id
```

Command used:

```bash
npm test
```

Result:

```txt
3 tests passed
0 failed
```

## Blockers

Live Postgres verification still requires a running PostgreSQL database with `psql` available.

What still needs verification:

```txt
psql migration execution
psql seed execution
GET endpoint call against seeded Postgres data
invalid workspace endpoint call against seeded Postgres data
```

## Sprint 1 status

Ready for a developer to run against Postgres. Developer B can connect after the backend starts and the seed has been applied.
