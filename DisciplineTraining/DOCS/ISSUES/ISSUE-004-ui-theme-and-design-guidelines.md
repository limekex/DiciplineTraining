# UI Theme & Design Guidelines

**Type:** design / documentation  
**Area:** Global UI / Design System

## Goal

Definere en enkel, konsistent visuell stil for Discipline-appen, inspirert av moderne fitness/AI-dashboards:

- Mørk bakgrunn
- Sterke, men kontrollerte accent-farger
- Fokus på progresjon, tall og kortfattede budskap

Resultatet skal være en **dokumentside** + evt. små SwiftUI-eksempler som kan brukes som referanse for videre utvikling.

---

## 1. Colour system (proposal)

> Faktiske hex-verdier kan justeres senere; dette er en start.

- **Background**
  - `backgroundPrimary`: dyp mørk grå/svart – f.eks. `#05060A`
  - `backgroundCard`: litt lysere – `#111321`
- **Text**
  - `textPrimary`: hvit – `#FFFFFF`
  - `textSecondary`: lys grå – `#A0A3B1`
- **Accent**
  - `accentPrimary`: elektrisk blå / cyan – f.eks. `#42E6FF`
  - `accentWarning`: varm oransje – `#FF8A4A`
  - `accentSuccess`: neon grønn – `#6BFFB5`

### SwiftUI example

```swift
struct Theme {
    static let backgroundPrimary = Color(red: 5/255, green: 6/255, blue: 10/255)
    static let backgroundCard    = Color(red: 17/255, green: 19/255, blue: 33/255)
    static let textPrimary       = Color.white
    static let textSecondary     = Color(red: 160/255, green: 163/255, blue: 177/255)
    static let accentPrimary     = Color(red: 66/255, green: 230/255, blue: 255/255)
}
```

---

## 2. Typography

- **App title / storey headings**
  - `.largeTitle` / `.title.bold()`
- **Screen titles**
  - `.title2.bold()`
- **Key metrics (Discipline Score)**
  - Custom: large rounded font (`system(size: 64, weight: .bold, design: .rounded)`)
- **Body**
  - `.body` og `.callout` med `.foregroundStyle(Theme.textSecondary)` for sekundærtekst.

Guideline:

- Bruk maks 2–3 nivåer pr. skjerm.
- Viktigste tall/ord skal visuelt “rope” – alt annet skal støtte.

---

## 3. Components

### 3.1 Cards

- Bruk `RoundedRectangle(cornerRadius: 18–24)` som base.
- Background: `Theme.backgroundCard`.
- Innhold:
  - Tittel (small uppercase eller `headline`).
  - Hovedinnhold (tall, tekst, toggles).
- Lett skygge eller `overlay`-stroke i svak lysere farge.

### 3.2 Primary Button

- Full width der det gir mening.
- Height ~ 48–52 pt.
- Background: `accentPrimary`.
- Text: `textPrimary`, bold.

SwiftUI snippet:

```swift
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Theme.accentPrimary.opacity(configuration.isPressed ? 0.8 : 1.0))
            .foregroundStyle(.black)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}
```

---

## 4. Layout & spacing

- Global padding: minst 16 pt på kanter.
- Vertikal spacing mellom seksjoner: 16–24 pt.
- Scrollbare skjermer skal ha tydelig “seksjonsinndeling”:
  - Tittel
  - Kort forklarings-tekst
  - Card med interaksjon

---

## 5. Screen-specific guidelines

### 5.1 Today

- Ett tydelig kort på toppen: “Dagens innsjekk”.
- Tydelig primærknapp nederst: “Lagre dagens status”.
- Coach-melding vises som eget card: tonefarge kan varieres:
  - `accentSuccess` for positive meldinger.
  - `accentWarning` for “push”.

### 5.2 Progress

- Stor Discipline Score øverst midtjustert.
- Under: kort tekst som forklarer scoren.
- Liste/graf under i card-style.

---

## 6. Deliverable

- Denne markdown-filen i repo (`docs/UI-Theme-Guidelines.md` eller lignende).
- Minimum én SwiftUI-view (f.eks. `ThemedCardPreview`) som demonstrerer:
  - Background
  - Card
  - Primary button
  - Discipline Score tall.
