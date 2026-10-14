# Acceptance Checklist: Geography, Payment Methods, and Fiat Currencies

## Preconditions
- API running with valid admin token.
- MongoDB transactions verified (`npm run mongo:tx:verify`).
- Bootstrap geography/payment data cleaned (`cleanup:operational-bootstrap --apply`).

## A) Countries CRUD
1. Create country (example: `DE`).
2. Verify country appears in `countries/all`.
3. Delete country.
4. Verify related cities/areas and mapping records are removed.

Expected:
- No `Internal Server Error`.
- Deletion completes with success response.

## B) Cities CRUD
1. Create city with bilingual name (`name.ar`, `name.en`) under existing country.
2. Update city name with bilingual payload.
3. Delete city.

Expected:
- API rejects malformed city names (missing `ar` or `en`).
- No orphan mapping records after delete.

## C) Areas CRUD
1. Create area with bilingual name under city.
2. Assign payment methods.
3. Update area name and payment method links.
4. Delete area.

Expected:
- API rejects malformed area names.
- `area_payment_method` links are cleaned on delete.

## D) Fiat Currencies CRUD
1. Create fiat currency (example: `EUR`) with `usdtRate/usdcRate`.
2. Update rates.
3. Delete currency.

Expected:
- Crypto symbols (USDT/USDC) are rejected in currencies CRUD endpoints.
- No transaction failures.

## E) Payment Methods CRUD
1. Create payment method with symbol from fiat currencies table (e.g., `EUR` or `USD`).
2. Update payment method.
3. Delete payment method.

Expected:
- Crypto symbols are rejected for payment methods.
- Country/city/area payment-method links are removed on delete.
- Logo cleanup uses `logoPath`.
