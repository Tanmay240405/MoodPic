import SwiftUI
import PhotosUI

struct AddMoodView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var moodStore: MoodStore
    
    @State private var selectedMood: MoodType = .happy
    @State private var reason: String = ""
    @State private var image: UIImage?
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showActionSheet = false
    @State private var step: Int = 1   // 1 = photo pick, 2 = mood select
    
    var body: some View {
        NavigationView {
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
                    VStack(spacing: 24) {
                        
                        if step == 1 {
                            // STEP 1: Pick a photo
                            stepOneView
                        } else {
                            // STEP 2: Choose mood
                            stepTwoView
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle(step == 1 ? "📸 New Memory" : "How does it feel?")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $image, sourceType: sourceType)
            }
        }
    }
    
    // MARK: - Step 1: Photo Picker
    var stepOneView: some View {
        VStack(spacing: 24) {
            // Photo preview / placeholder
            Button(action: { showActionSheet = true }) {
                ZStack {
                    if let img = image {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 320)
                            .clipShape(RoundedRectangle(cornerRadius: 32))
                    } else {
                        RoundedRectangle(cornerRadius: 32)
                            .fill(Color.white.opacity(0.65))
                            .frame(maxWidth: .infinity)
                            .frame(height: 320)
                            .overlay(
                                VStack(spacing: 16) {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 44))
                                        .foregroundColor(.black.opacity(0.4))
                                    Text("Tap to add a photo")
                                        .font(.headline)
                                        .foregroundColor(.black.opacity(0.5))
                                }
                            )
                    }
                }
            }
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(title: Text("Add a Photo"), buttons: [
                    .default(Text("📷  Camera")) {
                        sourceType = .camera
                        showImagePicker = true
                    },
                    .default(Text("🖼️  Photo Library")) {
                        sourceType = .photoLibrary
                        showImagePicker = true
                    },
                    .cancel()
                ])
            }
            .padding(.horizontal, 20)
            
            // Next button — only active when a photo is chosen
            Button(action: { withAnimation { step = 2 } }) {
                HStack {
                    Text(image == nil ? "Skip photo, choose mood →" : "Next: Choose Mood →")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(image == nil ? Color.black.opacity(0.2) : Color.black)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Step 2: Mood Selector
    var stepTwoView: some View {
        VStack(spacing: 24) {
            // Show chosen photo thumbnail
            if let img = image {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.horizontal, 20)
            }
            
            // Mood avatar grid
            Text("Pick your mood")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(MoodType.allCases) { mood in
                    Button(action: { selectedMood = mood }) {
                        VStack(spacing: 8) {
                            Image(mood.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 64, height: 64)
                                .padding(12)
                                .background(
                                    Circle()
                                        .fill(selectedMood == mood ? mood.color.opacity(0.35) : Color.white.opacity(0.65))
                                )
                                .overlay(
                                    Circle()
                                        .stroke(selectedMood == mood ? mood.color : Color.clear, lineWidth: 3)
                                )
                                .scaleEffect(selectedMood == mood ? 1.1 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedMood)
                            
                            Text(mood.rawValue)
                                .font(.caption)
                                .fontWeight(selectedMood == mood ? .bold : .regular)
                                .foregroundColor(.black.opacity(0.7))
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            
            // Optional note
            VStack(alignment: .leading, spacing: 8) {
                Text("Add a note (optional)")
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.5))
                
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.65))
                        .frame(height: 100)
                    
                    TextEditor(text: $reason)
                        .frame(height: 100)
                        .padding(8)
                        .background(Color.clear)
                        .scrollContentBackground(.hidden)
                    
                    if reason.isEmpty {
                        Text("What's on your mind?")
                            .foregroundColor(.gray.opacity(0.6))
                            .padding(14)
                            .allowsHitTesting(false)
                    }
                }
            }
            .padding(.horizontal, 20)
            
            // Action row
            HStack(spacing: 12) {
                Button(action: { withAnimation { step = 1 } }) {
                    Text("← Back")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.65))
                        .foregroundColor(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                
                Button(action: saveMood) {
                    Text("Save 🎉")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    func saveMood() {
        moodStore.addMood(
            mood: selectedMood,
            reason: reason.isEmpty ? selectedMood.rawValue : reason,
            photoData: image?.jpegData(compressionQuality: 0.8)
        )
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Image Picker Bridge
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = UIImagePickerController.isSourceTypeAvailable(sourceType) ? sourceType : .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage { parent.image = uiImage }
            picker.dismiss(animated: true)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { picker.dismiss(animated: true) }
    }
}

