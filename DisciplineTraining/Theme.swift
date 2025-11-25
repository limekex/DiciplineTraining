//
//  Theme.swift
//  DisciplineTraining
//
//  UI Theme & Design System
//

import SwiftUI

/// Global theme for the Discipline Training app
/// Based on modern fitness/AI dashboard design with dark backgrounds and strong accent colors
struct Theme {
    // MARK: - Background Colors
    
    /// Deep dark grey/black for primary background (#05060A)
    static let backgroundPrimary = Color(red: 5/255, green: 6/255, blue: 10/255)
    
    /// Slightly lighter background for cards (#111321)
    static let backgroundCard = Color(red: 17/255, green: 19/255, blue: 33/255)
    
    // MARK: - Text Colors
    
    /// Primary text color - white (#FFFFFF)
    static let textPrimary = Color.white
    
    /// Secondary text color - light grey (#A0A3B1)
    static let textSecondary = Color(red: 160/255, green: 163/255, blue: 177/255)
    
    // MARK: - Accent Colors
    
    /// Primary accent - electric blue/cyan (#42E6FF)
    static let accentPrimary = Color(red: 66/255, green: 230/255, blue: 255/255)
    
    /// Warning/push accent - warm orange (#FF8A4A)
    static let accentWarning = Color(red: 255/255, green: 138/255, blue: 74/255)
    
    /// Success accent - neon green (#6BFFB5)
    static let accentSuccess = Color(red: 107/255, green: 255/255, blue: 181/255)
    
    // MARK: - Corner Radius
    
    static let cardCornerRadius: CGFloat = 20
    static let buttonCornerRadius: CGFloat = 16
    
    // MARK: - Spacing
    
    static let globalPadding: CGFloat = 16
    static let sectionSpacing: CGFloat = 24
    static let cardPadding: CGFloat = 20
}

// MARK: - Button Styles

/// Primary button style with accent color background and press animations
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Theme.accentPrimary.opacity(configuration.isPressed ? 0.8 : 1.0))
            .foregroundStyle(.black)
            .clipShape(RoundedRectangle(cornerRadius: Theme.buttonCornerRadius, style: .continuous))
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

/// Secondary button style with card background
struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Theme.backgroundCard.opacity(configuration.isPressed ? 0.8 : 1.0))
            .foregroundStyle(Theme.textPrimary)
            .clipShape(RoundedRectangle(cornerRadius: Theme.buttonCornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.buttonCornerRadius, style: .continuous)
                    .stroke(Theme.accentPrimary.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Card View Modifier

/// Card view modifier to create consistent card styling
struct ThemedCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(Theme.cardPadding)
            .background(Theme.backgroundCard)
            .clipShape(RoundedRectangle(cornerRadius: Theme.cardCornerRadius, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

extension View {
    /// Apply themed card styling to any view
    func themedCard() -> some View {
        self.modifier(ThemedCardModifier())
    }
}

// MARK: - Coach Message Card

/// A themed card for displaying coach messages with different tones
struct CoachMessageCard: View {
    let message: String
    let tone: MessageTone
    
    enum MessageTone {
        case success
        case warning
        case neutral
        
        var accentColor: Color {
            switch self {
            case .success: return Theme.accentSuccess
            case .warning: return Theme.accentWarning
            case .neutral: return Theme.accentPrimary
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Accent indicator
            RoundedRectangle(cornerRadius: 4)
                .fill(tone.accentColor)
                .frame(width: 4)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Coach")
                    .font(.caption.bold())
                    .foregroundStyle(tone.accentColor)
                    .textCase(.uppercase)
                
                Text(message)
                    .font(.body)
                    .foregroundStyle(Theme.textPrimary)
            }
            
            Spacer()
        }
        .padding(Theme.cardPadding)
        .background(Theme.backgroundCard)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cardCornerRadius, style: .continuous)
                .stroke(tone.accentColor.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Discipline Score Display

/// Large, prominent display for the discipline score
struct DisciplineScoreDisplay: View {
    let score: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Text("\(score)")
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.accentPrimary)
            
            Text("Discipline Score")
                .font(.headline)
                .foregroundStyle(Theme.textSecondary)
        }
        .padding(.vertical, Theme.cardPadding)
    }
}

// MARK: - Check-In Row

/// Displays a single check-in row with status indicator and note
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
