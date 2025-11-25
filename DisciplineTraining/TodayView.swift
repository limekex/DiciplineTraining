//
//  TodayView.swift
//  DisciplineTraining
//
//  Created by Bjørn-Tore Almås on 20/11/2025.
//

import SwiftUI

struct TodayView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var plannedToTrain: Bool = true
    @State private var completedTraining: Bool = false
    @State private var note: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.sectionSpacing) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("I dag")
                            .font(.title2.bold())
                            .foregroundStyle(Theme.textPrimary)
                        
                        Text("Registrer din status for dagen")
                            .font(.callout)
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Check-in card
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Dagens innsjekk")
                            .font(.headline)
                            .foregroundStyle(Theme.textPrimary)
                        
                        Toggle("Planen er å trene i dag", isOn: $plannedToTrain)
                            .tint(Theme.accentPrimary)
                        
                        Toggle("Jeg har fullført dagens økt", isOn: $completedTraining)
                            .tint(Theme.accentPrimary)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notat (valgfritt)")
                                .font(.subheadline)
                                .foregroundStyle(Theme.textSecondary)
                            
                            TextField("Skriv her...", text: $note)
                                .padding(12)
                                .background(Theme.backgroundPrimary)
                                .foregroundStyle(Theme.textPrimary)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .themedCard()
                    
                    // Coach message if available
                    if let message = appState.lastCoachMessage {
                        CoachMessageCard(
                            message: message,
                            tone: determineCoachTone(message: message)
                        )
                    }
                    
                    // Save button
                    Button {
                        appState.logCheckIn(
                            planned: plannedToTrain,
                            completed: completedTraining,
                            note: note.isEmpty ? nil : note
                        )
                    } label: {
                        Text("Lagre dagens status")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Spacer(minLength: Theme.sectionSpacing)
                }
                .padding(Theme.globalPadding)
            }
            .background(Theme.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.dark)
    }
    
    private func determineCoachTone(message: String) -> CoachMessageCard.MessageTone {
        let lowerMessage = message.lowercased()
        if lowerMessage.contains("flott") || lowerMessage.contains("champ") || lowerMessage.contains("bra") {
            return .success
        } else if lowerMessage.contains("nå det gjelder") || lowerMessage.contains("push") {
            return .warning
        } else {
            return .neutral
        }
    }
}
