import Foundation
import SwiftUI

enum MoodType: String, CaseIterable, Identifiable, Codable {
    case happy      = "Happy"
    case proud      = "Proud"
    case delight    = "Delighted"
    case nervous    = "Nervous"
    case bored      = "Bored"
    case confused   = "Confused"
    case disgusted  = "Disgusted"
    case embarrassed = "Embarrassed"
    case fear       = "Fearful"
    case sad        = "Sad"
    case shocked    = "Shocked"
    
    var id: String { self.rawValue }
    
    var color: Color {
        switch self {
        case .happy:       return Color(hex: "FFD166")  // warm yellow
        case .proud:       return Color(hex: "A29BFE")  // soft purple
        case .delight:     return Color(hex: "FFA07A")  // light salmon
        case .nervous:     return Color(hex: "74B9FF")  // sky blue
        case .bored:       return Color(hex: "B2BEC3")  // grey-blue
        case .confused:    return Color(hex: "FDCB6E")  // amber
        case .disgusted:   return Color(hex: "55EFC4")  // mint
        case .embarrassed: return Color(hex: "FF7675")  // coral
        case .fear:        return Color(hex: "6C5CE7")  // deep purple
        case .sad:         return Color(hex: "74B9FF")  // blue
        case .shocked:     return Color(hex: "E17055")  // burnt orange
        }
    }
    
    var emoji: String {
        switch self {
        case .happy:       return "😊"
        case .proud:       return "😤"
        case .delight:     return "😄"
        case .nervous:     return "😰"
        case .bored:       return "😑"
        case .confused:    return "😕"
        case .disgusted:   return "🤢"
        case .embarrassed: return "😳"
        case .fear:        return "😨"
        case .sad:         return "😢"
        case .shocked:     return "😱"
        }
    }
    
    var imageName: String {
        switch self {
        case .happy:       return "happy Background Removed"
        case .proud:       return "Proud Background Removed"
        case .delight:     return "Delight Background Removed"
        case .nervous:     return "Nervous Background Removed"
        case .bored:       return "Bored Background Removed"
        case .confused:    return "Confused Background Removed"
        case .disgusted:   return "Disgusted Background Removed"
        case .embarrassed: return "Embarassed Background Removed"
        case .fear:        return "Fear Background Removed"
        case .sad:         return "Sad Background Removed"
        case .shocked:     return "Shocked Background Removed"
        }
    }
}

struct MoodEntry: Identifiable, Codable {
    var id = UUID()
    let mood: MoodType
    let reason: String
    let photoData: Data?
    let date: Date
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
