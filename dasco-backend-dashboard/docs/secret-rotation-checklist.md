# Secret Rotation Checklist (Production)

Use this checklist whenever credentials are exposed or on periodic key rotation.

## Rotate these values

- `JWT_SECRET_KEY`
- `SECRET_KEY`
- `TWILIO_ACCOUNT_SID`
- `TWILIO_AUTH_TOKEN`
- `SMTP` credentials (`BUSSINESS_EMAIL`, `BUSSINESS_EMAIL_PASSWORD`)
- Blockchain provider keys (`TATUM`, RPC/API keys)
- Firebase service account private key

## Rotation procedure

1. Generate new secrets with strong randomness (`openssl rand -hex 32` or provider-generated tokens).
2. Update `/opt/hawwel/dasco-backend/.env.production`.
3. Update `/opt/hawwel/dasco-backend-dashboard/.env.production`.
4. Restart services:
   - `pm2 restart hawwel-admin-api hawwel-api --update-env`
5. Validate:
   - Login
   - OTP
   - File uploads
   - Notifications / SMS sending
6. Revoke old provider tokens where supported.

## Operational policy

- Never post real secrets in chat, screenshots, or issue comments.
- Keep `.env*` out of git.
- Rotate keys at fixed intervals (recommended every 90 days for high-impact secrets).
