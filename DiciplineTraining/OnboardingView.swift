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
            VStack(spacing: 24) {
                Text("Discipline")
                    .font(.largeTitle.bold())
                
                Text("Motivasjon varer i timer.\nDisiplin varer livet ut.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                
                Form {
                    Section("Om deg") {
                        TextField("Navn (valgfritt)", text: $name)
                        
                        Picker("Treningserfaring", selection: $experience) {
                            ForEach(TrainingExperience.allCases) { exp in
                                Text(exp.displayName).tag(exp)
                            }
                        }
                    }
                    
                    Section("Mål og forpliktelse") {
                        TextField("Mål (f.eks. styrke + fysikk)", text: $goal)
                        
                        Stepper(value: $daysPerWeek, in: 2...6) {
                            Text("Jeg forplikter meg til \(daysPerWeek) dager i uka")
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .frame(maxHeight: 360)
                
                Button {
                    showCommitment = true
                } label: {
                    Text("Gå videre")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.primary)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                .disabled(daysPerWeek == 0)
                
                Spacer()
            }
            .padding()
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
    }
}

struct CommitmentView: View {
    @EnvironmentObject var appState: AppState
    
    let name: String
    let goal: String
    let daysPerWeek: Int
    let experience: TrainingExperience
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Forpliktelse")
                .font(.title.bold())
            
            Text("""
            Du forplikter deg til å trene \(daysPerWeek)x per uke.

            Jeg vil minne deg på planen din,
            sjekke inn hver dag,
            og hjelpe deg å holde linja
            selv når motivasjonen er lav.
            """)
            .multilineTextAlignment(.center)
            
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
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.primary)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)
            
            Button(role: .cancel) {
                // Lukker sheet (bruker kan swipe ned)
            } label: {
                Text("Tilbake")
            }
            
            Spacer()
        }
        .padding()
    }
}
