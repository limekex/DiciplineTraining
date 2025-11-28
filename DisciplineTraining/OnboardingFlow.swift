import SwiftUI

// MARK: - Main Onboarding Flow Container
struct OnboardingFlow: View {
    @EnvironmentObject var appState: AppState
    @State private var currentStep: OnboardingStep = .welcome
    
    // User input state
    @State private var name: String = ""
    @State private var daysPerWeek: Int = 3
    @State private var experience: TrainingExperience = .beginner
    @State private var goal: String = ""
    @State private var enableNotifications: Bool = false
    
    enum OnboardingStep {
        case welcome
        case howItWorks
        case profile
        case commitment
        case notifications
    }
    
    var body: some View {
        ZStack {
            Theme.backgroundPrimary.ignoresSafeArea()
            
            switch currentStep {
            case .welcome:
                WelcomeScreen(onContinue: { currentStep = .howItWorks })
            case .howItWorks:
                HowItWorksScreen(
                    onContinue: { currentStep = .profile },
                    onBack: { currentStep = .welcome }
                )
            case .profile:
                ProfileSetupScreen(
                    name: $name,
                    goal: $goal,
                    experience: $experience,
                    onContinue: { currentStep = .commitment },
                    onBack: { currentStep = .howItWorks }
                )
            case .commitment:
                CommitmentScreen(
                    name: name,
                    goal: goal,
                    experience: experience,
                    daysPerWeek: $daysPerWeek,
                    onContinue: { currentStep = .notifications },
                    onBack: { currentStep = .profile }
                )
            case .notifications:
                NotificationSetupScreen(
                    enableNotifications: $enableNotifications,
                    onComplete: {
                        completeOnboarding()
                    },
                    onSkip: {
                        completeOnboarding()
                    }
                )
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func completeOnboarding() {
        let profile = UserProfile(
            name: name.isEmpty ? "Athlete" : name,
            goal: goal.isEmpty ? "Bli sterkere" : goal,
            daysPerWeek: daysPerWeek,
            experience: experience
        )
        
        if enableNotifications {
            NotificationManager.shared.requestAuthorization { granted in
                if granted {
                    // Use the time stored in AppState (default 20:00)
                    NotificationManager.shared.scheduleDailyReminder(
                        hour: self.appState.reminderHour,
                        minute: self.appState.reminderMinute
                    )
                }
            }
        }
        
        appState.completeOnboarding(with: profile)
    }
}

// MARK: - Welcome Screen
struct WelcomeScreen: View {
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 16) {
                Text("💪")
                    .font(.system(size: 80))
                
                Text("Discipline")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(Theme.textPrimary)
                
                Text("Motivasjon varer i timer.\nDisiplin varer livet ut.")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Theme.textSecondary)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                Button(action: onContinue) {
                    Text("Kom i gang")
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, Theme.globalPadding)
                
                Text("Det tar bare 2 minutter")
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
            }
            .padding(.bottom, 40)
        }
    }
}

// MARK: - How It Works Screen
struct HowItWorksScreen: View {
    let onContinue: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundStyle(Theme.textPrimary)
                }
                Spacer()
            }
            .padding(Theme.globalPadding)
            
            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 12) {
                        Text("Hvordan det fungerer")
                            .font(.largeTitle.bold())
                            .foregroundStyle(Theme.textPrimary)
                        
                        Text("Tre enkle steg til bedre disiplin")
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .padding(.top, 20)
                    
                    // Step 1
                    FeatureCard(
                        icon: "checkmark.circle.fill",
                        iconColor: Theme.accentSuccess,
                        title: "1. Daglig innsjekk",
                        description: "Hver dag registrerer du om du planlegger å trene, og om du gjennomførte det. Det tar 10 sekunder."
                    )
                    
                    // Step 2
                    FeatureCard(
                        icon: "chart.line.uptrend.xyaxis",
                        iconColor: Theme.accentPrimary,
                        title: "2. Spor fremgangen din",
                        description: "Se din Discipline Score utvikle seg. Den øker når du følger planen og holder det du lover deg selv."
                    )
                    
                    // Step 3
                    FeatureCard(
                        icon: "person.fill.questionmark",
                        iconColor: Theme.accentWarning,
                        title: "3. Få coaching",
                        description: "Appen gir deg kontekstsensitive råd basert på dine resultater. Den feirer når du presterer og pusher når du trenger det."
                    )
                    
                    Button(action: onContinue) {
                        Text("Neste")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.top, 20)
                }
                .padding(Theme.globalPadding)
            }
        }
    }
}

