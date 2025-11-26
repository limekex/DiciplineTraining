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
    @AppStorage("reminderTimeInterval") private var reminderTimeInterval: TimeInterval = 20 * 3600 // Default 20:00
    
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
                        
                        // Reminder time picker, shown only when reminders are enabled
                        if remindersEnabled {
                            DatePicker("Påminnelse tid:", selection: reminderTimeBinding, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .foregroundStyle(Theme.textPrimary)
                        }
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
                let today = calendar.startOfDay(for: Date())
                return today.addingTimeInterval(reminderTimeInterval)
            },
            set: { newDate in
                let calendar = Calendar.current
                let components = calendar.dateComponents([.hour, .minute], from: newDate)
                let hour = components.hour ?? 0
                let minute = components.minute ?? 0
                reminderTimeInterval = TimeInterval(hour * 3600 + minute * 60)
            }
        )
    }
    
    private func handleRemindersToggle(enabled: Bool) {
        if enabled {
            NotificationManager.shared.requestAuthorization { granted in
                if granted {
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.hour, .minute], from: reminderTimeBinding.wrappedValue)
                    
                    NotificationManager.shared.scheduleDailyReminder(
                        hour: components.hour ?? 20,
                        minute: components.minute ?? 0
                    )
                } else {
                    // Revert toggle if permission denied
                    remindersEnabled = false
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
