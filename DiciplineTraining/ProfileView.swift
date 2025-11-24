//
//  ProfileView.swift
//  DiciplineTraining
//
//  Created by Bjørn-Tore Almås on 20/11/2025.
//


import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    
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
                
                Spacer()
            }
            .padding()
            .navigationTitle("Profil")
        }
    }
}
