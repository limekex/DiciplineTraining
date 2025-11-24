//
//  MainView.swift
//  DiciplineTraining
//
//  Created by Bjørn-Tore Almås on 20/11/2025.
//


import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("I dag", systemImage: "sun.max.fill")
                }
            
            ProgressViewScreen()
                .tabItem {
                    Label("Fremgang", systemImage: "chart.line.uptrend.xyaxis")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.fill")
                }
        }
    }
}
