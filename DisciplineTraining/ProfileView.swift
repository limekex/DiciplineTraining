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
            VStack(spacing: 16) {
                if let profile = appState.userProfile {
                    Text(profile.name)
                        .font(.title.bold())
                    
                    Text(profile.goal)
                        .foregroundStyle(.secondary)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Dager per uke: \(profile.daysPerWeek)")
                        Text("Erfaring: \(profile.experience.displayName)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                } else {
                    Text("Ingen profil funnet")
                }
                
                Toggle("Daglig påminnelse om innsjekk", isOn: $notificationsEnabled)
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
                    .padding()
                
                Spacer()
            }
            .padding()
            .navigationTitle("Profil")
            .onAppear {
                // Optionally, check current notification settings and set toggle
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    DispatchQueue.main.async {
                        notificationsEnabled = (settings.authorizationStatus == .authorized)
                    }
                }
            }
        }
    }
}
