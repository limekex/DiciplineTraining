# Persist AppState (UserProfile + DailyCheckIn)

**Type:** feature  
**Area:** Core / Persistence

## Background

Right now `AppState` holds `userProfile` and `checkIns` only in memory. When the app restarts, all data is lost.  
We need basic local persistence so:

- Onboarding gjøres kun én gang.
- Discipline Score og historikk overlever app restarts.

## Task

Implement a simple persistence layer for:

- `UserProfile`
- `[DailyCheckIn]`

### Requirements

- Use `Codable` models (already in place).
- Store data locally on device (no backend).
- Load persisted data when `AppState` is initialised.
- Save automatically whenever:
  - onboarding fullføres
  - en check-in logges

### Suggested approach

- Create a small type, e.g. `PersistenceController` or `LocalStore`, responsible for reading/writing JSON.
- Use `FileManager` + Application Support directory, or `UserDefaults` for v0.1.
- Inject this controller into `AppState` (constructor injection) to keep app testable.

### Acceptance criteria

- Closing og åpning av appen beholder:
  - profilinfo
  - check-ins
- Ingen crashes dersom lagret data er tom eller korrupt (fallback til tom state).
- Basic unit test:
  - write → read → same number of check-ins and same profile.