// MARK: - Profile Setup Screen
struct ProfileSetupScreen: View {
    @Binding var name: String
    @Binding var goal: String
    @Binding var experience: TrainingExperience
    let onContinue: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundStyle(Theme.textPrimary)
                }
                Spacer()
            }
            .padding(Theme.globalPadding)
            
            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 12) {
                        Text("Fortell meg om deg")
                            .font(.largeTitle.bold())
                            .foregroundStyle(Theme.textPrimary)
                        
                        Text("Dette hjelper meg å gi deg bedre råd")
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Hva skal jeg kalle deg? (valgfritt)")
                                .font(.subheadline.bold())
                                .foregroundStyle(Theme.textPrimary)
                            
                            TextField("Skriv navnet ditt her", text: $name)
                                .padding(16)
                                .background(Theme.backgroundCard)
                                .foregroundStyle(Theme.textPrimary)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Hva er ditt hovedmål?")
                                .font(.subheadline.bold())
                                .foregroundStyle(Theme.textPrimary)
                            
                            TextField("f.eks. Styrke + estetikk", text: $goal)
                                .padding(16)
                                .background(Theme.backgroundCard)
                                .foregroundStyle(Theme.textPrimary)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Din treningserfaring")
                                .font(.subheadline.bold())
                                .foregroundStyle(Theme.textPrimary)
                            
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
                    
                    Button(action: onContinue) {
                        Text("Neste")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(goal.isEmpty)
                }
                .padding(Theme.globalPadding)
            }
        }
    }
}

// MARK: - Commitment Screen
struct CommitmentScreen: View {
    let name: String
    let goal: String
    let experience: TrainingExperience
    @Binding var daysPerWeek: Int
    let onContinue: () -> Void
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundStyle(Theme.textPrimary)
                }
                Spacer()
            }
            .padding(Theme.globalPadding)
            
            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 12) {
                        Text("Din forpliktelse")
                            .font(.largeTitle.bold())
                            .foregroundStyle(Theme.textPrimary)
                        
                        Text("Hvor mange dager per uke forplikter du deg til?")
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    // Days selector
                    VStack(spacing: 24) {
                        Text("\(daysPerWeek)")
                            .font(.system(size: 80, weight: .bold))
                            .foregroundStyle(Theme.accentPrimary)
                        
                        Text("dager per uke")
                            .font(.title3)
                            .foregroundStyle(Theme.textSecondary)
                        
                        HStack(spacing: 12) {
                            ForEach(2...6, id: \.self) { day in
                                Button(action: { daysPerWeek = day }) {
                                    Text("\(day)")
                                        .font(.title2.bold())
                                        .frame(width: 50, height: 50)
                                        .foregroundStyle(daysPerWeek == day ? Theme.backgroundPrimary : Theme.textPrimary)
                                        .background(daysPerWeek == day ? Theme.accentPrimary : Theme.backgroundCard)
                                        .clipShape(Circle())
                                }
                            }
                        }
                    }
                    .themedCard()
                    
                    // Summary card
                    VStack(alignment: .leading, spacing: 16) {
                        Text("OPPSUMMERING")
                            .font(.caption.bold())
                            .foregroundStyle(Theme.textSecondary)
                        
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
                            Text("Erfaring:")
                                .foregroundStyle(Theme.textSecondary)
                            Spacer()
                            Text(experience.displayName)
                                .font(.headline)
                                .foregroundStyle(Theme.textPrimary)
                        }
                    }
                    .themedCard()
                    
                    Button(action: onContinue) {
                        Text("Neste")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding(Theme.globalPadding)
            }
        }
    }
}

// MARK: - Notification Setup Screen
struct NotificationSetupScreen: View {
    @Binding var enableNotifications: Bool
    let onComplete: () -> Void
    let onSkip: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 32) {
                VStack(spacing: 16) {
                    Text("🔔")
                        .font(.system(size: 80))
                    
                    Text("Daglige påminnelser")
                        .font(.largeTitle.bold())
                        .foregroundStyle(Theme.textPrimary)
                    
                    Text("Få en daglig påminnelse om å sjekke inn. Dette øker sjansen for at du holder deg til planen din.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Theme.textSecondary)
                        .padding(.horizontal, 40)
                }
                
                VStack(spacing: 12) {
                    Button(action: {
                        enableNotifications = true
                        onComplete()
                    }) {
                        Text("Aktiver påminnelser")
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    
                    Button(action: {
                        enableNotifications = false
                        onSkip()
                    }) {
                        Text("Hopp over")
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
                .padding(.horizontal, Theme.globalPadding)
            }
            
            Spacer()
        }
    }
}

// MARK: - Supporting Components
struct FeatureCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundStyle(iconColor)
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Theme.textPrimary)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .themedCard()
    }
}

// MARK: - Preview
#Preview {
    OnboardingFlow()
        .environmentObject(AppState(persistenceController: PersistenceController.shared))
}
