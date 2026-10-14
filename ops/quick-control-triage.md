# Quick-Control 500 Triage

Run on production server when `admin.7awalaty.com/quick-control` returns 500.

## 1) Confirm API health

```bash
curl -s https://admin-api.7awalaty.com/health
```

## 2) Inspect relevant logs

```bash
pm2 logs hawwel-admin-ui --lines 120 --nostream
pm2 logs hawwel-admin-api --lines 200 --nostream
```

## 3) Test system overview endpoint with valid admin token

```bash
curl -i 'https://admin-api.7awalaty.com/quick-control/system-overview?language=en' \
  -H "Authorization: Bearer <ADMIN_JWT_TOKEN>"
```

## 4) If wallet decrypt warnings appear

`getSystemOverview` now tolerates invalid encrypted wallet keys and masks them.  
Rotate/fix affected `network-fee-funding` private keys from dashboard wallet edit modal.
