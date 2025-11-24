//
//  TodayView.swift
//  DiciplineTraining
//
//  Created by Bjørn-Tore Almås on 20/11/2025.
//


import SwiftUI

struct TodayView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var plannedToTrain: Bool = true
    @State private var completedTraining: Bool = false
    @State private var note: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Dagens innsjekk")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Toggle("Planen er å trene i dag", isOn: $plannedToTrain)
                
                Toggle("Jeg har fullført dagens økt", isOn: $completedTraining)
                
                TextField("Kort notat (valgfritt)", text: $note)
                    .textFieldStyle(.roundedBorder)
                
                Button {
                    appState.logCheckIn(
                        planned: plannedToTrain,
                        completed: completedTraining,
                        note: note.isEmpty ? nil : note
                    )
                } label: {
                    Text("Lagre dagens status")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.primary)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("I dag")
        }
    }
}
