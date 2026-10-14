#!/usr/bin/env bash
set -euo pipefail

# Sync Hawwel production code to VPS.
# - Runs from local Mac/Linux machine.
# - Keeps .env files on server untouched.

REMOTE_HOST="${REMOTE_HOST:-root@72.62.52.191}"
REMOTE_ROOT="${REMOTE_ROOT:-/opt/hawwel}"
LOCAL_ROOT="${LOCAL_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

DRY_RUN=false
RESTART_PM2=false
RUN_RELEASE_GATE=true
RUN_SMOKE=true

while [[ $# -gt 0 ]]; do
  case "$1" in
    --host)
      REMOTE_HOST="$2"
      shift 2
      ;;
    --remote-root)
      REMOTE_ROOT="$2"
      shift 2
      ;;
    --local-root)
      LOCAL_ROOT="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --restart-pm2)
      RESTART_PM2=true
      shift
      ;;
    --skip-release-gate)
      RUN_RELEASE_GATE=false
      shift
      ;;
    --skip-smoke)
      RUN_SMOKE=false
      shift
      ;;
    -h|--help)
      cat <<'EOF'
Usage:
  bash ops/sync-production.sh [options]

Options:
  --host <user@ip>           Remote SSH target (default: root@72.62.52.191)
  --remote-root <path>       Remote root path (default: /opt/hawwel)
  --local-root <path>        Local workspace root (default: this repository)
  --dry-run                  Preview only (no file changes remotely)
  --restart-pm2              Restart hawwel-admin-api, hawwel-api, hawwel-admin-ui after sync
  --skip-release-gate        Skip release gate audit script
  --skip-smoke               Skip post-deploy smoke checks
  -h, --help                 Show this help

Examples:
  bash ops/sync-production.sh --dry-run
  bash ops/sync-production.sh --restart-pm2
EOF
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

if ! command -v rsync >/dev/null 2>&1; then
  echo "rsync is required but not installed."
  exit 1
fi

# Keep flags compatible with older macOS rsync versions (e.g. 2.6.9).
SYNC_FLAGS=(-az --delete --progress)
if [[ "$DRY_RUN" == true ]]; then
  SYNC_FLAGS+=(--dry-run)
fi

EXCLUDES=(
  --exclude ".git"
  --exclude "node_modules"
  --exclude ".env*"
  --exclude ".DS_Store"
  --exclude ".cursor"
  --exclude ".vscode"
  # Preserve runtime uploads on server (do not delete with rsync --delete).
  # Exclude the directories themselves, not just their contents ("dir/**"), or
  # --delete still tries to remove an upload directory that is missing locally.
  --exclude "assets/images/payment_methods/"
  --exclude "assets/images/app_identity/"
  --exclude "assets/images/transfers/"
  --exclude "assets/images/users/"
  --exclude "assets/images/kyc/"
)

sync_dir() {
  local src="$1"
  local dest="$2"
  echo ""
  echo "==> Sync: ${src} -> ${REMOTE_HOST}:${dest}"
  rsync "${SYNC_FLAGS[@]}" "${EXCLUDES[@]}" "${src}" "${REMOTE_HOST}:${dest}"
}

echo "Local root : ${LOCAL_ROOT}"
echo "Remote host: ${REMOTE_HOST}"
echo "Remote root: ${REMOTE_ROOT}"
echo "Dry run    : ${DRY_RUN}"
echo "Restart PM2: ${RESTART_PM2}"
echo "Run smoke  : ${RUN_SMOKE}"

# 1) Backend API
sync_dir "${LOCAL_ROOT}/dasco-backend/" "${REMOTE_ROOT}/dasco-backend/"

# 2) Admin API
sync_dir "${LOCAL_ROOT}/dasco-backend-dashboard/" "${REMOTE_ROOT}/dasco-backend-dashboard/"

# 3) Admin UI (Nuxt source)
sync_dir "${LOCAL_ROOT}/hawwel-dashboard/" "${REMOTE_ROOT}/hawwel-dashboard/"

# 4) Ops scripts/runbooks
if [[ -d "${LOCAL_ROOT}/ops" ]]; then
  sync_dir "${LOCAL_ROOT}/ops/" "${REMOTE_ROOT}/ops/"
fi

if [[ "$DRY_RUN" == true ]]; then
  echo ""
  echo "Dry-run finished. No changes were applied on remote server."
  exit 0
fi

echo ""
echo "==> Running remote post-sync checks"
ssh "${REMOTE_HOST}" "bash -lc '
set -euo pipefail
mkdir -p ${REMOTE_ROOT}/dasco-backend-dashboard/assets/images/{payment_methods,app_identity,transfers}
mkdir -p ${REMOTE_ROOT}/dasco-backend/assets/images/{users,kyc,transfers}
chmod -R 755 ${REMOTE_ROOT}/dasco-backend-dashboard/assets/images
chmod -R 755 ${REMOTE_ROOT}/dasco-backend/assets/images
'"

if [[ "$RUN_RELEASE_GATE" == true ]]; then
  ssh "${REMOTE_HOST}" "bash -lc '
set -euo pipefail
bash ${REMOTE_ROOT}/dasco-backend-dashboard/scripts/release-gate-audit.sh ${REMOTE_ROOT%/*}
'"
fi

if [[ "$RESTART_PM2" == true ]]; then
  echo ""
  echo "==> Restarting PM2 services"
  ssh "${REMOTE_HOST}" "bash -lc '
set -euo pipefail
pm2 restart hawwel-admin-api hawwel-api hawwel-admin-ui --update-env
pm2 save
pm2 status
'"
fi

if [[ "$RUN_SMOKE" == true ]]; then
  echo ""
  echo "==> Running post-deploy smoke checks"
  ssh "${REMOTE_HOST}" "bash -lc '
set -euo pipefail
bash ${REMOTE_ROOT}/ops/post-deploy-smoke.sh
'"
fi

echo ""
echo "Sync completed successfully."
