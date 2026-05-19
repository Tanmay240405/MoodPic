import SwiftUI

struct AnalyticsView: View {
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
                        // Header
                        HStack {
                            Button(action: {}) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.black)
                                    .padding(12)
                                    .background(Color.white.opacity(0.7))
                                    .clipShape(Circle())
                            }
                            Spacer()
                            Text("Analytics")
                                .font(.headline)
                            Spacer()
                            Button(action: {}) {
                                Image(systemName: "gearshape")
                                    .foregroundColor(.black)
                                    .padding(12)
                                    .background(Color.white.opacity(0.7))
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("My Weekly Insights")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            // Mood and Daily Reflections Card
                            VStack(alignment: .leading) {
                                Text("Mood and Daily Reflections")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Spacer()
                                
                                // Pile of big overlapping avatars
                                ZStack {
                                    Image("Proud Background Removed")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 110, height: 110)
                                        .offset(x: 60, y: -45)
                                    
                                    Image("Disgusted Background Removed")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 105, height: 105)
                                        .offset(x: -100, y: -5)
                                    
                                    Image("happy Background Removed")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 125, height: 125)
                                        .offset(x: -25, y: -35)
                                        
                                    Image("Sad Background Removed")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 110, height: 110)
                                        .offset(x: 105, y: 10)
                                    
                                    Image("Delight Background Removed")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 135, height: 135)
                                        .offset(x: 10, y: 35)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 180)
                                
                                Spacer()
                                
                                // Days
                                HStack(spacing: 8) {
                                    DayButton(day: "Sun", isSelected: true)
                                    DayButton(day: "Mon", isSelected: false)
                                    DayButton(day: "Tue", isSelected: false)
                                    DayButton(day: "Wed", isSelected: false)
                                    DayButton(day: "Thu", isSelected: false)
                                    DayButton(day: "Fri", isSelected: false)
                                    DayButton(day: "Sat", isSelected: false)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .padding(20)
                            .background(Color.white.opacity(0.65)) // Glass effect
                            .cornerRadius(24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.white.opacity(0.8), lineWidth: 1.5)
                            )
                            .padding(.horizontal)
                            
                            // Stats
                            HStack(spacing: 12) {
                                StatCard(title: "Activity", value: "101,513", subtitle: "Steps")
                                StatCard(title: "Therapy", value: "10/30", subtitle: "Sessions")
                                StatCard(title: "Discipline", value: "88%", subtitle: "Focus Score")
                            }
                            .padding(.horizontal)
                            
                            // Mood Tips
                            VStack {
                                HStack {
                                    Text("Mood Tips")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text("See All")
                                        .font(.caption)
                                        .foregroundColor(Color.black.opacity(0.5))
                                }
                                .padding(.horizontal)
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Today's Note")
                                            .font(.caption)
                                            .foregroundColor(.black.opacity(0.6))
                                        Text("Keep it Up and Project\nYour Mood Now!")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                    }
                                    Spacer()
                                    ZStack {
                                        Image("happy Background Removed")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                            .offset(x: -15, y: -15)
                                        Image("Delight Background Removed")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .offset(x: 10, y: 15)
                                    }
                                }
                                .padding(20)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.pink.opacity(0.4), Color.orange.opacity(0.4)]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white.opacity(0.6), lineWidth: 1)
                                )
                                .padding(.horizontal)
                            }
                        }
                        Spacer(minLength: 80)
                    }
                    .padding(.vertical)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct DayButton: View {
    var day: String
    var isSelected: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "plus")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(isSelected ? .white : .black)
                .frame(width: 36, height: 36)
                .background(isSelected ? Color.black : Color.white.opacity(0.6))
                .clipShape(Circle())
            
            Text(day)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(isSelected ? .black : Color.black.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
    }
}

struct StatCard: View {
    var title: String
    var value: String
    var subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(Color.black.opacity(0.6))
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(Color.black.opacity(0.6))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.65))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.8), lineWidth: 1.5)
        )
    }
}
