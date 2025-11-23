import SwiftUI

struct ProgressViewScreen: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Discipline score")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("\(appState.disciplineScore)")
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                    .padding()
                
                Text("Basert på gjennomføring siste 14 dager.")
                    .foregroundStyle(.secondary)
                
                List {
                    Section("Siste check-ins") {
                        ForEach(appState.checkIns.sorted(by: { $0.date > $1.date })) { check in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(check.date.formatted(date: .abbreviated, time: .omitted))
                                    Text(check.completedTraining ? "Økt gjennomført" : "Ingen økt")
                                        .font(.caption)
                                        .foregroundStyle(check.completedTraining ? .green : .red)
                                }
                                Spacer()
                                if let note = check.note {
                                    Text(note)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Fremgang")
        }
    }
}
