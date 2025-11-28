//
//  ProfileView.swift
//  DiciplineTraining
//
//  Created by Bjørn-Tore Almås on 20/11/2025.
//

import SwiftUI
import UserNotifications

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @AppStorage("remindersEnabled") private var remindersEnabled: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.sectionSpacing) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Profil")
                            .font(.title2.bold())
                            .foregroundStyle(Theme.textPrimary)
                        
                        Text("Din informasjon og innstillinger")
                            .font(.callout)
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Profile info card
                    if let profile = appState.userProfile {
                        VStack(alignment: .leading, spacing: 16) {
                            Text(profile.name)
                                .font(.title.bold())
                                .foregroundStyle(Theme.textPrimary)
                            
                            Text(profile.goal)
                                .font(.body)
                                .foregroundStyle(Theme.textSecondary)
                            
                            Divider()
                                .background(Theme.textSecondary.opacity(0.3))
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Dager per uke:")
                                        .foregroundStyle(Theme.textSecondary)
                                    Spacer()
                                    Text("\(profile.daysPerWeek)")
                                        .font(.headline)
                                        .foregroundStyle(Theme.accentPrimary)
                                }
                                
                                HStack {
                                    Text("Erfaring:")
                                        .foregroundStyle(Theme.textSecondary)
                                    Spacer()
                                    Text(profile.experience.displayName)
                                        .font(.headline)
                                        .foregroundStyle(Theme.accentPrimary)
                                }
                            }
                        }
                        .themedCard()
                    } else {
                        VStack(spacing: 12) {
                            Text("Ingen profil funnet")
                                .foregroundStyle(Theme.textSecondary)
                        }
                        .themedCard()
                    }
                    
                    // Settings card
                    VStack(alignment: .leading, spacing: 16) {
                        Text("INNSTILLINGER")
                            .font(.caption.bold())
                            .foregroundStyle(Theme.textSecondary)
                        
                        Toggle("Daglig påminnelse om innsjekk", isOn: $remindersEnabled)
                            .tint(Theme.accentPrimary)
                            .onChange(of: remindersEnabled) { newValue in
                                handleRemindersToggle(enabled: newValue)
                            }
                        
                        if remindersEnabled {
                            DatePicker("Tidspunkt for påminnelse", selection: reminderTimeBinding, displayedComponents: .hourAndMinute)
                                .tint(Theme.accentPrimary)
                                .onChange(of: reminderTimeBinding.wrappedValue) { _ in
                                    // Update reminder when time changes
                                    if remindersEnabled {
                                        NotificationManager.shared.scheduleDailyReminder(
                                            hour: appState.reminderHour,
                                            minute: appState.reminderMinute
                                        )
                                    }
                                }
                        }
                    }
                    .themedCard()
                    
                    // Reset section - ALWAYS VISIBLE
                    VStack(alignment: .leading, spacing: 16) {
                        Text("AVANSERT")
                            .font(.caption.bold())
                            .foregroundStyle(Theme.textSecondary)
                        
                        Button {
                            appState.resetApp()
                        } label: {
                            HStack {
                                Image(systemName: "arrow.counterclockwise")
                                Text("Reset app (slett all data)")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(SecondaryButtonStyle())
                        
                        Text("⚠️ Dette sletter all data og starter onboarding på nytt")
                            .font(.caption)
                            .foregroundStyle(Theme.accentWarning)
                    }
                    .themedCard()
                    
                    Spacer(minLength: Theme.sectionSpacing)
                }
                .onAppear(perform: syncNotificationToggle)
            }
            .padding(.horizontal)
            .background(Theme.backgroundPrimary)
            .navigationTitle("Profil")
            .toolbar(.hidden)
        }
    }
    
    private var reminderTimeBinding: Binding<Date> {
        Binding<Date>(
            get: {
                let calendar = Calendar.current
                var components = DateComponents()
                components.hour = appState.reminderHour
                components.minute = appState.reminderMinute
                return calendar.date(from: components) ?? Date()
            },
            set: { newDate in
                let calendar = Calendar.current
                let components = calendar.dateComponents([.hour, .minute], from: newDate)
                appState.reminderHour = components.hour ?? 20
                appState.reminderMinute = components.minute ?? 0
            }
        )
    }
    
    private func handleRemindersToggle(enabled: Bool) {
        if enabled {
            NotificationManager.shared.requestAuthorization { granted in
                if granted {
                    NotificationManager.shared.scheduleDailyReminder(
                        hour: appState.reminderHour,
                        minute: appState.reminderMinute
                    )
                } else {
                    // Revert toggle if permission denied
                    DispatchQueue.main.async {
                        remindersEnabled = false
                    }
                }
            }
        } else {
            NotificationManager.shared.cancelReminder()
        }
    }
    
    private func syncNotificationToggle() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                remindersEnabled = settings.authorizationStatus == .authorized
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AppState())
    }
}
