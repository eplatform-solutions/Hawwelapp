# Hawwel — Platform & Controls Overview

**Operator:** E-Platform Solutions UAB (Lithuania, registration code 307502599)
**Product:** Hawwel — mobile application for cross-border value transfer
**Document status:** Factual description of the platform as built, prepared for
prospective custody/licensing partners and for legal counsel. It describes what
the system does today, including where it does not yet meet a requirement.
**Date:** September 2026

---

## 1. What the product does

A sender — predominantly located in the EU — uses the mobile app to send value
to a recipient in Syria, Jordan or Egypt. The recipient collects the equivalent
amount in **cash** from a local payout agent.

The sender funds the transfer by sending a **stablecoin — USDC by default** from
their own external wallet or exchange account to an address shown in the app.
Supported networks are Polygon (MATIC) and BNB Smart Chain (BSC).

The app itself never accepts card or bank payments, and holds no user-facing
balance or account ledger.

## 2. Transfer lifecycle

1. Sender registers; identity verification (KYC) is mandatory before the first
   transfer and is reviewed by a human operator.
2. Sender selects amount, destination country/city/region, payout method and
   recipient (full name + mobile number, validated against the destination
   country's dialling code).
3. **Pre-transfer compliance gate** runs (section 4). If it blocks, no record
   and no deposit address is created.
4. A deposit address is issued for the transfer, valid for **2 hours**, and
   intended for a **single** transfer only.
5. An on-chain watcher (Tatum) notifies the platform when the deposit arrives.
   The transfer is marked according to the amount actually received —
   `full-paid`, `under-paid` or `over-paid`. An under- or over-payment is
   never reconciled by overriding the status; it is resolved on its merits.
6. Payout agent delivers cash; the transfer is marked delivered and the sender
   receives a delivery notice.

## 3. Custody — current position

**This is the central point for a licensing discussion, and it is stated
plainly rather than minimised.**

At present the platform **generates and stores the private key** for each
deposit address (AES-encrypted at rest) and an automated job **sweeps received
balances to a central wallet controlled by the operator**, from which payout is
funded.

That arrangement constitutes **custody and administration of crypto-assets on
behalf of clients** and **transfer services for crypto-assets** — both CASP
services under MiCA. The operator **does not currently hold CASP authorisation**
from the Bank of Lithuania, and is not listed on the ESMA CASP register.

The purpose of engaging a licensed partner is to end that arrangement.

### Integration readiness

The custody decision has been isolated behind a single interface
(`helpers/custody`) specifically to make the partner integration bounded:

- Each `blockchain_wallet` record carries a `custodian` field — `self` or
  `partner`.
- For `partner` records no private key is stored at all; the record holds only
  the partner's own reference for reconciliation.
- Both sweep paths (deposit webhook and retry job) already exclude
  partner-custodied wallets.
- Selecting `CUSTODY_PROVIDER=partner` fails loudly until a partner adapter is
  implemented, so the system cannot silently keep self-custody under a partner
  label.

What remains for integration is one adapter implementing
`createDepositAddresses()` against the partner's API.

## 4. Compliance controls implemented

### 4.1 Identity verification (KYC)
Mandatory before the first transfer. Collects government ID / passport imagery
and a selfie with ID, reviewed and approved or rejected by an operator with a
recorded reason. Verification can be withdrawn, which re-gates the user.

### 4.2 Sanctions / PEP screening
Both the **sender** (name from the verified KYC record) and the **recipient**
are screened before a transfer is created, against an OpenSanctions-compatible
matching service (self-hostable, or a commercial provider behind the same API).

- Match at or above the block threshold stops the transfer.
- Match in the review band also stops the transfer and raises an alert for
  human review — deliberately conservative, because Arabic-to-Latin
  transliteration produces noisy scores.
- The user-facing message is identical in both cases and does not reveal that a
  list match occurred (tipping-off control).
- A reviewer who clears a false positive prevents it being re-raised for the
  same name.
- **Fails closed**: if the screening provider is unreachable, the transfer is
  stopped and a high-severity alert is raised. Failing open is possible only via
  an explicit configuration flag.

**Current status:** implemented and tested, but gated behind
`COMPLIANCE_SCREENING_ENABLED`, which is **off** pending selection of a list
provider. A verification script (`npm run check:screening`) must pass — proving
the provider is reachable *and* returns real hits — before it is enabled.

### 4.3 Transaction limits
- Per-transfer minimum and maximum, configured per payout method.
- Cumulative caps per sender: daily amount, rolling 30-day amount, daily
  transfer count, and distinct recipients per 30 days. These exist specifically
  to make structuring (splitting a large amount across many small transfers)
  and money-mule fan-out patterns fail.
- All thresholds are environment-configurable, so a partner can impose their own
  values without a code change.

### 4.4 Enhanced due diligence
Transfers at or above a configurable threshold raise an EDD alert for
source-of-funds follow-up. This flags; it does not block.

### 4.5 Audit trail
Every compliance decision — list hit, screening outage, limit breach, EDD
trigger — is written to a `compliance_alert` record carrying the screened name,
match score, matched list entries, severity, and whether the transfer was
stopped. Alerts are resolved (`cleared` / `confirmed`) with a reviewer and
timestamp. **Records are never deleted.**

### 4.6 Other controls
- Account status (`active` / `blocked`); blocked accounts cannot transact.
- Rate limiting on authentication and transfer creation.
- Optional two-factor authentication on login.
- Deposit addresses are single-use and expire after 2 hours.
- Data in transit is encrypted; private keys are encrypted at rest.
- In-app and web account deletion request flow.

### 4.7 Customer-facing disclosure

The public terms, privacy policy and AML summary previously stated that the
platform "does not hold customer funds" and that "payments are completed
externally by users". That did not describe the system as built, which issues a
deposit address it controls and holds the balance until payout. Those
statements have been corrected across the website and the app: the copy now
says plainly that a single-use address is issued and controlled by the
operator, and that funds are held only until that transfer is delivered.

## 5. Known gaps

Stated explicitly so they can be scoped rather than discovered in diligence:

| Gap | Status |
|---|---|
| CASP authorisation | Not held. The reason for this engagement. |
| Screening provider | Integrated but no provider selected; feature off. |
| Ongoing/periodic re-screening of existing customers | Not implemented — screening is at transfer time only. |
| Automated suspicious-activity reporting workflow | Not implemented; alerts are reviewed manually. |
| Travel Rule (TFR 2023/1113) | Data **captured** on every deposit: originator identity from the verified KYC record, originator wallet address decoded from the transaction, beneficiary details, and a flag where self-hosted wallet verification is required. **Transmission** to counterparty providers is not implemented — it needs a Travel Rule messaging network, which is expected to come from the licensed partner. |
| Independent AML audit | Not performed. |
| Written AML/CTF policy approved by management | Public-facing summary exists; a full internal policy does not. |
| Designated compliance officer (MLRO) | Not appointed. |

## 6. Technical summary

| | |
|---|---|
| Backend | Node.js / Express, MongoDB |
| Mobile | Flutter (Android, iOS) |
| Chains | Polygon (MATIC), BNB Smart Chain (BSC) |
| Assets | USDC (default). USDT remains technically supported for non-EEA corridors but is switched off per-jurisdiction from a server-side setting, since it has no MiCA authorisation and cannot be offered in the EEA. |
| On-chain monitoring | Tatum |
| Notifications | Firebase Cloud Messaging |
| Hosting | Single VPS, EU |
| Admin | Separate dashboard with role-restricted access |

## 7. Corridor note

Comprehensive US and EU sanctions on Syria were lifted during 2025, and Syria's
State Sponsor of Terrorism designation was rescinded in August 2026. Targeted
designations against specific individuals and entities remain in force, which
is precisely what the screening control in 4.2 addresses. Counsel should confirm
the current position before launch in any given market.
