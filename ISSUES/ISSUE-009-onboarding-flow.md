# Forbedre OnboardingView med en fullstendig onboarding-flow

**Type:** feature  
**Area:** Onboarding / UX

## Background

Nåværende `OnboardingView` er en enkel placeholder som bare viser "Hello, world!". For å gi nye brukere en god første opplevelse, trenger vi en skikkelig onboarding-flow som:

- Forklarer appens konsept og verdi
- Samler nødvendig brukerinformasjon
- Setter forventninger om hvordan appen fungerer
- Gir brukeren en følelse av å være klar til å begynne

## Task

Implementer en fullstendig onboarding-flow bestående av 3-4 skjermer.

### Foreslåtte skjermer

#### Skjerm 1: Velkommen
- **Tittel**: "Velkommen til Discipline Training"
- **Beskrivelse**: Kort forklaring av appens konsept
  - "Bygg varige treningsvaner gjennom daglig innsjekking og intelligent coaching"
- **Visuelt**: Ikon eller illustrasjon
- **Knapp**: "Kom i gang"

#### Skjerm 2: Hvordan det fungerer
- **Tittel**: "Slik fungerer det"
- **3 hovedpunkter**:
  1. 📝 "Logg din trening daglig" - Registrer planlagte og fullførte økter
  2. 📊 "Følg din fremgang" - Se Discipline Score og historikk
  3. 💬 "Få coaching" - Motta personlige meldinger basert på din aktivitet
- **Knapp**: "Neste"

#### Skjerm 3: Sett opp profil
- **Tittel**: "Fortell oss om deg"
- **Felt**:
  - Navn (TextField)
  - Treningsmål (TextField, f.eks. "Styrke + fysikk")
  - Dager per uke (Picker: 1-7)
  - Erfaringsnivå (Picker: Nybegynner, Trent en stund, Erfaren)
- **Knapp**: "Start min reise"

#### Skjerm 4 (Valgfri): Varsler
- **Tittel**: "Daglig påminnelse?"
- **Beskrivelse**: "Vi kan sende deg en daglig påminnelse om å logge din trening"
- **Toggle**: "Aktiver påminnelser"
- **Tidspunkt-velger** (hvis aktivert)
- **Knapp**: "Fullfør"

### UI/UX-krav

- Bruk `TabView` med `PageTabViewStyle` for å la brukeren sveipe mellom skjermer
- Page indicators nederst
- Følg `Theme.swift` for konsistent styling
- Smooth animasjoner mellom skjermer
- Validering på profilskjermen (navn må fylles ut)

### Implementation notes

- Bruk `@State` for å holde styr på hvilken skjerm brukeren er på
- Samle all profilinformasjon i en lokal `@State var profile: UserProfile?`
- Når brukeren trykker "Start min reise" eller "Fullfør":
  - Kall `appState.completeOnboarding(with: profile)`
  - Hvis varsler er aktivert, kall `NotificationManager.shared.requestAuthorization` og `scheduleDailyReminder`

### Acceptance criteria

- Onboarding-flow består av minst 3 skjermer
- Brukeren kan navigere frem og tilbake mellom skjermer
- Profilinfo blir lagret når onboarding fullføres
- Appen viser `MainView` etter at onboarding er fullført
- Design følger eksisterende tema og føles profesjonelt

## Bonus features (valgfritt)

- Skip-knapp på de første skjermene for brukere som vil komme raskt i gang
- Animerte illustrasjoner eller ikoner
- Progress bar som viser hvor langt i onboarding-prosessen brukeren er
