import Foundation

final class CoachEngine {
    static let shared = CoachEngine()
    private init() {}

    func message(for appState: AppState) -> String {
        let score = appState.disciplineScore
        
        guard let todaysCheckIn = appState.getTodaysCheckIn() else {
            return "Velkommen tilbake! Klar for dagens utfordring?"
        }
        
        let planned = todaysCheckIn.plannedToTrain
        let completed = todaysCheckIn.completedTraining
        let streak = calculateStreak(from: appState.checkIns)
        
        return generateMessage(
            score: score,
            planned: planned,
            completed: completed,
            streak: streak
        )
    }
    
    // MARK: - Private Helpers
    
    private func calculateStreak(from checkIns: [DailyCheckIn]) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        var streak = 0
        var currentDate = today
        
        // Count backwards from today
        while true {
            if let checkIn = checkIns.first(where: { calendar.isDate($0.date, inSameDayAs: currentDate) }),
               checkIn.completedTraining {
                streak += 1
                guard let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDate) else { break }
                currentDate = previousDay
            } else {
                break
            }
        }
        
        return streak
    }
    
    private func generateMessage(score: Int, planned: Bool, completed: Bool, streak: Int) -> String {
        // High score scenarios (>= 70)
        if score >= 70 {
            if completed {
                if streak >= 5 {
                    return "🔥 \(streak) dager på rad! Du er i flytsonen. Dette er hva disiplin ser ut."
                } else if streak >= 3 {
                    return "Solid! \(streak) dager i strekk. Momentum bygger seg – fortsett å kjøre."
                } else {
                    return "Flott! Du holder høy konsistens. Dette er hvordan vi bygger varige vaner."
                }
            } else if planned {
                return "Du har god form, men i dag ble det ikke trening. En dag av sporet er OK – bare ikke to."
            } else {
                return "Hvile er en del av disiplin. Med en score på \(score)% kan du tillate deg det."
            }
        }
        
        // Medium score scenarios (40-69)
        else if score >= 40 {
            if completed {
                if streak >= 2 {
                    return "Der ja! \(streak) på rad. Du klatrer oppover igjen. Hold den rytmen."
                } else {
                    return "Bra jobbet! En fullført økt når scoren er \(score)% er akkurat det vi trenger."
                }
            } else if planned {
                return "Du planla å trene, men det ble ikke noe av det. Score på \(score)% – dette er et varsel. I morgen må vi levere."
            } else {
                return "Hviledag på \(score)%? Greit nok, men vi må snu trenden raskt. I morgen stiller vi."
            }
        }
        
        // Low score scenarios (< 40)
        else {
            if completed {
                if streak >= 2 {
                    return "Endelig! \(streak) dager i strekk. Dette er vendepunktet – fortsett nå."
                } else {
                    return "Godt! Dette er første skritt tilbake. Én økt om gangen, ingen panikk."
                }
            } else if planned {
                return "Score \(score)% og hoppet over trening i dag. Dette er nå det gjelder. I morgen – ingen unnskyldninger."
            } else {
                return "Score på \(score)%. Hviledag eller ikke, vi må snart tilbake på sporet. La oss sette opp en enkel plan for i morgen."
            }
        }
    }
}
