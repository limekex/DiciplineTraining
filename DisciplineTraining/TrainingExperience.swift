//
//  TrainingExperience.swift
//  DiciplineTraining
//
//  Created by Bjørn-Tore Almås on 20/11/2025.
//


import Foundation
import SwiftUI

/// Hvilken type bruker vi har å gjøre med
enum TrainingExperience: String, CaseIterable, Identifiable, Codable {
    case beginner
    case intermediate
    case advanced
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .beginner: return "Nybegynner"
        case .intermediate: return "Trent en stund"
        case .advanced: return "Erfaren"
        }
    }
}

struct UserProfile: Codable {
    var name: String
    var goal: String        // f.eks. "Styrke + fysikk"
    var daysPerWeek: Int
    var experience: TrainingExperience
}

/// En enkel logg for daglig innsjekk
struct DailyCheckIn: Identifiable, Codable {
    var id = UUID()
    let date: Date
    var plannedToTrain: Bool
    var completedTraining: Bool
    var note: String?
}

final class AppState: ObservableObject {
    // Onboarding
    @AppStorage("isOnboarded") var isOnboarded: Bool = false
    
    @Published var userProfile: UserProfile? {
        didSet {
            save()
        }
    }
    
    // Daglige check-ins
    @Published var checkIns: [DailyCheckIn] = [] {
        didSet {
            save()
        }
    }
    
    // Latest coach message
    @Published var lastCoachMessage: String? = nil

    // Enkel discipline score (0–100) basert på siste 14 dager
    var disciplineScore: Int {
        let calendar = Calendar.current
        let now = Date()
        let twoWeeksAgo = calendar.date(byAdding: .day, value: -14, to: now) ?? now
        
        let recent = checkIns.filter { $0.date >= twoWeeksAgo }
        guard !recent.isEmpty else { return 0 }
        
        let completed = recent.filter { $0.completedTraining }.count
        let total = recent.count
        
        // Unngå deling på null
        guard total > 0 else { return 0 }
        
        let ratio = Double(completed) / Double(total)
        return Int((ratio * 100).rounded())
    }
    
    private let persistenceController: PersistenceController
    
    // Load persisted state
    init(persistenceController: PersistenceController = .shared) {
        self.persistenceController = persistenceController
        
        if let persisted = persistenceController.load() {
            // Viktig: Ikke kall didSet under initialisering
            self._userProfile = Published(initialValue: persisted.userProfile)
            self._checkIns = Published(initialValue: persisted.checkIns)
            self.isOnboarded = persisted.isOnboarded
        }
    }
    
    // MARK: - Intent
    
    func completeOnboarding(with profile: UserProfile) {
        userProfile = profile
        isOnboarded = true
        // Lagring skjer nå automatisk via didSet
    }
    
    func logCheckIn(planned: Bool, completed: Bool, note: String? = nil) {
        let today = Calendar.current.startOfDay(for: Date())
        
        // Hvis vi allerede har en check-in for i dag, oppdater den
        if let index = checkIns.firstIndex(where: {
            Calendar.current.isDate($0.date, inSameDayAs: today)
        }) {
            checkIns[index].plannedToTrain = planned
            checkIns[index].completedTraining = completed
            checkIns[index].note = note
        } else {
            let entry = DailyCheckIn(
                date: today,
                plannedToTrain: planned,
                completedTraining: completed,
                note: note
            )
            checkIns.append(entry)
        }
        // Lagring skjer nå automatisk via didSet
        
        // Generate coach message
        lastCoachMessage = CoachEngine.shared.message(for: self)
    }
    
    // MARK: - Persistence
    
    private func save() {
        persistenceController.save(appState: self)
    }
}
