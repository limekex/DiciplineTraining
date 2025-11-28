# Improve onboarding copy and support editing commitment/profile

**Type:** feature  
**Area:** Onboarding / Profile

## Background

Current onboarding flow sets up `UserProfile` and commitment once.  
We need to (1) tighten up the wording to clearly sell the “discipline over motivation” idea, and  
(2) allow the user to adjust their commitment later if life changes.

## Task

1. **Revise onboarding copy**
   - Sharpen the text on:
     - Welcome screen.
     - Commitment screen.
   - Emphasise:
     - “Motivasjon varer i timer. Disiplin varer livet ut.”
     - At appen vil holde brukeren ansvarlig for det de lover.

2. **Enable editing of profile/commitment**
   - From `ProfileView`, add an “Edit” button.
   - Reuse parts of onboarding UI (or build a simpler editor) to change:
     - `daysPerWeek`
     - `goal` text
     - `experience`
   - Optional: allow editing `name`.

### Requirements

- Editing should update `userProfile` in `AppState`.
- If reminders/notifications are implemented, consider:
  - Optionally prompting to adjust reminders based on new daysPerWeek (future enhancement).
- Persist updated profile with the existing persistence layer.

## Acceptance criteria

- Onboarding copy is updated and lives entirely in `OnboardingView` / `CommitmentView`.
- User can open Profile → Edit → change commitment and see it reflected in:
  - Profile screen.
  - Any UI that references `daysPerWeek` (e.g., Settings).
- No crashes when editing and saving profile.
