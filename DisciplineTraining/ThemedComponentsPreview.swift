//
//  ThemedComponentsPreview.swift
//  DisciplineTraining
//
//  Demonstrates all themed components and design system
//

import SwiftUI

struct ThemedComponentsPreview: View {
    @State private var toggleValue = true
    @State private var sliderValue = 50.0
    
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.sectionSpacing) {
                // Header
                VStack(spacing: 12) {
                    Text("Discipline")
                        .font(.largeTitle.bold())
                        .foregroundStyle(Theme.textPrimary)
                    
                    Text("UI Theme Components Preview")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                }
                .padding(.top, Theme.globalPadding)
                
                // Colors Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("COLORS")
                        .font(.caption.bold())
                        .foregroundStyle(Theme.textSecondary)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        ColorRow(name: "Background Primary", color: Theme.backgroundPrimary)
                        ColorRow(name: "Background Card", color: Theme.backgroundCard)
                        ColorRow(name: "Text Primary", color: Theme.textPrimary)
                        ColorRow(name: "Text Secondary", color: Theme.textSecondary)
                        ColorRow(name: "Accent Primary", color: Theme.accentPrimary)
                        ColorRow(name: "Accent Warning", color: Theme.accentWarning)
                        ColorRow(name: "Accent Success", color: Theme.accentSuccess)
                    }
                }
                .themedCard()
                
                // Typography Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("TYPOGRAPHY")
                        .font(.caption.bold())
                        .foregroundStyle(Theme.textSecondary)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Large Title Bold")
                            .font(.largeTitle.bold())
                            .foregroundStyle(Theme.textPrimary)
                        
                        Text("Title 2 Bold")
                            .font(.title2.bold())
                            .foregroundStyle(Theme.textPrimary)
                        
                        Text("Headline")
                            .font(.headline)
                            .foregroundStyle(Theme.textPrimary)
                        
                        Text("Body text with normal weight")
                            .font(.body)
                            .foregroundStyle(Theme.textPrimary)
                        
                        Text("Secondary body text")
                            .font(.body)
                            .foregroundStyle(Theme.textSecondary)
                        
                        Text("Callout style")
                            .font(.callout)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
                .themedCard()
                
                // Discipline Score Display
                VStack(alignment: .leading, spacing: 16) {
                    Text("DISCIPLINE SCORE")
                        .font(.caption.bold())
                        .foregroundStyle(Theme.textSecondary)
                    
                    DisciplineScoreDisplay(score: 87)
                    
                    Text("Basert på gjennomføring siste 14 dager.")
                        .font(.callout)
                        .foregroundStyle(Theme.textSecondary)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                }
                .themedCard()
                
                // Buttons Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("BUTTONS")
                        .font(.caption.bold())
                        .foregroundStyle(Theme.textSecondary)
                    
                    Button("Primary Button") {
                        print("Primary button tapped")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Button("Secondary Button") {
                        print("Secondary button tapped")
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
                .themedCard()
                
                // Coach Messages
                VStack(alignment: .leading, spacing: 16) {
                    Text("COACH MESSAGES")
                        .font(.caption.bold())
                        .foregroundStyle(Theme.textSecondary)
                    
                    CoachMessageCard(
                        message: "Flott jobbet! Du holder linja som en champ. Keep it up!",
                        tone: .success
                    )
                    
                    CoachMessageCard(
                        message: "Det er nå det gjelder. Motivasjonen er borte, men disiplinen holder deg på sporet.",
                        tone: .warning
                    )
                    
                    CoachMessageCard(
                        message: "Husker du målet ditt? Det er derfor du er her.",
                        tone: .neutral
                    )
                }
                .padding(.horizontal, Theme.globalPadding)
                
                // Interactive Components
                VStack(alignment: .leading, spacing: 16) {
                    Text("INTERACTIVE COMPONENTS")
                        .font(.caption.bold())
                        .foregroundStyle(Theme.textSecondary)
                    
                    Toggle("Planen er å trene i dag", isOn: $toggleValue)
                        .tint(Theme.accentPrimary)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Slider Example")
                            .font(.subheadline)
                            .foregroundStyle(Theme.textPrimary)
                        
                        Slider(value: $sliderValue, in: 0...100)
                            .tint(Theme.accentPrimary)
                        
                        Text("\(Int(sliderValue))")
                            .font(.caption)
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
                .themedCard()
                
                // Card Examples
                VStack(alignment: .leading, spacing: 16) {
                    Text("CARD EXAMPLES")
                        .font(.caption.bold())
                        .foregroundStyle(Theme.textSecondary)
                    
                    // Simple card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Dagens innsjekk")
                            .font(.headline)
                            .foregroundStyle(Theme.textPrimary)
                        
                        Text("Registrer din status for dagen")
                            .font(.callout)
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .themedCard()
                    
                    // Stats card
                    HStack(spacing: 20) {
                        VStack(spacing: 8) {
                            Text("12")
                                .font(.title.bold())
                                .foregroundStyle(Theme.accentSuccess)
                            
                            Text("Completed")
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Divider()
                            .background(Theme.textSecondary.opacity(0.3))
                        
                        VStack(spacing: 8) {
                            Text("3")
                                .font(.title.bold())
                                .foregroundStyle(Theme.accentWarning)
                            
                            Text("Missed")
                                .font(.caption)
                                .foregroundStyle(Theme.textSecondary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .themedCard()
                }
                .padding(.horizontal, Theme.globalPadding)
            }
            .padding(.bottom, Theme.sectionSpacing)
        }
        .background(Theme.backgroundPrimary)
        .preferredColorScheme(.dark)
    }
}

// Helper view for color rows
struct ColorRow: View {
    let name: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 40, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Theme.textSecondary.opacity(0.2), lineWidth: 1)
                )
            
            Text(name)
                .font(.subheadline)
                .foregroundStyle(Theme.textPrimary)
            
            Spacer()
        }
    }
}

#Preview {
    ThemedComponentsPreview()
}
