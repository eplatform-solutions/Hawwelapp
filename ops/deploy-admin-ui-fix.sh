#!/usr/bin/env bash
# Deploy latest admin UI to production WITHOUT git on server (rsync + remote build).
# Run from your Mac inside this repository.

set -euo pipefail

REMOTE_HOST="${REMOTE_HOST:-root@72.62.52.191}"
REMOTE_ROOT="${REMOTE_ROOT:-/opt/hawwel}"
LOCAL_ROOT="${LOCAL_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

echo "==> Sync hawwel-dashboard source"
rsync -az --delete \
  --exclude ".git" \
  --exclude "node_modules" \
  --exclude ".env" \
  --exclude ".env.*" \
  --exclude ".output" \
  --exclude ".nuxt" \
  "${LOCAL_ROOT}/hawwel-dashboard/" \
  "${REMOTE_HOST}:${REMOTE_ROOT}/hawwel-dashboard/"

echo "==> Build and restart on server"
ssh "${REMOTE_HOST}" "bash -lc '
set -euo pipefail
cd ${REMOTE_ROOT}/hawwel-dashboard/hawwel-dashboard-main
npm install
npm run build
pm2 restart hawwel-admin-ui --update-env
pm2 status hawwel-admin-ui
curl -sI https://admin.7awalaty.com/app-visual-identity | head -1
'"

echo "Deploy finished."
