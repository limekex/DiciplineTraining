# The Discipline Coach – Technical Specification

## 1. One-liner

**The Discipline Coach** is an iOS app that hjelper brukeren å bygge en solid treningsrutine for styrke og estetisk fysikk ved hjelp av en AI-inspirert coach, daglige innsjekker og en tydelig *Discipline Score* i stedet for klassisk “motivasjons-app”.

---

## 2. Goals & Non-goals

### 2.1 Goals (v0.1–v0.2)

- Hjelpe brukeren å:
  - Definere et enkelt, realistisk treningsløfte (antall økter per uke).
  - Gjennomføre daglig/månedlig innsjekk på om økten ble gjort.
  - Se sammenheng mellom **konsistens** og progresjon via Discipline Score.
- Skape en enkel, friksjonsfri daglig loop som kan fullføres på < 30 sek.
- Legge et teknisk fundament for:
  - AI-genererte tilbakemeldinger (senere via backend).
  - Notifikasjoner (lokale i første omgang).
  - Fremtidig sosial funksjon (accountability med andre brukere).

### 2.2 Non-goals (v0.1)

- Ingen ekte treningsplan-generator / avansert programmering.
- Ingen tredjepartsintegrasjoner (Strava, HealthKit osv.) i første versjon.
- Ingen backend-brukere, innlogging eller sky-sync.
- Ingen ekte LLM-kall direkte fra appen (coach er rule-based / stub).

---

## 3. Target user

**Primærbruker:**  
Person (typisk 18–35 år) som allerede trener litt styrke/fysikk, men sliter med:

- å holde en jevn rutine over tid
- å ikke falle av etter 2–3 uker
- å se sammenheng mellom innsats over tid og resultat

Appen antar at brukeren *allerede* vet det grunnleggende om styrketrening.

---

## 4. Core product pillars

1. **Daglig accountability**
   - Morgen: “Hva er planen i dag?”
   - Kveld: “Gjorde du det du sa du skulle?”
2. **Discipline Score**
   - Enkel numerisk score (0–100) basert på gjennomføring siste 14 dager.
   - Skal oppleves som en “kontrakt med deg selv”, ikke som gamification-støy.
3. **Synlig sammenheng mellom vane og resultat**
   - Progress-skjerm som kobler Discipline Score til opplevd fremgang.
4. **Lav friksjon, høy ærlighet**
   - Maks 2–3 taps per dag for å logge status.
   - Tonen i copy er ærlig, direkte og respektfull – ingen “cheesy motivasjon”.

---

## 5. Platform & Tech Stack

- **Platform:** iOS (MVP)
- **Language:** Swift 5.9+
- **UI:** SwiftUI, iOS 16+
- **Architecture:** 
  - App entry i `DisciplineApp.swift`
  - `AppState` som `ObservableObject` injisert via `EnvironmentObject`
  - Feature-baserte views (Onboarding, Today, Progress, Profile)
- **Persistence (v0.1):**
  - Lokalt, JSON-basert lagring av `UserProfile` og `DailyCheckIn` (f.eks. i Application Support).
  - `Codable` modeller.
- **Notifications (v0.2):**
  - Lokale notifications via `UNUserNotificationCenter`.
  - Fast “morgen” og “kveld” innsjekk-tid per bruker.
- **AI / Coach engine (v0.2+):**
  - Rule-based engine lokalt (starter).
  - Senere: REST-API til backend for LLM-genererte meldinger.

---

## 6. Data Model (MVP)

### 6.1 UserProfile

```swift
struct UserProfile: Codable {
    var name: String                // "Athlete" fallback
    var goal: String                // f.eks. "Styrke + estetisk fysikk"
    var daysPerWeek: Int            // forpliktelse: 2–6
    var experience: TrainingExperience
}
```

### 6.2 TrainingExperience

```swift
enum TrainingExperience: String, CaseIterable, Identifiable, Codable {
    case beginner
    case intermediate
    case advanced
    
    var id: String { rawValue }
}
```

