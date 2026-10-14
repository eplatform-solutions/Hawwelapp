#!/usr/bin/env bash
set -euo pipefail

# Safe prelaunch checks for production server.
# Run THIS script on the production server (Ubuntu) before app launch.

OUT_DIR="${OUT_DIR:-/tmp/hawwel-prelaunch}"
API_URL="${API_URL:-https://api.7awalaty.com/health}"
ADMIN_API_URL="${ADMIN_API_URL:-https://admin-api.7awalaty.com/health}"
REMOTE_ROOT="${REMOTE_ROOT:-/opt/hawwel}"
PHASE="${PHASE:-all}" # all | baseline | health | load

mkdir -p "${OUT_DIR}"
REPORT="${OUT_DIR}/prelaunch-report-$(date +%Y%m%d-%H%M%S).log"

log() {
  echo "" | tee -a "${REPORT}"
  echo "### $*" | tee -a "${REPORT}"
}

run() {
  echo "" | tee -a "${REPORT}"
  echo "\$ $*" | tee -a "${REPORT}"
  "$@" 2>&1 | tee -a "${REPORT}"
}

load_step() {
  local url="$1"
  local rps="$2"
  local duration="$3"
  local label="$4"
  local total=$((rps * duration))
  local ok=0
  local fail=0
  local tmp="${OUT_DIR}/load-${label}.codes"
  : > "${tmp}"

  log "Load test ${label}: ${rps} req/s for ${duration}s (${total} requests)"
  for _ in $(seq 1 "${total}"); do
    (
      code="$(curl -s -o /dev/null -m 5 -w "%{http_code}" "${url}" || true)"
      echo "${code}" >> "${tmp}"
    ) &
    sleep "$(awk "BEGIN {print 1/${rps}}")"
  done
  wait

  while IFS= read -r code; do
    if [[ "${code}" =~ ^2|3 ]]; then
      ok=$((ok + 1))
    else
      fail=$((fail + 1))
    fi
  done < "${tmp}"

  echo "Result ${label}: ok=${ok}, fail=${fail}" | tee -a "${REPORT}"
  if (( fail > 0 )); then
    echo "WARNING: non-2xx/3xx responses detected in ${label}" | tee -a "${REPORT}"
  fi
}

if [[ "${PHASE}" == "all" || "${PHASE}" == "baseline" ]]; then
  log "Baseline resource checks"
  run df -h
  run du -sh "${REMOTE_ROOT}"/*
  run free -h
  run vmstat 1 5
  run uptime
  run bash -lc "top -b -n1 | head -n 20"
fi

if [[ "${PHASE}" == "all" || "${PHASE}" == "health" ]]; then
  log "Service and database health checks"
  run pm2 status
  run pm2 logs hawwel-admin-api --lines 60 --nostream
  run pm2 logs hawwel-api --lines 60 --nostream
  run pm2 logs hawwel-admin-ui --lines 60 --nostream
  run curl -s "${API_URL}"
  run curl -s "${ADMIN_API_URL}"
  run mongosh --quiet --eval "rs.status().members[0].stateStr"
fi

if [[ "${PHASE}" == "all" || "${PHASE}" == "load" ]]; then
  log "Safe incremental load test"
  load_step "${API_URL}" 20 120 "api-rps20"
  load_step "${API_URL}" 35 120 "api-rps35"
  load_step "${API_URL}" 50 120 "api-rps50"
  load_step "${ADMIN_API_URL}" 20 120 "admin-rps20"
fi

log "Done. Report path: ${REPORT}"
echo "Saved report: ${REPORT}"
