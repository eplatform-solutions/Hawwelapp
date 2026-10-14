#!/usr/bin/env bash
set -euo pipefail

# Run on production server to clean broken logoPath values
# and force safe fallback icon until logos are re-uploaded.

ROOT="${ROOT:-/opt/hawwel}"

cd "${ROOT}/dasco-backend-dashboard"
NODE_ENV=production node scripts/audit-payment-method-logos.js --clear-missing

echo ""
echo "Done. Re-upload missing payment logos from dashboard UI."
