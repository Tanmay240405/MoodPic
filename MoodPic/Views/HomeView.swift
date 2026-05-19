import SwiftUI

struct HomeView: View {
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
                    VStack(spacing: 24) {
                        
                        // Mood Overview Banner
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Mood Snapshot")
                                    .font(.caption)
                                    .foregroundColor(.black.opacity(0.6))
                                Text("Your Emotional\nOverview")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Button(action: {}) {
                                    Text("Analyze")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 8)
                                        .background(Color.black)
                                        .clipShape(Capsule())
                                }
                                .padding(.top, 4)
                            }
                            Spacer()
                            // Decorative avatars for the banner
                            VStack {
                                Image("happy Background Removed")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                Image("Delight Background Removed")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35, height: 35)
                                    .offset(x: -10)
                            }
                        }
                        .padding(20)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.pink.opacity(0.3), Color.purple.opacity(0.3)]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(20)
                        .padding(.horizontal)
                        .padding(.top, 10) // Small padding since we removed the header
                        
                        // Motivation Center
                        VStack {
                            HStack {
                                Text("Your Motivation Center")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Spacer()
                                Text("See All")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    QuoteCard(iconName: "Proud Background Removed", title: "Stay positive\nevery day")
                                    QuoteCard(iconName: "happy Background Removed", title: "Embrace the\nlittle things")
                                    QuoteCard(iconName: "Delight Background Removed", title: "Find your\ninner peace")
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Mood Log Chart
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Mood Overview")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    Text("Based on daily mood log")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                HStack {
                                    Text("Week")
                                    Image(systemName: "chevron.down")
                                }
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                            }
                            .padding(.horizontal)
                            
                            // Fake Chart matching glassmorphism
                            HStack(alignment: .bottom, spacing: 12) {
                                ChartBar(value: 0.5, color: Color(hex: "E882F8"), label: "Happiness", pct: "51%")
                                ChartBar(value: 0.7, color: Color(hex: "FF9F43"), label: "Calmness", pct: "72%")
                                ChartBar(value: 0.6, color: Color(hex: "FF5E7E"), label: "Anger", pct: "68%")
                                ChartBar(value: 0.2, color: Color(hex: "4834DF"), label: "Excitement", pct: "25%")
                                ChartBar(value: 0.8, color: Color(hex: "74B9FF"), label: "Sadness", pct: "85%")
                                ChartBar(value: 0.9, color: Color(hex: "A29BFE"), label: "Stress", pct: "86%")
                                ChartBar(value: 0.75, color: Color(hex: "74B9FF"), label: "", pct: "79%")
                                ChartBar(value: 0.5, color: Color(hex: "FF5E7E"), label: "", pct: "50%")
                            }
                            .frame(height: 150)
                            .padding(.horizontal)
                            
                            // Legend
                            HStack(spacing: 10) {
                                LegendItem(color: Color(hex: "E882F8"), text: "Happiness")
                                LegendItem(color: Color(hex: "FF9F43"), text: "Calmness")
                                LegendItem(color: Color(hex: "FF5E7E"), text: "Anger")
                            }
                            .padding(.top, 10)
                            HStack(spacing: 10) {
                                LegendItem(color: Color(hex: "4834DF"), text: "Excitement")
                                LegendItem(color: Color(hex: "74B9FF"), text: "Sadness")
                                LegendItem(color: Color(hex: "A29BFE"), text: "Stress")
                            }
                        }
                        
                        Spacer(minLength: 80) // Space for TabBar
                    }
                    .padding(.vertical)
                }
            } // Close ZStack
            .navigationBarHidden(true)
        }
    }
}

struct QuoteCard: View {
    var iconName: String
    var title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding(10)
                .background(Color.white)
                .clipShape(Circle())
            Spacer()
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
        }
        .padding(16)
        .frame(width: 140, height: 140, alignment: .leading)
        .background(Color.white.opacity(0.65))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.8), lineWidth: 1.5)
        )
    }
}

struct ChartBar: View {
    var value: CGFloat
    var color: Color
    var label: String
    var pct: String
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                VStack {
                    Spacer()
                    ZStack(alignment: .bottom) {
                        Capsule()
                            .fill(color.opacity(0.3))
                            .frame(width: 30, height: geo.size.height)
                        
                        Capsule()
                            .fill(color)
                            .frame(width: 30, height: geo.size.height * value)
                            .overlay(
                                Text(pct)
                                    .font(.system(size: 8))
                                    .foregroundColor(.white)
                                    .padding(.bottom, 8),
                                alignment: .bottom
                            )
                    }
                }
            }
        }
    }
}

struct LegendItem: View {
    var color: Color
    var text: String
    var body: some View {
        HStack(spacing: 4) {
            Circle().fill(color).frame(width: 6, height: 6)
            Text(text).font(.system(size: 10)).foregroundColor(.secondary)
        }
    }
}
