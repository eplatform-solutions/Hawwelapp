# Hawwel — Marketing & Legal Website

Bilingual (Arabic / English) marketing and legal website for **Hawwel**, a digital interface for creating, managing, and tracking transfer requests, operated by **E-Platform Solutions UAB**.

The site is intentionally built with cautious, compliance-aware copy. It does **not** describe Hawwel as a bank, payment institution, money transmitter, exchange, broker, wallet provider, or any regulated financial entity.

---

## Stack

- **React 18** + **TypeScript** + **Vite 5**
- **Tailwind CSS 3** (with custom Hawwel design tokens)
- **React Router 6**
- **react-helmet-async** (per-page SEO / Open Graph)
- **Tajawal** (Arabic) + **Inter** (Latin) from Google Fonts
- No backend, no analytics, no third-party trackers, no payments.

## Languages

- Default language: **Arabic (RTL)**.
- Working language toggle in the header (and footer): `EN` / `AR`.
- The user choice is stored in `localStorage` (`hawwel.lang`).
- The `<html lang>` and `<html dir>` attributes update on every change.
- All copy is centralized in [`src/i18n/translations.ts`](src/i18n/translations.ts).

## Routes

| Path                  | Page                       |
| --------------------- | -------------------------- |
| `/`                   | Home                       |
| `/how-it-works`       | How it works               |
| `/available-regions`  | Available regions          |
| `/support`            | Support                    |
| `/contact`            | Contact                    |
| `/legal`              | Legal Notice               |
| `/aml-kyc`            | AML / KYC Policy           |
| `/terms`              | Terms of Use               |
| `/privacy`            | Privacy Policy             |
| `/learn`              | Learning center            |
| `/learn/what-is-digital-transfer-request` | Learn article |
| `/learn/how-to-track-transfer-request` | Learn article |
| `/learn/why-verification-may-be-required` | Learn article |
| `/learn/understanding-available-rates` | Learn article |
| `/learn/transfer-request-app-vs-digital-wallet` | Learn article |
| `/learn/how-supported-regions-work` | Learn article |
| `*`                   | 404 Not Found              |

## Logo

The brand logo lives at [`public/logo.png`](public/logo.png).

The [`Logo`](src/components/Logo.tsx) component:

1. Renders `/logo.png` inside a small dark-green rounded tile (matching the brand square in the artwork).
2. Falls back automatically to a text wordmark (`H` glyph + “Hawwel | حوِّل”) if the image fails to load.
3. Supports three variants: `header`, `footer`, and `hero`.

To replace the logo later, simply overwrite `public/logo.png` (or drop in `public/logo.svg` and tweak the `<img src>` in [`Logo.tsx`](src/components/Logo.tsx)). No other code changes required.

> **Asset note:** The current `logo.png` includes a built-in dark-green background. If you later receive a transparent / light variant, replacing the file is enough — the surrounding tile in the component already matches the brand color, so the result will look consistent.

## Brand tokens

Defined in [`tailwind.config.ts`](tailwind.config.ts):

| Token                | Value     | Usage                                   |
| -------------------- | --------- | --------------------------------------- |
| `brand.primary`      | `#0E2B2B` | Primary dark green                      |
| `brand.gold`         | `#D6C49A` | Accent gold / beige                     |
| `brand.bg`           | `#F7F6F1` | Page background                         |
| `brand.surface`      | `#FFFFFF` | Cards                                   |
| `brand.text`         | `#13201F` | Body text                               |
| `brand.muted`        | `#66706D` | Secondary / fine print                  |
| `brand.accent`       | `#1F6F5B` | Confirmation / "available" indicators   |
| `brand.line`         | `#E5E2D6` | Borders / dividers                      |

## Project structure

