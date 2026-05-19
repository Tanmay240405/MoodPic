import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showAddMood = false
    
    var body: some View {
        TabView(selection: Binding(
            get: { selectedTab },
            set: { newValue in
                if newValue == 4 {
                    showAddMood = true
                } else {
                    selectedTab = newValue
                }
            }
        )) {
            HomeView()
                .tabItem { Image(systemName: "house.fill") }
                .tag(0)
            
            GalleryView()
                .tabItem { Image(systemName: "photo.on.rectangle") }
                .tag(1)
            
            AnalyticsView()
                .tabItem { Image(systemName: "chart.bar.fill") }
                .tag(2)
            
            Text("Profile View Placeholder")
                .tabItem { Image(systemName: "person.fill") }
                .tag(3)
                
            Text("") // Hidden tab for Add action
                .tabItem { Image(systemName: "plus.circle.fill") }
                .tag(4)
        }
        .sheet(isPresented: $showAddMood) {
            AddMoodView()
        }
    }
}
