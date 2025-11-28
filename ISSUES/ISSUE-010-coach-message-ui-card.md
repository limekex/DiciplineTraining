# Coach message UI card in TodayView

**Type:** feature  
**Area:** Coaching / UI

## Background

A rule-based `CoachEngine` will generate short feedback messages after each daily check-in.  
We now need a clear, consistent **UI card** in `TodayView` to present these messages.

## Task

Design and implement a **Coach Message Card** component and integrate it into `TodayView`.

### Requirements

- Create a reusable SwiftUI component, e.g. `CoachMessageCard`.
- The card should display:
  - Optional small title (e.g. “Coach says” or the `CoachMessage.title`).
  - Main body text (1–2 sentences).
- Visual style:
  - Follows UI Theme guidelines:
    - Uses `Theme.backgroundCard`.
    - Text in `Theme.textPrimary` / `textSecondary`.
    - Accent border or small accent indicator based on `CoachMessage.tone`.
- Placement:
  - Appears below the “Lagre dagens status” button.
  - Shows:
    - The latest message after user logs the current day.
    - A relevant message for today if one already exists when screen opens.

### Integration with Coach Engine

- After `logCheckIn` is called:
  - Generate message via `CoachEngine`.
  - Store last message for today in `AppState` (e.g. `@Published var todayCoachMessage: CoachMessage?`).
- When `TodayView` appears, show existing message if available.

## Implementation notes

- Tone mapping example:
  - `.celebrate` → subtle success accent (e.g. green-ish).
  - `.push` → warm/orange accent.
  - `.support` / `.reframe` → neutral/blue accent.
- Consider simple fade-in animation when a new message appears.

## Acceptance criteria

- Etter logging av dagens status vises en coach-melding i et tydelig kort.
- Ulike kombinasjoner av score/planned/completed gir ulik tekst (avhengig av CoachEngine).
- UI visuelt tilpasset dark fitness-tema og lesbart med Dynamic Type.
