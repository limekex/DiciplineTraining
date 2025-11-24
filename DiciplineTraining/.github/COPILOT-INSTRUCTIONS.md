# Copilot Instructions – The Discipline Coach (iOS)

These instructions tell GitHub Copilot **how to assist in this repo**.

## 1. Project context

- This repository contains an iOS app called **Discipline** (working title: “Discipline Training”).
- The app is written in **Swift** using **SwiftUI** and targets **iOS 16+**.
- The goal is to support a daily discipline loop:
  - Onboarding with a commitment (days per week).
  - Daily check-ins for training.
  - A derived **Discipline Score** (0–100) based on recent behaviour.
  - Simple progress and profile views.

Core files:

- `DisciplineApp.swift` – app entry point
- `AppState.swift` – shared `ObservableObject` with app state and logic
- `OnboardingView.swift`
- `MainView.swift`
- `TodayView.swift`
- `ProgressViewScreen.swift`
- `ProfileView.swift`

## 2. Code style & architecture

When generating Swift/SwiftUI code:

1. **Use SwiftUI idioms**
   - Prefer structs over classes for views.
   - Use `@EnvironmentObject` to access `AppState` in feature views.
   - Use computed properties and small helper methods inside views for clarity.

2. **Keep logic out of views when it grows**
   - Small, view-specific helpers can live in the view.
   - Anything that touches persistence, networking or shared behaviour should go into:
     - `AppState`, or
     - new dedicated types (e.g. `CoachEngine`, `PersistenceController`).

3. **Naming**
   - Views: `XxxView`, `XxxScreen` sparingly (we already have `ProgressViewScreen`).
   - Data models: nouns (`UserProfile`, `DailyCheckIn`).
   - Methods in `AppState`: verbs that describe intent (`logCheckIn`, `completeOnboarding`).

4. **Optionality**
   - Prefer non-optional properties when possible.
   - If something can be missing (e.g. `userProfile` before onboarding), keep it optional but try to unwrap early in views.

5. **Comments**
   - Use short comments to explain *why*, not *what*.
   - Avoid over-commenting obvious SwiftUI code.

## 3. UI & UX guidelines (high level)

- Use a **dark-ish fitness style** with strong contrast, inspired by modern fitness AI dashboards:
  - Dark backgrounds, subtle gradients.
  - Accent color for CTAs and Discipline Score.
- Layout:
  - Generous spacing.
  - Clear visual hierarchy with large titles and clear primary buttons.
- Components:
  - Rounded rectangles, medium/large corner radius.
  - Use SF Symbols when appropriate.

(See the “UI Theme & Design Guidelines” issue/document for more detailed tokens and colours.)

## 4. What Copilot should prioritise

When suggesting code, Copilot should:

1. **Favour clarity over cleverness**
   - Readable code > “smart” one-liners.

2. **Preserve and reuse existing patterns**
   - If a similar pattern exists in the repo (e.g. how `AppState` methods are declared), follow it.
   - Prefer adding small extensions rather than duplicating logic.

3. **Prepare for future AI backend**
   - When adding “coach message” logic, use a separate type or at least separate methods (`generateCoachMessage(context:)`) so it can later be replaced by a network call.

4. **Accessibility**
   - Use Dynamic Type-friendly text styles (`.title`, `.headline`, `.body`).
   - Ensure tap targets are large enough (min 44x44).

## 5. Files & structure

When Copilot helps create new files:

- Put feature-specific views under a `Features` group if it exists (e.g. `Features/Onboarding/OnboardingView.swift`).
- Non-UI helpers (persistence, coach engine, utilities) go under `Core` or `Services`.

## 6. Tests (later)

- When test targets are present, generate unit tests with:
  - Focus on pure logic (e.g. `disciplineScore` calculations, check-in processing).
  - Avoid heavy UI tests unless explicitly requested.

## 7. Things Copilot should NOT do unless asked

- Add new third-party dependencies.
- Introduce Combine, async/await networking, or complex architecture (VIPER, RIBs, etc) unless requested.
- Add login/auth flows or backend integrations by assumption.

When in doubt, prefer **small, composable helpers** that fit the existing SwiftUI + `AppState` structure.
