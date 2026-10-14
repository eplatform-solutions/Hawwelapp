#!/usr/bin/env bash
set -euo pipefail

# Run on production server after deployment.
# Verifies core health endpoints and uploaded payment logos availability.

ROOT="${ROOT:-/opt/hawwel}"

echo "[post-deploy] Health checks"
curl -fsS https://api.7awalaty.com/health
curl -fsS https://admin-api.7awalaty.com/health
curl -fsS https://admin.7awalaty.com/health

echo ""
echo "[post-deploy] Payment logos audit"
cd "${ROOT}/hawwel-admin-api"
NODE_ENV=production node scripts/audit-payment-method-logos.js

echo ""
echo "[post-deploy] Done"
