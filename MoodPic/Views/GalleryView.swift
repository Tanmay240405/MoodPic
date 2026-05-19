import SwiftUI

struct GalleryView: View {
    @EnvironmentObject var moodStore: MoodStore
    
    var body: some View {
        NavigationView {
            ZStack {
                // Warm peachy-pink background matching the reference
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 255/255, green: 228/255, blue: 228/255), // Top: soft warm peach
                        Color(red: 255/255, green: 205/255, blue: 220/255)  // Bottom: richer pink
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 32) {
                        
                        // Large Header
                        Text("My Moods")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.top, 40)
                        
                        // Recent Memories Section
                        if !moodStore.moods.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Recent Memories")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 20)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(moodStore.moods.prefix(5)) { entry in
                                            if let data = entry.photoData, let uiImage = UIImage(data: data) {
                                                Image(uiImage: uiImage)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 140, height: 180)
                                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                                            } else {
                                                RoundedRectangle(cornerRadius: 24)
                                                    .fill(Color.white.opacity(0.65))
                                                    .frame(width: 140, height: 180)
                                                    .overlay(
                                                        Image(entry.mood.imageName)
                                                            .resizable()
                                                            .scaledToFit()
                                                            .padding(30)
                                                    )
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                        
                        // Mood Folders Section
                        VStack(spacing: 16) {
                            ForEach(MoodType.allCases) { mood in
                                let entries = moodStore.moods.filter { $0.mood == mood }
                                MoodFolderCard(mood: mood, entries: entries)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 80) // Tab bar clearance
                    }
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle("My Moods")
            .navigationBarHidden(true) // We could hide it to let content breathe like in the screenshot
        }
    }
}

struct MoodFolderCard: View {
    var mood: MoodType
    var entries: [MoodEntry]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(mood.rawValue)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Text("\(entries.count) photos")
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.6))
                }
                Spacer()
                Image(mood.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .padding(8)
                    .background(Color.white.opacity(0.5))
                    .clipShape(Circle())
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    if entries.isEmpty {
                        Text("No photos yet. Add a mood!")
                            .font(.subheadline)
                            .foregroundColor(.black.opacity(0.5))
                            .italic()
                            .padding(.vertical, 20)
                    } else {
                        ForEach(entries) { entry in
                            if let data = entry.photoData, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 110, height: 110)
                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                            } else {
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color.white.opacity(0.65))
                                    .frame(width: 110, height: 110)
                                    .overlay(
                                        Image(mood.imageName)
                                            .resizable()
                                            .scaledToFit()
                                            .padding(20)
                                    )
                            }
                        }
                    }
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(mood.color.opacity(0.2)) // Use the mood's associated color with low opacity for the pastel card background
        )
    }
}
