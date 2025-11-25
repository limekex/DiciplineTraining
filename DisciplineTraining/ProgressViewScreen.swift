//
//  MainView.swift
//  DisciplineTraining
//
//  Created by Bjørn-Tore Almås on 20/11/2025.
//


import SwiftUI

import SwiftUI

struct ProgressViewScreen: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.sectionSpacing) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Fremgang")
                            .font(.title2.bold())
                            .foregroundStyle(Theme.textPrimary)
                        
                        Text("Din utvikling over tid")
                            .font(.callout)
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Discipline Score Card
                    VStack(spacing: 16) {
                        DisciplineScoreDisplay(score: appState.disciplineScore)
                        
                        Text("Basert på gjennomføring siste 14 dager.")
                            .font(.callout)
                            .foregroundStyle(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .themedCard()
                    
                    // Recent check-ins
                    VStack(alignment: .leading, spacing: 16) {
                        Text("SISTE CHECK-INS")
                            .font(.caption.bold())
                            .foregroundStyle(Theme.textSecondary)
                        
                        if appState.checkIns.isEmpty {
                            Text("Ingen registreringer ennå")
                                .font(.body)
                                .foregroundStyle(Theme.textSecondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, Theme.cardPadding)
                        } else {
                            ForEach(appState.checkIns.sorted(by: { $0.date > $1.date })) { check in
                                CheckInRow(checkIn: check)
                            }
                        }
                    }
                    .themedCard()
                    
                    Spacer(minLength: Theme.sectionSpacing)
                }
                .padding(Theme.globalPadding)
            }
            .background(Theme.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.dark)
    }
}

struct CheckInRow: View {
    let checkIn: DailyCheckIn
    
    var body: some View {
        HStack(spacing: 12) {
            // Status indicator
            Circle()
                .fill(checkIn.completedTraining ? Theme.accentSuccess : Theme.accentWarning)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(checkIn.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.body)
                    .foregroundStyle(Theme.textPrimary)
                
                Text(checkIn.completedTraining ? "Økt gjennomført" : "Ingen økt")
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
            }
            
            Spacer()
            
            if let note = checkIn.note {
                Text(note)
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                    .lineLimit(2)
                    .frame(maxWidth: 100, alignment: .trailing)
            }
        }
        .padding(.vertical, 8)
    }
}
