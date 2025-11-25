# Visual progress chart using Swift Charts (optional if Charts is available)

**Type:** feature  
**Area:** Progress / Visualization

## Background

`ProgressViewScreen` viser i dag Discipline Score + liste over check-ins. For å gjøre sammenhengen mellom vane og resultat mer intuitiv, ønsker vi en enkel graf.

## Task

Bruk **Swift Charts** (hvis tilgjengelig i target) til å lage en graf som visualiserer:

- Dagens/siste 14 dagers Discipline Score over tid, eller
- Andel fullførte økter per dag.

### Requirements

- Graf plasseres i `ProgressViewScreen`.
- Skal fungere for korte og lange perioder (fallback til tom state med tekst dersom det er for få datapunkter).
- Interaksjon:
  - Minimum: vis dato + status i en callout når man trykker på et punkt (dersom hensiktsmessig).
- Grafen skal følge UI-guidelines:
  - Bruk accent-farge mot mørk bakgrunn.
  - Legg grafen i et eget card.

### Suggested steps

1. Lag en modell for datapunkt, f.eks.:

   ```swift
   struct DisciplineDataPoint: Identifiable {
       let id = UUID()
       let date: Date
       let score: Int
   }
   ```

2. Lag helper i `AppState`:
   - `func disciplineTrend(lastDays: Int) -> [DisciplineDataPoint]`

3. I `ProgressViewScreen`:
   - Importer `Charts`.
   - Tegn line chart med `Chart(data) { LineMark(...) }`.

### Acceptance criteria

- Grafen viser en meningsfull trend basert på reell state.
- Ingen crashes hvis det ikke finnes data.
- Fargene matcher globalt tema.
