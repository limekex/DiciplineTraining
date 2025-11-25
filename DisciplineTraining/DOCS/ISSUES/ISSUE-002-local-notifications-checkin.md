# Local notifications for daily check-ins

**Type:** feature  
**Area:** Notifications / Habit loop

## Background

Appens kjernehandler er daglig innsjekk. For å støtte vane og disiplin trenger vi påminnelser:

- Morgen: “Hva er planen din i dag?”
- Kveld: “Hvordan gikk det?”

## Task

Legg til støtte for **lokale notifications**:

- Be om tillatelse første gang etter onboarding.
- Planlegg to daglige notifications:
  - Morgen (default f.eks. kl 08:00).
  - Kveld (default f.eks. kl 21:00).

### Requirements

- Bruk `UNUserNotificationCenter`.
- Håndter scenario:
  - Bruker avslår notifications → app skal fortsatt fungere uten crashes.
- Gi enkel UI for å aktivere/deaktivere reminders:
  - Minimum: switch i `ProfileView` eller egen seksjon for “Påminnelser”.

### Implementation notes

- Lag egen `NotificationManager` med:
  - `requestPermissionIfNeeded()`
  - `scheduleDailyNotifications(morning: DateComponents, evening: DateComponents)`
  - `cancelAllNotifications()`
- Kall `scheduleDailyNotifications` etter fullført onboarding og når bruker endrer preferanser.

### Acceptance criteria

- Bruker får notifications på valgt tider (simulator: verifiser via Debug notificatons).
- Slår man av reminders i UI, slettes planlagte notifications.
- App håndterer “denied” status uten feilmeldinger og med tydelig beskjed i UI.
