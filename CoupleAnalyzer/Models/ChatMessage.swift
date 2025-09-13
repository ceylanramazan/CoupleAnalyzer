import Foundation

// MARK: - Chat Message Model
struct ChatMessage: Identifiable, Codable {
    let id = UUID()
    let timestamp: Date
    let sender: String
    let content: String
    let isSystemMessage: Bool
    
    init(timestamp: Date, sender: String, content: String, isSystemMessage: Bool = false) {
        self.timestamp = timestamp
        self.sender = sender
        self.content = content
        self.isSystemMessage = isSystemMessage
    }
}

// MARK: - Message Statistics
struct MessageStats {
    let totalMessages: Int
    let averageMessageLength: Double
    let longestMessage: String
    let shortestMessage: String
    let mostActiveHour: Int
    let mostActiveDay: String
    let longestConversation: TimeInterval
    let longestSilence: TimeInterval
}

// MARK: - Sender Comparison
struct SenderComparison {
    let sender1: String
    let sender2: String
    let sender1MessageCount: Int
    let sender2MessageCount: Int
    let sender1AverageLength: Double
    let sender2AverageLength: Double
    let sender1ResponseTime: TimeInterval
    let sender2ResponseTime: TimeInterval
    let conversationStarterRatio: Double // sender1 / total
    let conversationEnderRatio: Double // sender1 / total
}

