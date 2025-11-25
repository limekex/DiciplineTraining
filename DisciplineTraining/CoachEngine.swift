import Foundation

final class CoachEngine {
    static let shared = CoachEngine()
    private init() {}

    func message(for appState: AppState) -> String {
        let score = appState.disciplineScore
        // Simple rule-based messages
        if score >= 80 {
            return "Fantastisk! Du har holdt det gående — fortsett sånn!"
        } else if score >= 60 {
            return "Godt jobbet — du er på rett vei. Hold fokus på vanene dine." 
        } else if score >= 40 {
            return "Bra innsats, men vi kan forbedre oss noe. Klar for en liten oppgave i dag?"
        } else {
            return "La oss starte enkelt i dag. Et lite mål er bedre enn ingen plan." 
        }
    }
}
