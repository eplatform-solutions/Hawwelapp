#!/usr/bin/env bash
set -euo pipefail

# Run this script ON THE SERVER as root.
# It writes a hardened nginx config for:
# - api.7awalaty.com        -> 127.0.0.1:5200
# - admin-api.7awalaty.com  -> 127.0.0.1:5300
# - admin.7awalaty.com      -> 127.0.0.1:3000

CONF_AVAIL="/etc/nginx/sites-available/7awalaty.conf"
CONF_ENABLED="/etc/nginx/sites-enabled/7awalaty.conf"
BACKUP_DIR="/root/nginx-backups/$(date +%Y%m%d-%H%M%S)"

API_CERT_DIR="${API_CERT_DIR:-/etc/letsencrypt/live/api.7awalaty.com}"
ADMIN_API_CERT_DIR="${ADMIN_API_CERT_DIR:-/etc/letsencrypt/live/admin-api.7awalaty.com}"
ADMIN_UI_CERT_DIR="${ADMIN_UI_CERT_DIR:-/etc/letsencrypt/live/admin.7awalaty.com}"

mkdir -p "${BACKUP_DIR}"

echo "Backing up nginx config..."
cp -a /etc/nginx/nginx.conf "${BACKUP_DIR}/nginx.conf"
cp -a /etc/nginx/sites-available "${BACKUP_DIR}/sites-available"
cp -a /etc/nginx/sites-enabled "${BACKUP_DIR}/sites-enabled"

check_cert() {
  local cert_dir="$1"
  if [[ ! -f "${cert_dir}/fullchain.pem" || ! -f "${cert_dir}/privkey.pem" ]]; then
    echo "Missing certificate files in ${cert_dir}"
    echo "Run certbot first, then retry."
    exit 1
  fi
}

check_cert "${API_CERT_DIR}"
check_cert "${ADMIN_API_CERT_DIR}"
check_cert "${ADMIN_UI_CERT_DIR}"

# Quoted heredoc so nginx variables ($host, $scheme, ...) are written literally;
# the certificate paths are filled in afterwards.
cat > "${CONF_AVAIL}" <<'EOF'
server {
    listen 80;
    server_name api.7awalaty.com;
    return 301 https://$host$request_uri;
}

server {
    listen 80;
    server_name admin-api.7awalaty.com;
    return 301 https://$host$request_uri;
}

server {
    listen 80;
    server_name admin.7awalaty.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name api.7awalaty.com;

    ssl_certificate __API_CERT_DIR__/fullchain.pem;
    ssl_certificate_key __API_CERT_DIR__/privkey.pem;

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "DENY" always;
    add_header Referrer-Policy "no-referrer" always;
    add_header Permissions-Policy "camera=(), microphone=(), geolocation=()" always;

    client_max_body_size 25m;

    location / {
        proxy_pass http://127.0.0.1:5200;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

server {
    listen 443 ssl http2;
    server_name admin-api.7awalaty.com;

    ssl_certificate __ADMIN_API_CERT_DIR__/fullchain.pem;
    ssl_certificate_key __ADMIN_API_CERT_DIR__/privkey.pem;

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "DENY" always;
    add_header Referrer-Policy "no-referrer" always;
    add_header Permissions-Policy "camera=(), microphone=(), geolocation=()" always;

    client_max_body_size 25m;

    location / {
        proxy_pass http://127.0.0.1:5300;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

server {
    listen 443 ssl http2;
    server_name admin.7awalaty.com;

    ssl_certificate __ADMIN_UI_CERT_DIR__/fullchain.pem;
    ssl_certificate_key __ADMIN_UI_CERT_DIR__/privkey.pem;

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "DENY" always;
    add_header Referrer-Policy "no-referrer" always;
    add_header Permissions-Policy "camera=(), microphone=(), geolocation=()" always;

    client_max_body_size 25m;

    location = /health {
        default_type application/json;
        return 200 '{"ok":true,"service":"hawwel-admin-ui"}';
    }

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

sed -i \
  -e "s#__API_CERT_DIR__#${API_CERT_DIR}#g" \
  -e "s#__ADMIN_API_CERT_DIR__#${ADMIN_API_CERT_DIR}#g" \
  -e "s#__ADMIN_UI_CERT_DIR__#${ADMIN_UI_CERT_DIR}#g" \
  "${CONF_AVAIL}"

ln -sfn "${CONF_AVAIL}" "${CONF_ENABLED}"

echo "Testing nginx config..."
nginx -t

echo "Reloading nginx..."
systemctl reload nginx

echo "Done."
echo "Backup saved at: ${BACKUP_DIR}"
echo "Quick checks:"
echo "  curl -s https://api.7awalaty.com/health"
echo "  curl -s https://admin-api.7awalaty.com/health"
echo "  curl -s https://admin.7awalaty.com/health"
echo "  curl -I https://admin.7awalaty.com | egrep -i 'strict-transport|x-content-type|x-frame-options|referrer-policy|permissions-policy'"
