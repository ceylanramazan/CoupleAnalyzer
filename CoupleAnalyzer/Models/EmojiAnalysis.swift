import Foundation
import SwiftUI

// MARK: - Emoji Analysis Models
struct EmojiUsage: Identifiable, Codable {
    let id = UUID()
    let emoji: String
    let count: Int
    let sender: String
    let category: EmojiCategory
}

enum EmojiCategory: String, CaseIterable, Codable {
    case love = "love"
    case laughter = "laughter"
    case anger = "anger"
    case surprise = "surprise"
    case sadness = "sadness"
    case neutral = "neutral"
    
    var displayName: String {
        switch self {
        case .love: return "Sevgi"
        case .laughter: return "Kahkaha"
        case .anger: return "Sinir"
        case .surprise: return "Şaşkınlık"
        case .sadness: return "Üzüntü"
        case .neutral: return "Nötr"
        }
    }
    
    var color: Color {
        switch self {
        case .love: return .pink
        case .laughter: return .yellow
        case .anger: return .red
        case .surprise: return .orange
        case .sadness: return .blue
        case .neutral: return .gray
        }
    }
    
    var emojis: [String] {
        switch self {
        case .love: return ["❤️", "💕", "💖", "💗", "💘", "💝", "💞", "💟", "😍", "🥰", "😘", "💋", "🌹", "💐"]
        case .laughter: return ["😂", "🤣", "😆", "😄", "😃", "😁", "😊", "😅", "🤭", "😜", "😝", "🤪"]
        case .anger: return ["😡", "😠", "🤬", "😤", "😾", "💢", "🔥", "⚡"]
        case .surprise: return ["😮", "😯", "😲", "🤯", "😱", "😳", "🙄", "😏"]
        case .sadness: return ["😢", "😭", "😔", "😞", "😟", "😕", "🙁", "☹️", "😿"]
        case .neutral: return ["😐", "😑", "😶", "🤐", "😴", "😪", "🤤", "😵"]
        }
    }
}

struct EmojiAnalysis {
    let totalEmojis: Int
    let mostUsedEmoji: String
    let mostUsedEmojiCount: Int
    let categoryDistribution: [EmojiCategory: Int]
    let senderEmojiUsage: [String: [EmojiUsage]]
    let emojiTrendOverTime: [Date: Int]
    let loveEmojiCount: Int
    let laughterEmojiCount: Int
    let romanticDay: Date? // En çok ❤️ kullanılan gün
    let laughterRatio: Double // 😂 kullanım sayısı / toplam mesaj sayısı
}
