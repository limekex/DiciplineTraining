# Discipline streaks and simple achievement badges

**Type:** feature  
**Area:** Habit loop / Gamification

## Background

The app already has a Discipline Score based on the last 14 days. To make consistency feel more tangible and rewarding, we want:

- Streaks (number of consecutive days with completed training when planned).
- Simple badges/achievements for key milestones.

This should support the “discipline over motivation” narrative without turning the app into a cartoonish game.

## Task

Implement:

1. **Streak calculation**
   - Daily continuous streak (number of days in a row with `completedTraining == true` AND `plannedToTrain == true`).
   - Separate from Discipline Score.

2. **Basic achievements**
   - Example badges:
     - `3-day streak` – “Momentum”
     - `7-day streak` – “First week locked in”
     - `14-day streak` – “Two weeks of discipline”
     - `30 check-ins total` – “Showing up”

3. **Display**
   - Show current streak and last earned badge in `ProgressViewScreen` (or a sub-section).
   - Optional: small indicator in `TodayView` (e.g. “Streak: 4 days”).

## Requirements

- Streak must be based on calendar days, using local device time.
- Missing a planned training day (planned = true, completed = false) breaks the streak.
- Check-ins on unplanned rest days do NOT break the streak.
- Achievements should be:
  - Derived from data (no manual toggling).
  - Persisted so unlocking happens only once per badge (even if conditions are met many times).

## Implementation notes

- Add streak computation helper to `AppState`, e.g.:
  - `var currentStreak: Int { ... }`
- Add a simple `Achievement` model (enum or struct) and a list of unlocked ones.
- Consider using `@Published var unlockedAchievements: [Achievement]` for UI updates.

## Acceptance criteria

- Current streak updates correctly when:
  - User logs a completed training day.
  - User logs a missed planned training day (streak resets).
- At least 3 badges can be unlocked and are visible in the UI.
- Restarting the app preserves unlocked achievements and streak data (assuming persistence is implemented).
