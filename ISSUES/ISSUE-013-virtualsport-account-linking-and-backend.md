# Account linking with virtualsport.online (WordPress backend)

**Type:** feature  
**Area:** Backend integration / Sync / Accounts

## Background

The Discipline app should be able to optionally connect to a user account on **virtualsport.online** (WordPress).  
Goals:

- Gi brukeren mulighet til å:
  - Registrere / logge inn på virtualsport.online fra appen.
  - Knytte appen til sin web-konto.
  - Synkronisere grunnleggende data (profil + discipline data) til ekstern lagring.
- Legge teknisk grunnlag for senere funksjoner:
  - Ekstra features låst opp for registrerte brukere.
  - Integrasjon mot Virtual Sports-ruter, treningsplaner osv.

## Scope (v1)

- Énveis synk (app → backend) av:
  - `UserProfile` (mål, experience, daysPerWeek).
  - Aggregert discipline-status (score, streak, antall check-ins).
- Autentisering via WordPress-bruker:
  - Brukere registrerer seg / logger inn i nettleser (in-app Safari / SFSafariViewController).
  - Appen mottar en **API-token** (JWT eller tilsvarende) som kan brukes mot et tilpasset WP REST API-endepunkt.

## Task

### 1. WordPress backend (virtualsport.online)

Implementer en liten “bridge” som enten et eget plugin eller som del av eksisterende TVS/VS-plugin.

**a) Custom REST namespace/endpoints**

- Namespace, f.eks.: `tvs/v1`.
- Endpoints minimum:

  1. `POST /tvs/v1/app/register-device`
     - Auth: krever gyldig bruker (JWT eller WP nonce + cookie).
     - Input:
       - `device_id` (UUID generert av appen)
       - `platform` (iOS)
       - Optional: app-versjon
     - Output:
       - `app_token` – token som appen lagrer og bruker ved senere kalls.
  
  2. `POST /tvs/v1/app/sync-discipline`
     - Auth: via `app_token` i header (f.eks. `Authorization: Bearer <token>`).
     - Input (JSON):
       - `device_id`
       - `user_profile` (serialisert `UserProfile`)
       - `discipline_score`
       - `current_streak`
       - `total_checkins`
       - `last_checkins` (valgfritt, f.eks. siste 14 dager)
     - Server lagrer data som:
       - egen custom table **eller**
       - `usermeta` / custom post type `tvs_discipline_log`.

**b) Authentication strategy**

- Bruk eksisterende WordPress login-system.
- Anbefalt:

  - Installer/bruk et JWT-bibliotek (eller eksisterende løsning) for WP REST API.  
  - Lag hjelpefunksjon som:
    - Verifiserer JWT → finner WP user → validerer at `app_token` tilhører bruker.

### 2. Web flow for konto-registrering

På virtualsport.online:

- Lag en enkel landingsside, f.eks. `/app-connect`, som:
  - Forklarer at brukeren kobler Discipline-appen til kontoen sin.
  - Lar brukeren:
    - Logge inn (standard WP login).
    - Opprette ny konto hvis de ikke har en.
  - Etter login:
    - Genererer/viser en “Koble til app”-knapp som:
      - Trigger `POST /tvs/v1/app/register-device` basert på en query param fra appen (`device_id`).
      - Redirecter tilbake til en app-URL (custom scheme eller universal link) med `app_token` i query.

### 3. iOS app integration

- I appen:

  1. Ny seksjon i `ProfileView` eller `SettingsView`:
     - Knapp: “Koble til virtualsport.online”.
  2. Når brukeren trykker:
     - Generer `device_id` (og lagre i `AppState` / keychain).
     - Åpne `SFSafariViewController` mot URL:
       - `https://virtualsport.online/app-connect?device_id=<device_id>`
  3. Håndter redirect tilbake til appen (Universal Link / custom URL scheme):
     - Parse `app_token`.
     - Lagre sikkert (Keychain).
     - Markere i state at konto er koblet (f.eks. `isLinkedToVirtualSport = true`).

### 4. Sync job fra appen

- Når bruker er koblet:

  - Etter hver fullført innsjekk eller ved app-start, kall:
    - `POST /tvs/v1/app/sync-discipline` med dagens state.
  - Bruk enkel retry-strategi ved nettverksfeil.

## Requirements

- Alle HTTP-kall fra app → backend må:
  - Håndtere timeouts / feil med tydelig, stille fallback (ikke krasj).
- Ingen sensitiv helsedata utover det som allerede finnes i appen (ingen detaljerte treningslogger nødvendig i v1).
- Backend-kode må ligge i et eget WP-plugin (f.eks. `tvs-app-bridge`) med:
  - Klar `README`.
  - Hook for å fjerne brukerens app-tilgang hvis konto slettes.

## Acceptance criteria

- Bruker kan:
  - Trykke “Koble til virtualsport.online” i appen.
  - Logge inn / registrere konto i nettleser.
  - Returnere til appen og være markert som tilkoblet.
- Etter tilkobling:
  - Minst én sync-operasjon (manuelt trigget eller automatisk) oppdaterer data på virtualsport.online.
- Backend-endepunkt kan verifiseres via f.eks. `curl` / Postman, og tilhører autentisert WP-bruker.