```
.
├── public/
│   ├── logo.png              ← Brand logo (replaceable)
│   └── favicon.svg
├── src/
│   ├── App.tsx               ← Routes
│   ├── main.tsx              ← Providers (Helmet, Language, Router)
│   ├── components/
│   │   ├── Layout.tsx        ← Shell + skip-to-content
│   │   ├── Header.tsx
│   │   ├── Footer.tsx
│   │   ├── Logo.tsx
│   │   ├── LanguageToggle.tsx
│   │   ├── Button.tsx
│   │   ├── Card.tsx
│   │   ├── Section.tsx
│   │   ├── Seo.tsx
│   │   ├── AppMockup.tsx
│   │   ├── StoreBadges.tsx
│   │   └── LegalPage.tsx
│   ├── i18n/
│   │   ├── LanguageContext.tsx
│   │   └── translations.ts
│   ├── routes/
│   │   ├── Home.tsx
│   │   ├── HowItWorks.tsx
│   │   ├── AvailableRegions.tsx
│   │   ├── Support.tsx
│   │   ├── Contact.tsx
│   │   ├── Legal.tsx
│   │   ├── AmlKyc.tsx
│   │   ├── Terms.tsx
│   │   ├── Privacy.tsx
│   │   ├── Learn.tsx
│   │   ├── LearnArticle.tsx
│   │   └── NotFound.tsx
│   ├── data/
│   │   └── learnArticles.ts
│   ├── styles/globals.css
│   └── vite-env.d.ts
├── index.html
├── package.json
├── postcss.config.js
├── tailwind.config.ts
├── tsconfig.json
├── tsconfig.app.json
├── tsconfig.node.json
└── vite.config.ts
```

## Run locally

```bash
cd /Users/yamanalkadri/Desktop/Hawwelapp
npm install
npm run dev          # http://localhost:5173
```

## Build for production

```bash
npm run build        # outputs dist/
npm run preview      # serves dist/ for local QA
```

The build is fully static — `dist/` can be deployed as-is to Netlify, Vercel, Cloudflare Pages, S3 + CloudFront, GitHub Pages, etc.

> **SPA hosting note:** Because we use client-side routing, configure your host to fall back to `index.html` for unknown paths (e.g. `_redirects` `/*  /index.html  200` on Netlify, or `vercel.json` `rewrites`).

## Compliance & legal copy

Every legal and marketing page emphasizes that Hawwel:

- is a **digital interface** for creating, managing, and tracking transfer requests,
- is **operated by E-Platform Solutions UAB**,
- is **not** a bank, deposit account, investment service, trading platform, cryptocurrency exchange, or custodial wallet,
- may require identity verification, source-of-funds, or purpose information,
- may delay, refuse, or cancel requests for compliance, legal, or operational reasons,
- has limited supported region availability that may change at any time.

Contact emails referenced across the site:

- `support@hawwelapp.com`
- `privacy@hawwelapp.com`
- `legal@hawwelapp.com`

Operator website: <https://eplatform-solutions.com>

## Accessibility

- Semantic HTML throughout (`<header>`, `<nav>`, `<main>`, `<footer>`, `<section>`, `<article>`).
- Visible "Skip to content" link.
- All interactive controls reachable by keyboard.
- High-contrast color palette (`#0E2B2B` text on `#F7F6F1` background well exceeds WCAG AA).
- `:focus-visible` ring (gold) on all focusable elements.
- Logo has a translated `alt` attribute that updates with language.
- ARIA states on language toggle (`aria-pressed`) and store badges (`aria-disabled="true"`).

## What is intentionally **not** included

- No backend, no API integrations, no third-party services.
- No real authentication / no user dashboard.
- No payment processing, no real transfer execution.
- No fake balances, fake exchange rates, or fake completed transfers in the mockup.
- No real App Store / Google Play links — both badges are visibly disabled with "Coming soon".
- No analytics, no cookie banner, no third-party trackers.
- The contact form is a **visual placeholder only** — submitting it shows a notice asking the user to email instead.

When you receive real assets (App Store / Play Store URLs, SDK build, etc.), wire them into:

- `src/components/StoreBadges.tsx` (replace the `aria-disabled` `<span>` with `<a href=...>`).
- `src/components/Contact.tsx` (`onSubmit` handler).
