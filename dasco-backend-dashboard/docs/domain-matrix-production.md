# Production Domain Matrix

This document is the single source of truth for production endpoints.

## Official production domains

- `Mobile API`: `https://api.7awalaty.com`
- `Dashboard API`: `https://admin-api.7awalaty.com`
- `Dashboard UI`: `https://admin.7awalaty.com`

## Component mapping

- `dasco-mobile-new`
  - `API_BASE_URL=https://api.7awalaty.com`
  - `DASHBOARD_API_URL=https://admin-api.7awalaty.com`
- `hawwel-dashboard`
  - `BASE_URL=https://admin-api.7awalaty.com`
  - `URL_FILES=https://api.7awalaty.com`
- `dasco-backend`
  - `BASE_API_URL=https://api.7awalaty.com`
  - `BASE_ADMIN_API_URL=https://admin-api.7awalaty.com`
  - `WEBSITE_URL=https://7awalaty.com`
- `dasco-backend-dashboard`
  - `BASE_API_URL=https://admin-api.7awalaty.com`
  - `BASE_ADMIN_API_URL=https://admin-api.7awalaty.com`
  - `WEBSITE_URL=https://admin.7awalaty.com`

## Do not hardcode domains in code

Only configuration files and CI/CD runtime variables may contain production URLs.

## Verification commands

Run from workspace root:

```bash
rg -n "syrianyouth\.online|api\.syriasooq\.com" \
  /Users/yaman/dasco \
  --glob '!**/node_modules/**' \
  --glob '!**/package-lock.json'
```

Expected result for production-ready code: no matches in active source/config files.
