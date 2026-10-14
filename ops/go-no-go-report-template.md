# Go/No-Go Report Template (Prelaunch)

Date:
Environment: Production
Owner:

## 1) Resource baseline

- Disk usage (`df -h`):
- App footprint (`du -sh /opt/hawwel/*`):
- Memory/swap (`free -h`, `vmstat`):
- Load average (`uptime`):
- Result: PASS / FAIL

## 2) Service health

- PM2 status:
- `https://api.7awalaty.com/health`:
- `https://admin-api.7awalaty.com/health`:
- Mongo ReplicaSet state:
- Result: PASS / FAIL

## 3) Safe load test (light)

- 20 req/s:
- 35 req/s:
- 50 req/s:
- 5xx rate:
- Any PM2 restarts:
- Result: PASS / FAIL

## 4) Wallet flow validation

- Central wallet address update:
- Network-fee-funding private key update:
- Authorization/type-rule checks:
- Rollback tested:
- Result: PASS / FAIL

## 5) Security observations

- Key leakage in logs:
- CORS/headers sanity:
- Critical findings:
- Result: PASS / FAIL

## Final decision

- Decision: GO / NO-GO
- Conditions before GO:
- Notes:
