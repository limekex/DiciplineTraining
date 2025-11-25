//
//  ProgressViewScreen.swift
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
