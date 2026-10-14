#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"

echo "[release-gate] Root: ${ROOT_DIR}"

domain_pattern='syrianyouth\.online|api\.syriasooq\.com'
secret_pattern='(JWT_SECRET_KEY|SECRET_KEY|TWILIO_AUTH_TOKEN|SMTP_PASSWORD|PRIVATE_KEY)\s*[:=]\s*["'"'"']?[A-Za-z0-9_\-\/+=]{16,}'

domain_hits="$(rg -n "${domain_pattern}" "${ROOT_DIR}" \
  --glob '!**/node_modules/**' \
  --glob '!**/.git/**' \
  --glob '!**/package-lock.json' \
  --glob '!**/*.plan.md' || true)"

if [[ -n "${domain_hits}" ]]; then
  echo "[release-gate] FAILED: legacy/stage domains found:"
  echo "${domain_hits}"
  exit 1
fi

secret_hits="$(rg -n "${secret_pattern}" "${ROOT_DIR}" \
  --glob '!**/node_modules/**' \
  --glob '!**/.git/**' \
  --glob '!**/.env*' \
  --glob '!**/package-lock.json' || true)"

if [[ -n "${secret_hits}" ]]; then
  echo "[release-gate] FAILED: possible hardcoded secrets found:"
  echo "${secret_hits}"
  exit 1
fi

echo "[release-gate] PASSED: no legacy domains or obvious hardcoded secrets found."
