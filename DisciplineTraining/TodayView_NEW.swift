import SwiftUI

struct TodayView: View {
    @EnvironmentObject var appState: AppState
    
    // State for the form
    @State private var plannedToTrain: Bool = true
    @State private var completedTraining: Bool = false
    @State private var note: String = ""
    
    // Focus state to control the keyboard
    @FocusState private var isNoteFieldFocused: Bool
    
    // Edit mode
    @State private var isEditingToday: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.backgroundPrimary
                    .ignoresSafeArea()
                    .onTapGesture {
                        isNoteFieldFocused = false
                    }

                ScrollView {
                    VStack(spacing: Theme.sectionSpacing) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("I dag")
                                .font(.title2.bold())
                                .foregroundStyle(Theme.textPrimary)
                            
                            Text(todaysCheckIn != nil && !isEditingToday ? "Din status for dagen" : "Registrer din status for dagen")
                                .font(.callout)
                                .foregroundStyle(Theme.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Show existing check-in or edit form
                        if let checkIn = todaysCheckIn, !isEditingToday {
                            // Existing check-in view
                            existingCheckInView(checkIn)
                        } else {
                            // Check-in form
                            checkInFormView()
                        }
                        
                        // Coach message if available
                        if let message = appState.lastCoachMessage {
                            CoachMessageCard(
                                message: message,
                                tone: determineCoachTone(message: message)
                            )
                        }
                        
                        Spacer(minLength: Theme.sectionSpacing)
                    }
                    .padding(Theme.globalPadding)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: loadTodaysCheckIn)
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Computed Properties
    
    private var todaysCheckIn: DailyCheckIn? {
        appState.getTodaysCheckIn()
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private func existingCheckInView(_ checkIn: DailyCheckIn) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("✅ Innsjekk fullført")
                    .font(.headline)
                    .foregroundStyle(Theme.accentSuccess)
                Spacer()
            }
            
            Divider()
                .background(Theme.textSecondary.opacity(0.3))
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(Theme.accentPrimary)
                    Text("Status:")
                        .foregroundStyle(Theme.textSecondary)
                    Spacer()
                    if checkIn.completedTraining {
                        Text("✓ Fullført trening")
                            .foregroundStyle(Theme.accentSuccess)
                            .font(.subheadline.bold())
                    } else if checkIn.plannedToTrain {
                        Text("Planlagt, ikke gjennomført")
                            .foregroundStyle(Theme.accentWarning)
                            .font(.subheadline)
                    } else {
                        Text("Ingen trening planlagt")
                            .foregroundStyle(Theme.textSecondary)
                            .font(.subheadline)
                    }
                }
                
                if let note = checkIn.note, !note.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Image(systemName: "note.text")
                                .foregroundStyle(Theme.accentPrimary)
                            Text("Notat:")
                                .foregroundStyle(Theme.textSecondary)
                        }
                        Text(note)
                            .foregroundStyle(Theme.textPrimary)
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Theme.backgroundPrimary.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            
            Divider()
                .background(Theme.textSecondary.opacity(0.3))
            
            HStack(spacing: 12) {
                Button {
                    isEditingToday = true
                } label: {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Rediger")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(SecondaryButtonStyle())
                
                Button {
                    deleteTodaysCheckIn(checkIn)
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Slett")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(SecondaryButtonStyle())
            }
        }
        .themedCard()
    }
    
    @ViewBuilder
    private func checkInFormView() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(isEditingToday ? "Rediger dagens innsjekk" : "Dagens innsjekk")
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
                
                TextField("Skriv her...", text: $note, axis: .vertical)
                    .lineLimit(3...)
                    .padding(12)
                    .background(Theme.backgroundPrimary.opacity(0.5))
                    .foregroundStyle(Theme.textPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .focused($isNoteFieldFocused)
            }
            
            HStack(spacing: 12) {
                if isEditingToday {
                    Button {
                        isEditingToday = false
                        loadTodaysCheckIn()
                    } label: {
                        Text("Avbryt")
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
                
                Button {
                    saveCheckIn()
                } label: {
                    Text(isEditingToday ? "Oppdater" : "Lagre dagens status")
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
        .themedCard()
    }
    
    // MARK: - Helper Functions
    
    private func loadTodaysCheckIn() {
        if let checkIn = todaysCheckIn {
            plannedToTrain = checkIn.plannedToTrain
            completedTraining = checkIn.completedTraining
            note = checkIn.note ?? ""
        } else {
            // Reset to defaults
            plannedToTrain = true
            completedTraining = false
            note = ""
        }
    }
    
    private func saveCheckIn() {
        isNoteFieldFocused = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            appState.logCheckIn(
                planned: plannedToTrain,
                completed: completedTraining,
                note: note.isEmpty ? nil : note
            )
            isEditingToday = false
        }
    }
    
    private func deleteTodaysCheckIn(_ checkIn: DailyCheckIn) {
        appState.deleteCheckIn(id: checkIn.id)
        loadTodaysCheckIn()
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
