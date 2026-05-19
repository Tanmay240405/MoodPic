import Foundation
import SwiftUI
import Combine

class MoodStore: ObservableObject {
    @Published var moods: [MoodEntry] = [] {
        didSet { save() }
    }
    
    private let storageKey = "moodpic.moods"
    
    init() {
        load()
    }
    
    func addMood(mood: MoodType, reason: String, photoData: Data?) {
        let entry = MoodEntry(mood: mood, reason: reason, photoData: photoData, date: Date())
        moods.insert(entry, at: 0)
    }
    
    func deleteMood(at offsets: IndexSet) {
        moods.remove(atOffsets: offsets)
    }
    
    // MARK: - Persistence
    private func save() {
        if let encoded = try? JSONEncoder().encode(moods) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    private func load() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([MoodEntry].self, from: data) {
            moods = decoded
        }
        // Seed sample entries only on very first launch (no saved data yet)
        if moods.isEmpty {
            moods = [
                MoodEntry(mood: .happy,   reason: "Good day!",          photoData: nil, date: Date().addingTimeInterval(-86400 * 2)),
                MoodEntry(mood: .proud,   reason: "Meditation session",  photoData: nil, date: Date().addingTimeInterval(-86400)),
                MoodEntry(mood: .delight, reason: "Weekend trip",        photoData: nil, date: Date())
            ]
        }
    }
}