### 6.3 DailyCheckIn

```swift
struct DailyCheckIn: Identifiable, Codable {
    let id: UUID
    let date: Date                  // trunkert til dagsnivå
    var plannedToTrain: Bool
    var completedTraining: Bool
    var note: String?
}
```

### 6.4 Discipline Score (derived)

- Input: `checkIns` siste 14 dager.
- Formula (v0.1):

```text
score = completedSessions / totalCheckIns * 100
avrundet til nærmeste heltall
```

- Fremtid: vekting av:
  - hvor “ærlig” brukeren er (planlagt vs ikke planlagt)
  - hvor mange dager på rad man holder streak

---

## 7. Core flows (MVP)

### 7.1 Onboarding

1. Velkomstskjerm med budskap: “Motivasjon varer i timer. Disiplin varer livet ut.”
2. Spørsmål:
   - Hva trener du for? (tekst / preset)
   - Hvor mange dager i uken vil du forplikte deg til? (2–6)
   - Erfaring: nybegynner / trent en stund / erfaren
   - (Optional) navn
3. Commitment-skjerm:
   - Viser avtale (“Jeg forplikter meg til X dager i uka…”)
   - Primærknapp: “Jeg er med” → lagrer `UserProfile` og setter `isOnboarded = true`.

### 7.2 Daglig loop (Today)

- Viser dagens dato og enkel status:
  - Toggle: “Planen er å trene i dag”
  - Toggle: “Jeg har fullført dagens økt”
  - Notatfelt (valgfritt)
- Primærknapp: “Lagre dagens status”
  - Oppdaterer/legger til `DailyCheckIn` for dagens dato.
- Fremtid: AI-coach-tekst under knappen basert på dagens valg + Discipline Score.

### 7.3 Progress

- Viser:
  - Stor numerisk `Discipline Score`.
  - Undertekst: “Basert på siste 14 dager.”
  - Liste eller graf over siste check-ins.
- Fremtid:
  - Swift Charts graf med trend.
  - Filter (7 / 14 / 30 dager).

### 7.4 Profile

- Viser `UserProfile`:
  - Navn, mål, erfaring, dager per uke.
- Fremtid:
  - Mulighet til å justere forpliktelsen (daysPerWeek).
  - Reset / start på nytt.

---

## 8. Architecture details

- **AppState**
  - Single source of truth for:
    - `userProfile: UserProfile?`
    - `checkIns: [DailyCheckIn]`
    - `disciplineScore: Int` (computed)
  - Public intents:
    - `completeOnboarding(with:)`
    - `logCheckIn(planned:completed:note:)`
    - (v0.2) `generateCoachMessage(context:)`
    - (v0.2) `scheduleNotifications()`

- **View Layer**
  - All Views er `struct` + `View`.
  - Ingen nettverkslogikk direkte i Views.
  - Enkel MVVM-light: logikk samles i `AppState` eller dedikerte små helper-typer.

---

## 9. Future roadmap (kort)

- **v0.2**
  - Lokale notifikasjoner for morgen/kveld.
  - Rule-based coach-meldinger basert på:
    - dagens check-in
    - `disciplineScore`
    - streak-lengde
- **v0.3**
  - Backend API for ekte AI-tekst (OpenAI / egen backend).
  - Innlogging og sync.
- **v0.4**
  - Accountability-partner / venneliste.
  - Delte Discipline Scores, “push friend” funksjon.

---

## 10. Risks & Mitigations

- **Risiko:** App føles som enda en logge-app.
  - Tiltak: ekstremt enkel daglig loop + sterk differensiering i språk/konsept (“Discipline vs motivasjon”).
- **Risiko:** For mye teknisk kompleksitet for tidlig.
  - Tiltak: ingen backend i v0.1; alt lokalt; AI kun som enkel engine først.
- **Risiko:** Brukere faller av etter 1–2 uker.
  - Tiltak: tidlig fokus på notifikasjoner, streak-feel og god feedback-tekst.
