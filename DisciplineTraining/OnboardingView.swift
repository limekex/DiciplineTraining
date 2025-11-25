import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var name: String = ""
    @State private var daysPerWeek: Int = 3
    @State private var experience: TrainingExperience = .beginner
    @State private var goal: String = "Styrke + estetisk fysikk"
    @State private var showCommitment: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.sectionSpacing) {
                    // Header
                    VStack(spacing: 12) {
                        Text("Discipline")
                            .font(.largeTitle.bold())
                            .foregroundStyle(Theme.textPrimary)
                        
                        Text("Motivasjon varer i timer.\nDisiplin varer livet ut.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .padding(.top, Theme.sectionSpacing)
                    
                    // About you card
                    VStack(alignment: .leading, spacing: 16) {
                        Text("OM DEG")
                            .font(.caption.bold())
                            .foregroundStyle(Theme.textSecondary)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Navn (valgfritt)")
                                .font(.subheadline)
                                .foregroundStyle(Theme.textSecondary)
                            
                            TextField("Skriv her...", text: $name)
                                .padding(12)
                                .background(Theme.backgroundPrimary)
                                .foregroundStyle(Theme.textPrimary)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Treningserfaring")
                                .font(.subheadline)
                                .foregroundStyle(Theme.textSecondary)
                            
                            Picker("Erfaring", selection: $experience) {
                                ForEach(TrainingExperience.allCases) { exp in
                                    Text(exp.displayName).tag(exp)
                                }
                            }
                            .pickerStyle(.segmented)
                            .tint(Theme.accentPrimary)
                        }
                    }
                    .themedCard()
                    
                    // Goal and commitment card
                    VStack(alignment: .leading, spacing: 16) {
                        Text("MÅL OG FORPLIKTELSE")
                            .font(.caption.bold())
                            .foregroundStyle(Theme.textSecondary)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Ditt mål")
                                .font(.subheadline)
                                .foregroundStyle(Theme.textSecondary)
                            
                            TextField("f.eks. styrke + fysikk", text: $goal)
                                .padding(12)
                                .background(Theme.backgroundPrimary)
                                .foregroundStyle(Theme.textPrimary)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Jeg forplikter meg til \(daysPerWeek) dager i uka")
                                .font(.body)
                                .foregroundStyle(Theme.textPrimary)
                            
                            Stepper("Juster dager", value: $daysPerWeek, in: 2...6)
                                .labelsHidden()
                                .tint(Theme.accentPrimary)
                        }
                    }
                    .themedCard()
                    
                    // Continue button
                    Button {
                        showCommitment = true
                    } label: {
                        Text("Gå videre")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(daysPerWeek == 0)
                    
                    Spacer(minLength: Theme.sectionSpacing)
                }
                .padding(Theme.globalPadding)
            }
            .background(Theme.backgroundPrimary)
            .sheet(isPresented: $showCommitment) {
                CommitmentView(
                    name: name,
                    goal: goal,
                    daysPerWeek: daysPerWeek,
                    experience: experience
                )
                .environmentObject(appState)
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct CommitmentView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    let name: String
    let goal: String
    let daysPerWeek: Int
    let experience: TrainingExperience
    
    var body: some View {
        ScrollView {
            VStack(spacing: Theme.sectionSpacing) {
                // Header
                VStack(spacing: 12) {
                    Text("Forpliktelse")
                        .font(.title.bold())
                        .foregroundStyle(Theme.textPrimary)
                    
                    Text("""
                    Du forplikter deg til å trene \(daysPerWeek)x per uke.
                    
                    Jeg vil minne deg på planen din,
                    sjekke inn hver dag,
                    og hjelpe deg å holde linja
                    selv når motivasjonen er lav.
                    """)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Theme.textSecondary)
                }
                .padding(.top, Theme.sectionSpacing)
                
                // Commitment card
                VStack(spacing: 16) {
                    HStack {
                        Text("Navn:")
                            .foregroundStyle(Theme.textSecondary)
                        Spacer()
                        Text(name.isEmpty ? "Athlete" : name)
                            .font(.headline)
                            .foregroundStyle(Theme.textPrimary)
                    }
                    
                    Divider()
                        .background(Theme.textSecondary.opacity(0.3))
                    
                    HStack {
                        Text("Mål:")
                            .foregroundStyle(Theme.textSecondary)
                        Spacer()
                        Text(goal)
                            .font(.headline)
                            .foregroundStyle(Theme.textPrimary)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    Divider()
                        .background(Theme.textSecondary.opacity(0.3))
                    
                    HStack {
                        Text("Treningsdager:")
                            .foregroundStyle(Theme.textSecondary)
                        Spacer()
                        Text("\(daysPerWeek) dager/uke")
                            .font(.headline)
                            .foregroundStyle(Theme.accentPrimary)
                    }
                }
                .themedCard()
                
                // Accept button
                Button {
                    let profile = UserProfile(
                        name: name.isEmpty ? "Athlete" : name,
                        goal: goal,
                        daysPerWeek: daysPerWeek,
                        experience: experience
                    )
                    appState.completeOnboarding(with: profile)
                } label: {
                    Text("Jeg er med")
                }
                .buttonStyle(PrimaryButtonStyle())
                
                // Cancel button
                Button {
                    dismiss()
                } label: {
                    Text("Tilbake")
                }
                .buttonStyle(SecondaryButtonStyle())
                
                Spacer(minLength: Theme.sectionSpacing)
            }
            .padding(Theme.globalPadding)
        }
        .background(Theme.backgroundPrimary)
        .preferredColorScheme(.dark)
    }
}
