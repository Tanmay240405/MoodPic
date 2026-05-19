import SwiftUI

struct ContentView: View {
    @State private var hasOnboarded = false
    @StateObject private var moodStore = MoodStore()
    
    var body: some View {
        Group {
            if hasOnboarded {
                MainTabView()
                    .environmentObject(moodStore)
            } else {
                OnboardingView(hasOnboarded: $hasOnboarded)
            }
        }
        .preferredColorScheme(.light) // The design is primarily light mode
    }
}
