# Security Hardening Runbook (Production)

This runbook applies practical hardening for production with minimal service risk.

## 1) Edge and TLS (Nginx)

Use strict HTTPS and baseline security headers on all public hosts.

```nginx
server {
    listen 80;
    server_name api.7awalaty.com admin-api.7awalaty.com admin.7awalaty.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name admin-api.7awalaty.com;

    # SSL certs handled by certbot
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "DENY" always;
    add_header Referrer-Policy "no-referrer" always;
    add_header Permissions-Policy "camera=(), microphone=(), geolocation=()" always;

    location / {
        proxy_pass http://127.0.0.1:5300;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Apply equivalent host-specific blocks for `api.7awalaty.com` and `admin.7awalaty.com`.

## 2) API CORS allowlist

Set an explicit origin allowlist in both backend services:

```bash
# /opt/hawwel/dasco-backend/.env.production
# /opt/hawwel/dasco-backend-dashboard/.env.production
CORS_ALLOWED_ORIGINS=https://admin.7awalaty.com,https://api.7awalaty.com,https://admin-api.7awalaty.com
```

## 3) Secret rotation checklist

Rotate immediately if any values were shared in chat, screenshots, or logs.

- `JWT_SECRET_KEY`
- `SECRET_KEY`
- SMTP credentials
- Twilio keys and sender secrets
- Any blockchain API keys
- Firebase service account keys (if exposed)

After rotation:

1. Update `.env.production`
2. Restart PM2 processes
3. Verify login, OTP, uploads, and webhooks
4. Invalidate old tokens if policy requires immediate cutover

## 4) Upload safety controls

Confirmed controls:

- MIME allowlist and real file-type verification
- Max upload size enforced
- Upload directories created automatically at startup and on upload paths

## 5) Runtime hardening checks

```bash
curl -I https://api.7awalaty.com/health
curl -I https://admin-api.7awalaty.com/health
curl -I https://admin.7awalaty.com
```

Validate presence of:

- `strict-transport-security`
- `x-content-type-options`
- `x-frame-options`
- `referrer-policy`
