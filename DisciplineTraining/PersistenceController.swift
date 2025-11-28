import Foundation

struct PersistedState: Codable {
    var userProfile: UserProfile?
    var checkIns: [DailyCheckIn]
}

final class PersistenceController {
    static let shared = PersistenceController()
    private init() {}

    private var fileURL: URL? {
        do {
            let fm = FileManager.default
            let appSupport = try fm.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let dir = appSupport.appendingPathComponent("DisciplineTraining", isDirectory: true)
            if !fm.fileExists(atPath: dir.path) {
                try fm.createDirectory(at: dir, withIntermediateDirectories: true)
            }
            return dir.appendingPathComponent("appstate.json")
        } catch {
            print("PersistenceController: failed to get file URL: \(error)")
            return nil
        }
    }

    func save(appState: AppState) {
        guard let url = fileURL else { return }
        let toSave = PersistedState(userProfile: appState.userProfile, checkIns: appState.checkIns)
        do {
            let data = try JSONEncoder().encode(toSave)
            try data.write(to: url, options: [.atomic])
            // For debug
            // print("Saved app state to \(url.path)")
        } catch {
            print("PersistenceController: failed to save app state: \(error)")
        }
    }

    func load() -> PersistedState? {
        guard let url = fileURL else { return nil }
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(PersistedState.self, from: data)
            return decoded
        } catch {
            // If file doesn't exist or decode fails, return nil (caller will use defaults)
            // print("PersistenceController: failed to load app state: \(error)")
            return nil
        }
    }

    func deleteSavedState() throws {
        guard let url = fileURL else { return }
        try FileManager.default.removeItem(at: url)
    }
    
    /// Clears all persisted data (for app reset)
    func clearAll() {
        guard let url = fileURL else { return }
        try? FileManager.default.removeItem(at: url)
        print("🗑️ Cleared all persisted data")
    }
}
