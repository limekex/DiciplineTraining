# Rule-based Coach Engine v0 (no backend)

**Type:** feature  
**Area:** Coaching / Logic

## Background

Målet på sikt er AI-genererte meldinger. Før vi kobler på backend trenger vi en enkel, lokal coach-engine som:

- Gir umiddelbare tilbakemeldinger etter dagens innsjekk.
- Bruker `disciplineScore` + dagens status til å velge passende tekst.

## Task

Implementer en enkel **rule-based Coach Engine** som returnerer korte meldinger (1–2 setninger).

### Inputs (minimum)

- `disciplineScore: Int`
- `plannedToTrain: Bool`
- `completedTraining: Bool`
- optional: streak-lengde (kan beregnes senere)

### Output

- `CoachMessage`:
  ```swift
  struct CoachMessage {
      let title: String    // kort overskrift
      let body: String     // 1–2 setninger
      let tone: Tone       // enum: .celebrate, .push, .reframe, .support
  }
  ```

### Behaviour examples

- Høy score (>= 70) and fullført:
  - “Du bygger virkelig momentum nå. Ikke slipp på vanen.”
- Lav score (< 40) and ikke fullført:
  - “Dette er ikke fall. Det er et varselskilt. I morgen kan du snu det med én økt.”
- Planlagt hviledag:
  - “Hvile er en del av disiplin. I morgen stiller vi sterkt igjen.”

### Implementation notes

- Lag egen type, f.eks. `CoachEngine`, med:
  - `func message(for checkIn: DailyCheckIn, disciplineScore: Int) -> CoachMessage`
- Kall denne fra `TodayView` etter at `logCheckIn` er kjørt.
- Vis meldingen i en egen seksjon/card under “Lagre dagens status”.

### Acceptance criteria

- Etter logging av dagens status vises en relevant coach-melding.
- Ulike kombinasjoner av score/planned/completed gir ulik tekst.
- Meldingen er kort, direkte og uten “cheesy” motivasjon.
