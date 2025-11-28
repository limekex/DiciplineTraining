# Unit tests for AppState (Discipline Score, streaks, achievements)

**Type:** chore / test  
**Area:** Quality / Core logic

## Background

As business logic grows (Discipline Score, streaks, achievements, coach input), we need tests to avoid regressions.  
`AppState` holds most of this logic and is a good starting point for unit tests.

## Task

Add unit tests that cover:

1. **Discipline Score**
   - Different combinations of completed vs not completed days.
   - Edge cases:
     - No check-ins.
     - Only old check-ins (older than 14 days).
     - Mix of recent and old check-ins.

2. **Streak calculation**
   - Continuous sequence of completed planned days.
   - Breaks correctly when:
     - Planned but not completed.
     - Gaps in dates.
   - Rest days (`plannedToTrain == false`) do not break the streak.

3. **Achievements (if implemented in this sprint)**
   - Unlock badges at expected thresholds.
   - Achievements do *not* re-unlock multiple times.

### Requirements

- Use Xcode’s standard test target (e.g. `Discipline_TrainingTests`).
- Tests should be deterministic and fast.
- Name tests clearly, e.g.:
  - `testDisciplineScore_withNoCheckIns_isZero`
  - `testCurrentStreak_resetsAfterMissedPlannedDay`

### Acceptance criteria

- Test target builds and runs with all tests passing.
- At least:
  - 3–4 tests for Discipline Score.
  - 3–4 tests for streaks.
  - 2+ tests for achievements (if available).
- CI (if added later) can run these tests without additional configuration.
