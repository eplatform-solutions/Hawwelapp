# Production Data Runbook

This runbook defines a clean production flow where geographic/payment defaults are not auto-seeded, and all operational data is managed from the dashboard.

## 1) Enable MongoDB replica set support

Delete/update operations in countries, cities, areas, payment methods, and currencies use transactions. MongoDB must run as a replica set member.

```bash
npm run mongo:rs:init
npm run mongo:tx:verify
```

Expected result:
- `mongo:tx:verify` prints `Transaction support: OK`.

## 2) Seed baseline system data only

Run only baseline seeders (permissions, settings, admin, exchange/minimum limits, blockchain setup):

```bash
npm run seed:prod:baseline
```

This intentionally skips:
- legacy geographic seeders
- legacy payment method defaults

## 3) Prevent accidental legacy seeding in production

The following legacy seeders are blocked in `NODE_ENV=production` unless explicitly overridden:
- `dasco-backend/seeders/countries/create_initial_countries.js`
- `dasco-backend/seeders/cities/create_initial_cities.js`
- `dasco-backend/seeders/areas/create_initial_areas.js`
- `dasco-backend/seeders/payment_methods/create_initial_payment_methods.js`

Override only for one-time migration:

```bash
ALLOW_LEGACY_GEO_DEFAULT_SEEDERS=true node <legacy-seeder-file>
```

## 4) Cleanup existing bootstrap geography/payment data

Dry run:

```bash
npm run cleanup:operational-bootstrap
```

Apply:

```bash
npm run cleanup:operational-bootstrap -- --apply
```

The cleanup removes:
- `countries`
- `cities`
- `areas`
- `payment_methods`
- all relation tables: `country_payment_methods`, `city_payment_methods`, `area_payment_methods`

It does **not** remove blockchain technical configuration.

## 5) Operational data entry policy

After cleanup and baseline seed:
- Add countries/cities/areas from dashboard UI.
- Add fiat currencies from dashboard UI (`/currencies`).
- Keep USDT/USDC managed by blockchain configuration (not as editable business fiat rows).
- Add payment methods from dashboard UI and bind them to existing fiat currencies.

## 6) Upload directories

Payment method logos and other dashboard uploads are stored under `assets/images/`. These folders are gitignored and are created automatically on API startup. If you deploy without restarting PM2 after the first deploy, create them once manually:

```bash
mkdir -p /opt/hawwel/dasco-backend-dashboard/assets/images/{payment_methods,app_identity,transfers}
mkdir -p /opt/hawwel/dasco-backend/assets/images/{users,kyc,transfers}
chmod -R 755 /opt/hawwel/dasco-backend-dashboard/assets/images
chmod -R 755 /opt/hawwel/dasco-backend/assets/images
```

## 7) Production domain matrix

Use these domains only in production:

- Mobile API: `https://api.7awalaty.com`
- Dashboard API: `https://admin-api.7awalaty.com`
- Dashboard UI: `https://admin.7awalaty.com`

For full mapping per component, see `docs/domain-matrix-production.md`.

## 8) Mobile simulator command (production)

```bash
cd /Users/yaman/dasco/dasco-mobile-new
flutter run \
  --dart-define=API_BASE_URL=https://api.7awalaty.com \
  --dart-define=DASHBOARD_API_URL=https://admin-api.7awalaty.com
```

## 9) Release gate checks

Before each production release:

```bash
bash /Users/yaman/dasco/dasco-backend-dashboard/scripts/release-gate-audit.sh
```

If this check fails, do not deploy until legacy domains/hardcoded secrets are removed.

## 10) Security runbooks

- Domain source of truth: `docs/domain-matrix-production.md`
- Security hardening steps: `docs/security-hardening-production.md`
- Secret rotation procedure: `docs/secret-rotation-checklist.md`

## 11) Prevent upload loss on sync

When using `rsync --delete`, make sure runtime upload folders are excluded.  
Use the provided `/Users/yaman/dasco/ops/sync-production.sh` script, which already protects:

- `assets/images/payment_methods`
- `assets/images/app_identity`
- `assets/images/transfers`
- `assets/images/users`
- `assets/images/kyc`

## 12) Post-deploy logo integrity check

Run after each deploy:

```bash
cd /opt/hawwel/dasco-backend-dashboard
NODE_ENV=production node scripts/audit-payment-method-logos.js
```

If missing logos are reported, re-upload logo images from dashboard UI for affected payment methods.
