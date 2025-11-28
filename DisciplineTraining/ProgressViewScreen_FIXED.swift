//
//  ProgressViewScreen.swift
//  DisciplineTraining
//
//  Created by Bjørn-Tore Almås on 20/11/2025.
//

import SwiftUI
import Charts

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
                    
                    // Streak Card
                    StreakCard(currentStreak: appState.currentStreak, longestStreak: appState.longestStreak)
                    
                    // Statistics Grid
                    StatsGrid(appState: appState)
                    
                    // Progress Chart
                    progressChartSection
                    
                    // Insight Card
                    InsightCard(appState: appState)
                    
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
                            ForEach(appState.checkIns.sorted(by: { $0.date > $1.date }).prefix(10)) { checkIn in
                                CheckInRow(checkIn: checkIn)
                                
                                if checkIn.id != appState.checkIns.sorted(by: { $0.date > $1.date }).prefix(10).last?.id {
                                    Divider()
                                        .background(Theme.textSecondary.opacity(0.3))
                                }
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
    
    // MARK: - Progress Chart Section
    
    @ViewBuilder
    private var progressChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("UTVIKLING SISTE 14 DAGER")
                .font(.caption.bold())
                .foregroundStyle(Theme.textSecondary)
            
            let trendData = appState.disciplineTrend(lastDays: 14)
            
            if appState.checkIns.count < 2 {
                // Not enough data - show empty state
                VStack(spacing: 12) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 48))
                        .foregroundStyle(Theme.textSecondary.opacity(0.5))
                    
                    Text("For lite data")
                        .font(.headline)
                        .foregroundStyle(Theme.textPrimary)
                    
                    Text("Logg minst 2 økter for å se progresjon")
                        .font(.callout)
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
            } else {
                // Show chart
                Chart(trendData) { dataPoint in
                    LineMark(
                        x: .value("Dato", dataPoint.date),
                        y: .value("Score", dataPoint.score)
                    )
                    .foregroundStyle(Theme.accentPrimary)
                    .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                    
                    AreaMark(
                        x: .value("Dato", dataPoint.date),
                        y: .value("Score", dataPoint.score)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Theme.accentPrimary.opacity(0.3),
                                Theme.accentPrimary.opacity(0.0)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                .frame(height: 200)
                .chartYScale(domain: 0...100)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: 3)) { value in
                        if let date = value.as(Date.self) {
                            AxisValueLabel {
                                Text(date.formatted(.dateTime.day().month(.narrow)))
                                    .font(.caption)
                                    .foregroundStyle(Theme.textSecondary)
                            }
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading, values: [0, 25, 50, 75, 100]) { value in
                        AxisGridLine()
                            .foregroundStyle(Theme.textSecondary.opacity(0.2))
                        AxisValueLabel {
                            if let intValue = value.as(Int.self) {
                                Text("\(intValue)%")
                                    .font(.caption)
                                    .foregroundStyle(Theme.textSecondary)
                            }
                        }
                    }
                }
                
                Text("Grafen viser discipline score basert på 7-dagers glidende gjennomsnitt.")
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                    .padding(.top, 8)
            }
        }
        .themedCard()
    }
}

// MARK: - Streak Card Component

struct StreakCard: View {
    let currentStreak: Int
    let longestStreak: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("STREAK")
                .font(.caption.bold())
                .foregroundStyle(Theme.textSecondary)
            
            if currentStreak >= 3 {
                // Active streak
                HStack(spacing: 12) {
                    Text("🔥")
                        .font(.system(size: 48))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(currentStreak) dager på rad!")
                            .font(.title2.bold())
                            .foregroundStyle(Theme.accentSuccess)
                        
                        Text("Hold streaken gående!")
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                    }
                    
                    Spacer()
                }
            } else {
                // No active streak
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        Image(systemName: "flame")
                            .font(.system(size: 32))
                            .foregroundStyle(Theme.textSecondary)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Start en ny streak i dag")
                                .font(.headline)
                                .foregroundStyle(Theme.textPrimary)
                            
                            if longestStreak > 0 {
                                Text("Personlig rekord: \(longestStreak) dager")
                                    .font(.subheadline)
                                    .foregroundStyle(Theme.textSecondary)
                            }
                        }
                    }
                }
            }
        }
        .themedCard()
    }
}

// MARK: - Statistics Grid Component

struct StatsGrid: View {
    @ObservedObject var appState: AppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("STATISTIKK (SISTE 30 DAGER)")
                .font(.caption.bold())
                .foregroundStyle(Theme.textSecondary)
            
            if appState.checkIns.isEmpty {
                Text("Ingen data ennå")
                    .font(.body)
                    .foregroundStyle(Theme.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, Theme.cardPadding)
            } else {
                VStack(spacing: 12) {
                    // Row 1
                    HStack(spacing: 12) {
                        StatBox(
                            title: "Fullført",
                            value: "\(appState.totalWorkouts(lastDays: 30)) økter",
                            icon: "checkmark.circle.fill",
                            color: Theme.accentSuccess
                        )
                        
                        StatBox(
                            title: "Completion rate",
                            value: String(format: "%.0f%%", appState.completionRate(lastDays: 30)),
                            icon: "percent",
                            color: appState.completionRate(lastDays: 30) >= 80 ? Theme.accentSuccess : Theme.accentWarning
                        )
                    }
                    
                    // Row 2
                    HStack(spacing: 12) {
                        StatBox(
                            title: "Beste streak",
                            value: "\(appState.longestStreak) dager",
                            icon: "flame.fill",
                            color: Theme.accentPrimary
                        )
                        
                        StatBox(
                            title: "Snitt per uke",
                            value: String(format: "%.1f økter", appState.averageWorkoutsPerWeek(lastDays: 30)),
                            icon: "calendar",
                            color: Theme.accentPrimary
                        )
                    }
                }
            }
        }
        .themedCard()
    }
}

struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                Spacer()
            }
            
            Text(value)
                .font(.title3.bold())
                .foregroundStyle(Theme.textPrimary)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Theme.backgroundPrimary.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Insight Card Component

struct InsightCard: View {
    @ObservedObject var appState: AppState
    
    var insightText: String? {
        guard !appState.checkIns.isEmpty else { return nil }
        
        let completionRate = appState.completionRate(lastDays: 30)
        let currentStreak = appState.currentStreak
        
        // Prioritize insights
        if currentStreak >= 7 {
            return "🎯 Syv dager på rad! Du er i en flow. Hold fokuset og fortsett å levere."
        } else if completionRate >= 80 {
            return "💪 Fantastisk konsistens! Du er på rett vei. Over 80% completion rate er imponerende."
        } else if completionRate < 60 {
            return "⚠️ Du hopper over mange planlagte økter. Vurder å sette et lavere, mer realistisk mål?"
        } else if appState.longestStreak > currentStreak + 3 {
            return "🔥 Du har hatt lengre streaks før (\(appState.longestStreak) dager). Du vet at du kan - kom tilbake!"
        } else {
            return "📈 Fortsett å logge daglig. Jo mer data, jo bedre innsikt og coaching får du."
        }
    }
    
    var body: some View {
        if let insight = insightText {
            VStack(alignment: .leading, spacing: 12) {
                Text("INNSIKT")
                    .font(.caption.bold())
                    .foregroundStyle(Theme.textSecondary)
                
                Text(insight)
                    .font(.body)
                    .foregroundStyle(Theme.textPrimary)
            }
            .themedCard()
        }
    }
}

#Preview {
    ProgressViewScreen()
        .environmentObject(AppState(persistenceController: PersistenceController.shared))
}
