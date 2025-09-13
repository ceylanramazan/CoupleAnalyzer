import Foundation

// MARK: - Word Analysis Models
struct WordUsage: Identifiable, Codable {
    let id = UUID()
    let word: String
    let count: Int
    let sender: String
}

struct LoveWords {
    static let turkishLoveWords = [
        "aşkım", "canım", "bebeğim", "tatlım", "sevgilim", "hayatım", 
        "kalbim", "meleğim", "prensesim", "prens", "güzelim", "güzel",
        "sevgili", "aşk", "sevgi", "kalp", "öpmek", "sarılmak", "öpücük"
    ]
    
    static let englishLoveWords = [
        "love", "baby", "honey", "sweetheart", "darling", "dear", 
        "beloved", "angel", "princess", "prince", "beautiful", "kiss", "hug"
    ]
}

struct NegativeWords {
    static let turkishNegativeWords = [
        "aptal", "salak", "gerizekalı", "mal", "dangalak", "ahmak",
        "sinir", "kızgın", "öfke", "kızdım", "sinirlendim", "üzgün",
        "üzüldüm", "kırdın", "kırıldım", "bozuldu", "bozdun"
    ]
    
    static let englishNegativeWords = [
        "stupid", "idiot", "dumb", "angry", "mad", "upset", "sad",
        "hurt", "broken", "disappointed", "frustrated"
    ]
}

struct WordAnalysis {
    let totalWords: Int
    let mostUsedWords: [WordUsage]
    let loveWordsCount: Int
    let negativeWordsCount: Int
    let positiveNegativeRatio: Double
    let averageWordsPerMessage: Double
    let senderWordUsage: [String: [WordUsage]]
    let mostRepeatedPhrase: String
    let mostRepeatedPhraseCount: Int
    let wordCloud: [String: Int] // Kelime bulutu için
}

// MARK: - Sentiment Analysis
enum Sentiment: String, CaseIterable {
    case positive = "positive"
    case negative = "negative"
    case neutral = "neutral"
    
    var displayName: String {
        switch self {
        case .positive: return "Pozitif"
        case .negative: return "Negatif"
        case .neutral: return "Nötr"
        }
    }
    
    var emoji: String {
        switch self {
        case .positive: return "😊"
        case .negative: return "😔"
        case .neutral: return "😐"
        }
    }
}

struct SentimentAnalysis {
    let positiveCount: Int
    let negativeCount: Int
    let neutralCount: Int
    let overallSentiment: Sentiment
    let sentimentScore: Double // -1.0 to 1.0
    let dailySentimentTrend: [Date: Sentiment]
}

