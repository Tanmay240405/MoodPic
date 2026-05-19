import SwiftUI

struct OnboardingView: View {
    @Binding var hasOnboarded: Bool
    
    var body: some View {
        ZStack {
            // Base background mimicking the complex yellow-to-pink gradient
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "FF9AD3"), Color(hex: "FF81A6")]),
                    startPoint: .top,
                    endPoint: .bottomTrailing
                )
                
                // Yellow glow overlay at top leading
                RadialGradient(
                    gradient: Gradient(colors: [Color(hex: "FFF6C5"), Color.clear]),
                    center: .topLeading,
                    startRadius: 0,
                    endRadius: 400
                )
            }
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("MoodPic")
                    .font(.headline)
                    .padding(.top, 20) 
                
                Text("Your camera,\nreimagined for\nyour emotions")
                    .font(.system(size: 38, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 30) 
                
                Text("Organize photos by emotion instead of folders. Build a visual mood map to discover your emotional trends over time.")
                    .font(.system(size: 16))
                    .foregroundColor(Color.black.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 64)
                    .padding(.top, 16)
                
                Button(action: {
                    withAnimation {
                        hasOnboarded = true
                    }
                }) {
                    HStack(spacing: 12) {
                        Text("Get Started")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.leading, 12)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.black)
                            .clipShape(Circle())
                    }
                    .padding(6)
                    .background(Color.white.opacity(0.85)) // Semi-transparent whitish pink
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(Color.white, lineWidth: 1.5) // Faint border
                    )
                }
                .padding(.top, 40) // Pushed button down a bit
                
                Spacer() // Pushes the image down to the bottom
                
                // Emulate the 3D blobs at the bottom using the provided image
                Image("OnboardingAvatars")
                    .resizable()
                    .scaledToFit()
                    // Make it 20% larger than the screen so it bleeds edge-to-edge heavily
                    .frame(width: UIScreen.main.bounds.width * 1.2)
                    // Push it way down so the flat bottoms are completely hidden
                    .padding(.bottom, -60)
                    .offset(y: 40)
            }
            .ignoresSafeArea(edges: .bottom) // Critical to ensure the image hits the bottom edge of the phone
        }
    }
}
