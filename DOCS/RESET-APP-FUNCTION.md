# Reset App Function - Brukerinstruksjoner

## Oversikt

En `resetApp()` funksjon er lagt til i `AppState` for å gjøre det enkelt å teste onboarding-flowen og starte appen fra scratch.

## Hva gjør `resetApp()`?

Funksjonen:
1. Sletter all brukerdata (profil, check-ins, coach-meldinger)
2. Setter `isOnboarded = false` slik at onboarding vises på nytt
3. Sletter all lagret data fra disk
4. Avbryter alle planlagte varsler
5. Logger at appen har blitt resatt

## Hvordan bruke den

### Metode 1: Via ProfileView (anbefalt for testing)

Legg til en debug-seksjon nederst i `ProfileView.swift`:

```swift
// Debug section (only visible in debug builds)
#if DEBUG
VStack(alignment: .leading, spacing: 16) {
    Text("DEBUG")
        .font(.caption.bold())
        .foregroundStyle(Theme.textSecondary)
    
    Button {
        appState.resetApp()
    } label: {
        HStack {
            Image(systemName: "arrow.counterclockwise")
            Text("Reset app (slett all data)")
        }
        .frame(maxWidth: .infinity)
    }
    .buttonStyle(SecondaryButtonStyle())
    
    Text("⚠️ Dette sletter all data og starter onboarding på nytt")
        .font(.caption)
        .foregroundStyle(Theme.accentWarning)
}
.themedCard()
#endif
```

Dette vises kun når appen kjøres i debug-modus, ikke i production-builds.

### Metode 2: Via Xcode Console

Når du kjører appen fra Xcode, kan du kalle funksjonen direkte fra debuggeren:

1. Sett et breakpoint hvor som helst i koden
2. Når appen stopper ved breakpointet, skriv i konsollen:
   ```
   po appState.resetApp()
   ```
3. Trykk `Continue` for å la appen fortsette

### Metode 3: Midlertidig knapp (for rask testing)

Legg til en midlertidig knapp i `MainView` eller `TodayView`:

```swift
Button("🔄 RESET APP") {
    appState.resetApp()
}
.buttonStyle(PrimaryButtonStyle())
```

**Husk å fjerne denne knappen før production!**

## Advarsel

⚠️ `resetApp()` sletter **ALL** brukerdata permanent. Det er ingen "undo"-funksjon.

Bruk denne funksjonen kun for:
- Testing av onboarding-flow
- Debugging
- Utviklingsformål

**IKKE** publiser en produksjonsversjon av appen med en lett tilgjengelig reset-knapp!

## Fremtidig forbedring

For en mer bruker vennlig løsning i fremtiden, vurder å legge til:
- En bekreftelsesdialog før reset
- Mulighet for å eksportere data før reset
- En "soft reset" som bare nullstiller onboarding, men beholder historikken
