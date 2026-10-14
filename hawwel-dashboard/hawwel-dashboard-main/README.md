# Hawwel Dashboard (Nuxt)

## Environment configuration

Set runtime public API endpoints in `.env`:

```env
BASE_URL=https://admin-api.7awalaty.com
URL_FILES=https://api.7awalaty.com
```

`BASE_URL` is used for dashboard API calls.  
`URL_FILES` is used for files served from the mobile API.

## Setup

```bash
npm install
```

## Development

```bash
npm run dev
```

## Production build

```bash
npm run build
npm run preview
```

## Security notes

- Do not hardcode production URLs in page components.
- Update `.env` per environment before building.
- Rebuild after any `.env` change to avoid stale API URLs in generated output.
