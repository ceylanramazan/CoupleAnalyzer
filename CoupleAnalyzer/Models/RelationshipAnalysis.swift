import Foundation

// MARK: - Relationship Dynamics Models
struct RelationshipDynamics {
    let conversationStarters: [String: Int] // Kim kaç kez sohbeti başlatmış
    let conversationEnders: [String: Int] // Kim kaç kez sohbeti bitirmiş
    let averageResponseTime: [String: TimeInterval] // Ortalama cevap süresi
    let responseTimeByTimeOfDay: [String: [TimeOfDay: TimeInterval]] // Günün saatine göre cevap süresi
    let messageBalance: Double // Mesaj dengesizliği (0.0 = eşit, 1.0 = tamamen tek taraflı)
    let firstMessageSender: String
    let firstMessageDate: Date
    let firstEmojiDate: Date?
    let firstLoveEmojiDate: Date?
    let firstGoodNightDate: Date?
    let firstGoodMorningDate: Date?
    let totalGoodNights: Int
    let totalGoodMornings: Int
}

enum TimeOfDay: String, CaseIterable {
    case night = "night" // 00:00-06:00
    case morning = "morning" // 06:00-12:00
    case afternoon = "afternoon" // 12:00-18:00
    case evening = "evening" // 18:00-24:00
    
    var displayName: String {
        switch self {
        case .night: return "Gece"
        case .morning: return "Sabah"
        case .afternoon: return "Öğlen"
        case .evening: return "Akşam"
        }
    }
    
    var emoji: String {
        switch self {
        case .night: return "🌙"
        case .morning: return "🌅"
        case .afternoon: return "☀️"
        case .evening: return "🌆"
        }
    }
}

// MARK: - Fun Statistics
struct FunStatistics {
    let recordDay: Date // En çok mesaj atılan gün
    let recordDayMessageCount: Int
    let longestMessage: String
    let shortestMessage: String
    let mostRepeatedSentence: String
    let mostRepeatedSentenceCount: Int
    let funScore: Double // Eğlence puanı (0-100)
    let romanticScore: Double // Romantik puanı (0-100)
    let laughterRatio: Double // Gülme oranı
    let totalConversationDays: Int
    let averageMessagesPerDay: Double
    let longestStreak: Int // En uzun aralıksız konuşma günü
    let longestSilence: Int // En uzun sessizlik günü
}

// MARK: - Overall Analysis Result
struct ChatAnalysisResult {
    let messages: [ChatMessage]
    let messageStats: MessageStats
    let senderComparison: SenderComparison
    let emojiAnalysis: EmojiAnalysis
    let wordAnalysis: WordAnalysis
    let sentimentAnalysis: SentimentAnalysis
    let relationshipDynamics: RelationshipDynamics
    let funStatistics: FunStatistics
    let analysisDate: Date
    let totalAnalysisTime: TimeInterval
}

