# Settings & preferences screen (reminder times, basic options)

**Type:** feature  
**Area:** Settings / Notifications / UX

## Background

Local notifications for daily check-ins will be implemented separately. We now need a simple UI so users can:

- Enable/disable reminders.
- Adjust morning/evening reminder times.
- See what they have committed to (days per week).

## Task

Create a **Settings / Preferences** screen and integrate it in the app.

### Requirements

- New view: `SettingsView` (or integrated into `ProfileView` as a section).
- Options:
  - Toggle: “Daily reminders” (on/off).
  - Time picker: “Morning reminder time”.
  - Time picker: “Evening reminder time”.
  - Read-only display of commitment: “You committed to X training days per week”.
- Changes should:
  - Update a preferences model stored in `AppState` (e.g. `AppPreferences`).
  - Trigger re-scheduling of local notifications when:
    - Times change
    - Global reminder toggle is turned on/off

### Implementation notes

- Add a simple `AppPreferences` struct (Codable) with:
  - `var remindersEnabled: Bool`
  - `var morningReminder: DateComponents`
  - `var eveningReminder: DateComponents`
- Persist preferences together with other state (when persistence is in place).
- Use `NavigationLink` from Profile tab to open Settings, or merge Settings as a section in Profile.

## Acceptance criteria

- User can toggle reminders and pick times without crashes.
- If notifications are implemented:
  - Switching reminders off cancels scheduled notifications.
  - Changing times reschedules notifications.
- Preferences are remembered across app restarts (once persistence is implemented).
