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
    @State private var notificationsEnabled: Bool = false
    
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
                        
                        Toggle("Daglig påminnelse om innsjekk", isOn: $notificationsEnabled)
                            .tint(Theme.accentPrimary)
                            .onChange(of: notificationsEnabled) { newValue in
                                if newValue {
                                    NotificationManager.shared.requestAuthorization { granted in
                                        if granted {
                                            NotificationManager.shared.scheduleDailyReminder()
                                        } else {
                                            // Revert toggle if permission denied
                                            notificationsEnabled = false
                                        }
                                    }
                                } else {
                                    NotificationManager.shared.cancelReminder()
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
            .onAppear {
                // Check current notification settings and set toggle
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    DispatchQueue.main.async {
                        notificationsEnabled = (settings.authorizationStatus == .authorized)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
