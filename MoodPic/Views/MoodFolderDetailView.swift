import SwiftUI

struct MoodFolderDetailView: View {
    var mood: MoodType
    var entries: [MoodEntry]
    
    @EnvironmentObject var moodStore: MoodStore
    @State private var selectedEntry: MoodEntry? = nil
    
    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 255/255, green: 228/255, blue: 228/255),
                    Color(red: 255/255, green: 205/255, blue: 220/255)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Hero header
                    ZStack(alignment: .bottomLeading) {
                        RoundedRectangle(cornerRadius: 32)
                            .fill(mood.color.opacity(0.3))
                            .frame(maxWidth: .infinity)
                            .frame(height: 160)
                        
                        // Large avatar
                        Image(mood.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 140)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 20)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(mood.rawValue)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.black)
                            Text("\(entries.count) \(entries.count == 1 ? "memory" : "memories")")
                                .font(.subheadline)
                                .foregroundColor(.black.opacity(0.6))
                        }
                        .padding(24)
                    }
                    .padding(.horizontal, 20)
                    
                    // Grid of photos
                    if entries.isEmpty {
                        VStack(spacing: 16) {
                            Image(mood.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .opacity(0.5)
                            Text("No memories yet for this mood")
                                .font(.headline)
                                .foregroundColor(.black.opacity(0.5))
                            Text("Tap the + button to add a photo and pick \"\(mood.rawValue)\"")
                                .font(.subheadline)
                                .foregroundColor(.black.opacity(0.4))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                    } else {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(entries) { entry in
                                PhotoCell(entry: entry, mood: mood) {
                                    selectedEntry = entry
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer(minLength: 80)
                }
                .padding(.top, 20)
            }
        }
        .navigationTitle(mood.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(item: $selectedEntry) { entry in
            FullScreenPhotoView(entry: entry, mood: mood)
        }
    }
}

// MARK: - Photo Cell
struct PhotoCell: View {
    var entry: MoodEntry
    var mood: MoodType
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 6) {
                if let data = entry.photoData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {
                    // Placeholder with avatar
                    RoundedRectangle(cornerRadius: 20)
                        .fill(mood.color.opacity(0.25))
                        .frame(maxWidth: .infinity)
                        .frame(height: 160)
                        .overlay(
                            Image(mood.imageName)
                                .resizable()
                                .scaledToFit()
                                .padding(28)
                        )
                }
                
                // Date + note
                Text(entry.date, style: .date)
                    .font(.caption2)
                    .foregroundColor(.black.opacity(0.4))
                
                if !entry.reason.isEmpty {
                    Text(entry.reason)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.black.opacity(0.7))
                        .lineLimit(2)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Full Screen Photo Viewer
struct FullScreenPhotoView: View {
    var entry: MoodEntry
    var mood: MoodType
    
    @Environment(\.dismiss) var dismiss
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var showInfo: Bool = true
    
    var body: some View {
        ZStack {
            // Black backdrop
            Color.black.ignoresSafeArea()
            
            // Photo or avatar placeholder
            if let data = entry.photoData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(scale)
                    .offset(offset)
                    .gesture(
                        // Pinch to zoom
                        MagnificationGesture()
                            .onChanged { value in
                                let delta = value / lastScale
                                lastScale = value
                                scale = min(max(scale * delta, 1), 5)
                            }
                            .onEnded { _ in
                                lastScale = 1.0
                                if scale < 1 { withAnimation { scale = 1; offset = .zero } }
                            }
                            .simultaneously(with:
                                // Drag when zoomed
                                DragGesture()
                                    .onChanged { value in
                                        if scale > 1 {
                                            offset = CGSize(
                                                width: lastOffset.width + value.translation.width,
                                                height: lastOffset.height + value.translation.height
                                            )
                                        }
                                    }
                                    .onEnded { _ in lastOffset = offset }
                            )
                    )
                    .onTapGesture(count: 2) {
                        withAnimation(.spring()) {
                            scale = scale > 1 ? 1 : 2.5
                            offset = .zero
                            lastOffset = .zero
                        }
                    }
                    .onTapGesture {
                        withAnimation { showInfo.toggle() }
                    }
            } else {
                // Avatar placeholder in full screen
                Image(mood.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 280)
                    .opacity(0.9)
            }
            
            // Top bar: close + mood badge
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                    }
                    Spacer()
                    // Mood badge
                    HStack(spacing: 6) {
                        Image(mood.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                        Text(mood.rawValue)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(mood.color.opacity(0.6))
                    .clipShape(Capsule())
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                
                Spacer()
                
                // Bottom info overlay
                if showInfo {
                    VStack(alignment: .leading, spacing: 6) {
                        if !entry.reason.isEmpty {
                            Text(entry.reason)
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        Text(entry.date, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(24)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0.6)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        // Swipe down to dismiss
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height > 100 && scale == 1 {
                        dismiss()
                    }
                }
        )
    }
}



