# Forbedre ProgressViewScreen med bedre innhold og innsikt

**Type:** feature  
**Area:** Progress / Analytics / UX

## Background

Nåværende `ProgressViewScreen` viser:
- Discipline Score (stort tall)
- Progress chart (når det er nok data)
- Liste over siste check-ins

Dette er en god start, men skjermen kan bli mer verdifull ved å gi brukeren dypere innsikt i deres treningsvaner og fremgang.

## Task

Utvide `ProgressViewScreen` med mer meningsfull statistikk, innsikt og motiverende innhold.

### Nye komponenter å legge til

#### 1. Streak-kort
Vise brukerens nåværende streak (påfølgende dager med fullført trening):

- **Hvis aktiv streak >= 3 dager**:
  - "🔥 X dager på rad!"
  - Motiverende tekst: "Hold streaken gående!"
- **Hvis ingen aktiv streak**:
  - "Start en ny streak i dag"
  - Vis lengste streak tidligere: "Personlig rekord: X dager"

#### 2. Statistikk-kort (siste 30 dager)
Grid med nøkkelstatistikk:

```
┌─────────────────────┬─────────────────────┐
│  Fullført           │  Completion rate    │
│  12 økter           │  85%                │
└─────────────────────┴─────────────────────┘
┌─────────────────────┬─────────────────────┐
│  Beste streak       │  Gjennomsnitt/uke   │
│  7 dager            │  4.2 økter          │
└─────────────────────┴─────────────────────┘
```

#### 3. Ukeoversikt (valgfritt)
Kalender-view som viser siste 4 uker med fargekodet status:

- ✅ Grønn: Fullført trening
- ⚠️ Oransje: Planlagt, men ikke fullført
- ⭕ Grå: Ingen trening planlagt
- Tom: Ingen data

#### 4. Innsikt-seksjonen
Små, kontekstuelle tips basert på data:

- **Hvis completion rate < 60%**: "Du hopper over mange planlagte økter. Prøv å sette lavere mål?"
- **Hvis completion rate > 80%**: "Fantastisk konsistens! Du er på rett vei."
- **Hvis lange pauser mellom økter**: "Du pleier å ta lengre pauser på [dag]. Planlegg ekstra godt den dagen."

#### 5. Mål-tracking (fremtidig utvidelse)
Placeholder for fremtidig funksjonalitet:
- "Sett deg et mål" (f.eks. "Tren 4x/uke i 4 uker")
- Vis fremgang mot målet

### UI/UX-krav

- Alle nye kort følger `Theme.swift` og `.themedCard()`
- Bruk ikoner og farger for visuell feedback
  - `Theme.accentSuccess` for positive tall
  - `Theme.accentWarning` for forbedringsområder
- Animasjoner når tall oppdateres (valgfritt)
- Responsivt design - funger på ulike skjermstørrelser

### Implementation notes

1. **Opprett nye computed properties i `AppState`**:
   ```swift
   var currentStreak: Int { ... }
   var longestStreak: Int { ... }
   var completionRateLast30Days: Double { ... }
   var totalWorkoutsLast30Days: Int { ... }
   var averageWorkoutsPerWeek: Double { ... }
   ```

2. **Opprett nye View-komponenter**:
   - `StreakCard.swift` - Viser aktiv streak
   - `StatsGrid.swift` - Grid med statistikk
   - `InsightCard.swift` (valgfritt) - Kontekstuelle tips

3. **Oppdater `ProgressViewScreen.swift`**:
   - Legg til nye kort mellom Discipline Score og Progress Chart
   - Bruk `VStack` med `Theme.sectionSpacing`

### Acceptance criteria

- Streak-kort vises øverst og oppdateres live
- Statistikk-grid viser korrekte tall basert på reell data
- Ingen crashes hvis det mangler data (fallback til "Ingen data ennå")
- Design er konsistent med resten av appen
- Skjermen gir brukeren verdifull innsikt, ikke bare tall

## Bonus features (valgfritt)

- Pull-to-refresh for å oppdatere data
- Export-funksjon (f.eks. CSV av alle check-ins)
- Sammenligning med forrige måned
- Achievements/badges (f.eks. "10-dagers streak", "Første måned fullført")
- Interaktiv kalendervisning hvor brukeren kan trykke på en dag for å se detaljer
