# Hawwel

All Hawwel code in one repository.

| Folder | What it is | Runs on |
| --- | --- | --- |
| `dasco-backend` | Client API (mobile app) | VPS, pm2 `hawwel-api` → api.7awalaty.com |
| `dasco-backend-dashboard` | Admin API | VPS, pm2 `hawwel-admin-api` → admin-api.7awalaty.com |
| `hawwel-dashboard` | Admin dashboard UI (Nuxt) | VPS, pm2 `hawwel-admin-ui` → admin.7awalaty.com |
| `dasco-mobile-new` | Mobile app (Flutter) | App Store / Google Play |
| `hawwel-website` | Public website | hawwelapp.com |
| `ops` | Deploy and maintenance scripts | Run from a developer machine |

## Branches

- `main` is what runs in production. Nothing is deployed from any other branch.
- New work goes on a short-lived branch (`fix/...`, `feature/...`), is merged into `main`, and the branch is deleted.
- Every production deploy is tagged: `deploy-YYYY-MM-DD` (e.g. `git tag deploy-2026-10-14 && git push --tags`).
- `Style-Demo` keeps the earlier mobile app design (v1.0.8, May 2026) for reference only. It is never deployed
  or merged into `main`.

## Secrets

Real `.env` files never go into git; only `.env.example` files do. Production values live only in
`/opt/hawwel/<project>/.env.production` on the server.

## Deploy (API / dashboard)

From an up-to-date `main`:

```bash
bash ops/sync-production.sh --dry-run      # review: no unexpected "deleting" lines
bash ops/sync-production.sh --restart-pm2
```
