# Wallet Flow Validation (Production)

Use this checklist before enabling heavy client traffic.

## Preconditions

- `hawwel-admin-api`, `hawwel-api`, `hawwel-admin-ui` are `online` in PM2.
- `rs.status().members[0].stateStr` is `PRIMARY`.
- Admin account has `quick_control_managment` permission.

## A) Read wallets from dashboard

1. Open dashboard wallet page.
2. Load wallet list with filters empty.
3. Confirm no 500 errors and table loads correctly.

Expected:
- Wallet rows are returned.
- Filtering by network/symbol/address works.

## B) Update central wallet address

1. Select one wallet with type `central`.
2. Save current value externally (for rollback).
3. Update only `address`.
4. Save and refresh page.

Expected:
- Success message.
- Updated address is persisted.
- No restart/error in PM2 logs.

## C) Update network-fee-funding private key

1. Select one wallet with type `network-fee-funding`.
2. Save current value securely (for rollback).
3. Update only `privateKey`.
4. Save and refresh page.

Expected:
- Success message.
- Change persists.
- No private key appears in logs.

## D) Negative checks (authorization/type rules)

1. Try updating `privateKey` on `central` wallet.
2. Try updating `address` on `network-fee-funding` wallet.

Expected:
- Disallowed updates are rejected by behavior/rules.
- No corrupted wallet record.

## Rollback procedure

If any check fails:

1. Re-open edited wallet.
2. Re-enter previous known-good value.
3. Save and verify.
4. Re-check transfer/deposit flows.

## Evidence to capture

- Screenshot of successful save in UI.
- `pm2 logs hawwel-admin-api --lines 80 --nostream`.
- `pm2 status`.
