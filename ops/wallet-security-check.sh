#!/usr/bin/env bash
set -euo pipefail

# Scan PM2/API logs for accidental key leakage.
# Run on production server.

OUT_DIR="${OUT_DIR:-/tmp/hawwel-prelaunch}"
mkdir -p "${OUT_DIR}"
REPORT="${OUT_DIR}/wallet-security-$(date +%Y%m%d-%H%M%S).log"

pattern='privateKey|PRIVATE_KEY|seed phrase|mnemonic|BEGIN PRIVATE KEY|0x[a-fA-F0-9]{64}'

{
  echo "Wallet/security log scan"
  echo "Timestamp: $(date -Iseconds)"
  echo ""
  echo "Scanning PM2 app logs:"
  pm2 logs hawwel-admin-api --lines 200 --nostream || true
  pm2 logs hawwel-api --lines 200 --nostream || true
  echo ""
  echo "Pattern: ${pattern}"
} > "${REPORT}" 2>&1

if command -v rg >/dev/null 2>&1; then
  if rg -n "${pattern}" "${REPORT}" >/dev/null 2>&1; then
    echo "WARNING: possible sensitive content found in logs."
    rg -n "${pattern}" "${REPORT}" || true
    exit 1
  fi
else
  if grep -nE "${pattern}" "${REPORT}" >/dev/null 2>&1; then
    echo "WARNING: possible sensitive content found in logs."
    grep -nE "${pattern}" "${REPORT}" || true
    exit 1
  fi
fi

echo "OK: no obvious wallet key leakage patterns found."
echo "Saved report: ${REPORT}"
