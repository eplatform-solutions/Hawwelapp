# Payment Logo Recovery Runbook

Run on production server.

## 1) Detect missing files referenced by DB

```bash
cd /opt/hawwel/hawwel-admin-api
NODE_ENV=production npm run audit:payment-logos
```

## 2) Clear broken `logoPath` values (optional but recommended)

This avoids repeated 404 requests and shows app fallback icon until re-upload.

```bash
bash /opt/hawwel/ops/repair-payment-logos.sh
```

## 3) Re-upload logos from dashboard

For each method reported by the audit:
- open payment method edit in admin dashboard
- upload logo image again
- save changes

## 4) Re-check

```bash
cd /opt/hawwel/hawwel-admin-api
NODE_ENV=production npm run audit:payment-logos
```

Expected: `missing=0`.
