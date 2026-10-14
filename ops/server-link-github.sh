#!/usr/bin/env bash
# Run ON THE PRODUCTION SERVER (e.g. ssh root@72.62.52.191)
# Links /opt/hawwel projects to your GitHub repos and checks out V1 branches.
# Preserves existing .env files before checkout.

set -euo pipefail

ROOT="${ROOT:-/opt/hawwel}"
GITHUB_USER="${GITHUB_USER:-yaman-alkadri}"

link_repo() {
  local dir="$1"
  local repo="$2"
  local branch="$3"
  local env_paths=("${@:4}")

  echo ""
  echo "=========================================="
  echo "==> ${dir}  ->  ${repo}  (${branch})"
  echo "=========================================="

  if [[ ! -d "${ROOT}/${dir}" ]]; then
    echo "SKIP: directory missing: ${ROOT}/${dir}"
    return 0
  fi

  cd "${ROOT}/${dir}"

  # Backup env files if present
  local backup_dir
  backup_dir="$(mktemp -d)"
  for env_path in "${env_paths[@]}"; do
    if [[ -f "${env_path}" ]]; then
      mkdir -p "${backup_dir}/$(dirname "${env_path}")"
      cp "${env_path}" "${backup_dir}/${env_path}"
      echo "Backed up ${env_path}"
    fi
  done

  if [[ ! -d .git ]]; then
    git init
    git remote add origin "git@github.com:${GITHUB_USER}/${repo}.git" 2>/dev/null || \
      git remote set-url origin "git@github.com:${GITHUB_USER}/${repo}.git"
  else
    git remote set-url origin "git@github.com:${GITHUB_USER}/${repo}.git" 2>/dev/null || \
      git remote add origin "git@github.com:${GITHUB_USER}/${repo}.git"
  fi

  git fetch origin
  git checkout -B "${branch}" "origin/${branch}"
  git reset --hard "origin/${branch}"

  # Restore env files
  for env_path in "${env_paths[@]}"; do
    if [[ -f "${backup_dir}/${env_path}" ]]; then
      mkdir -p "$(dirname "${env_path}")"
      cp "${backup_dir}/${env_path}" "${env_path}"
      echo "Restored ${env_path}"
    fi
  done
  rm -rf "${backup_dir}"

  git status -sb
}

echo "Server root: ${ROOT}"
echo "GitHub user: ${GITHUB_USER}"
echo ""
echo "Prerequisite: server SSH key must be added to GitHub (Deploy key or account key)."
echo "Test: ssh -T git@github.com"
echo ""

link_repo "dasco-backend" "Hawwel-backend" "V1-main" ".env"
link_repo "dasco-backend-dashboard" "Hawwel-backend-dashboard" "V1-main" ".env"
link_repo "hawwel-dashboard" "Hawwel-dashboard" "V1-v2" "hawwel-dashboard-main/.env"
# Mobile source is usually built locally; link only if you keep it on server:
if [[ -d "${ROOT}/dasco-mobile-new" ]]; then
  link_repo "dasco-mobile-new" "Hawwel-mobile-app" "V1-old-style"
fi

echo ""
echo "==> Rebuild admin UI"
if [[ -d "${ROOT}/hawwel-dashboard/hawwel-dashboard-main" ]]; then
  cd "${ROOT}/hawwel-dashboard/hawwel-dashboard-main"
  npm install
  npm run build
fi

echo ""
echo "==> Restart PM2"
pm2 restart hawwel-admin-api hawwel-api hawwel-admin-ui --update-env
pm2 save
pm2 status

echo ""
echo "Done. Verify: curl -sI https://admin.7awalaty.com/app-visual-identity | head -1"
