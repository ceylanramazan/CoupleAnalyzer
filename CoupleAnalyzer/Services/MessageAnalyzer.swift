import Foundation

// MARK: - Message Analyzer Service
class MessageAnalyzer {
    
    // MARK: - Message Statistics Analysis
    static func analyzeMessageStats(_ messages: [ChatMessage]) -> MessageStats {
        let totalMessages = messages.count
        let averageLength = Double(messages.map { $0.content.count }.reduce(0, +)) / Double(totalMessages)
        
        let longestMessage = messages.max { $0.content.count < $1.content.count }?.content ?? ""
        let shortestMessage = messages.min { $0.content.count < $1.content.count }?.content ?? ""
        
        // En aktif saat analizi
        let hourCounts = Dictionary(grouping: messages) { Calendar.current.component(.hour, from: $0.timestamp) }
            .mapValues { $0.count }
        let mostActiveHour = hourCounts.max { $0.value < $1.value }?.key ?? 0
        
        // En aktif gün analizi
        let dayCounts = Dictionary(grouping: messages) { 
            DateFormatter.dayFormatter.string(from: $0.timestamp) 
        }.mapValues { $0.count }
        let mostActiveDay = dayCounts.max { $0.value < $1.value }?.key ?? ""
        
        // En uzun konuşma ve sessizlik analizi
        let (longestConversation, longestSilence) = analyzeConversationGaps(messages)
        
        return MessageStats(
            totalMessages: totalMessages,
            averageMessageLength: averageLength,
            longestMessage: longestMessage,
            shortestMessage: shortestMessage,
            mostActiveHour: mostActiveHour,
            mostActiveDay: mostActiveDay,
            longestConversation: longestConversation,
            longestSilence: longestSilence
        )
    }
    
    // MARK: - Sender Comparison Analysis
    static func analyzeSenderComparison(_ messages: [ChatMessage]) -> SenderComparison? {
        guard let firstMessage = messages.first else { return nil }
        
        let senders = Set(messages.map { $0.sender }).filter { !$0.isEmpty }
        guard senders.count == 2 else { return nil }
        
        let sender1 = senders.first!
        let sender2 = senders.dropFirst().first!
        
        let sender1Messages = messages.filter { $0.sender == sender1 }
        let sender2Messages = messages.filter { $0.sender == sender2 }
        
        let sender1Count = sender1Messages.count
        let sender2Count = sender2Messages.count
        
        let sender1AvgLength = Double(sender1Messages.map { $0.content.count }.reduce(0, +)) / Double(sender1Count)
        let sender2AvgLength = Double(sender2Messages.map { $0.content.count }.reduce(0, +)) / Double(sender2Count)
        
        let (sender1ResponseTime, sender2ResponseTime) = calculateResponseTimes(messages, sender1: sender1, sender2: sender2)
        let (starterRatio, enderRatio) = calculateConversationPatterns(messages, sender1: sender1, sender2: sender2)
        
        return SenderComparison(
            sender1: sender1,
            sender2: sender2,
            sender1MessageCount: sender1Count,
            sender2MessageCount: sender2Count,
            sender1AverageLength: sender1AvgLength,
            sender2AverageLength: sender2AvgLength,
            sender1ResponseTime: sender1ResponseTime,
            sender2ResponseTime: sender2ResponseTime,
            conversationStarterRatio: starterRatio,
            conversationEnderRatio: enderRatio
        )
    }
    
    // MARK: - Private Helper Methods
    private static func analyzeConversationGaps(_ messages: [ChatMessage]) -> (TimeInterval, TimeInterval) {
        guard messages.count > 1 else {
            return (0, 0)
        }
        
        let sortedMessages = messages.sorted { $0.timestamp < $1.timestamp }
        var longestConversation: TimeInterval = 0
        var longestSilence: TimeInterval = 0
        
        for i in 0..<sortedMessages.count - 1 {
            let currentMessage = sortedMessages[i]
            let nextMessage = sortedMessages[i + 1]
            
            let timeDiff = nextMessage.timestamp.timeIntervalSince(currentMessage.timestamp)
            
            // 5 dakikadan az ise konuşma devam ediyor
            if timeDiff < 300 {
                longestConversation = max(longestConversation, timeDiff)
            } else {
                // 5 dakikadan fazla ise sessizlik
                longestSilence = max(longestSilence, timeDiff)
            }
        }
        
        return (longestConversation, longestSilence)
    }
    
    private static func calculateResponseTimes(_ messages: [ChatMessage], sender1: String, sender2: String) -> (TimeInterval, TimeInterval) {
        guard messages.count > 1 else {
            return (0, 0)
        }
        
        let sortedMessages = messages.sorted { $0.timestamp < $1.timestamp }
        var sender1ResponseTimes: [TimeInterval] = []
        var sender2ResponseTimes: [TimeInterval] = []
        
        for i in 0..<sortedMessages.count - 1 {
            let currentMessage = sortedMessages[i]
            let nextMessage = sortedMessages[i + 1]
            
            // Farklı kişilerden mesaj geliyorsa cevap süresi hesapla
            if currentMessage.sender != nextMessage.sender {
                let responseTime = nextMessage.timestamp.timeIntervalSince(currentMessage.timestamp)
                
                if nextMessage.sender == sender1 {
                    sender1ResponseTimes.append(responseTime)
                } else if nextMessage.sender == sender2 {
                    sender2ResponseTimes.append(responseTime)
                }
            }
        }
        
        let avgSender1Response = sender1ResponseTimes.isEmpty ? 0 : sender1ResponseTimes.reduce(0, +) / Double(sender1ResponseTimes.count)
        let avgSender2Response = sender2ResponseTimes.isEmpty ? 0 : sender2ResponseTimes.reduce(0, +) / Double(sender2ResponseTimes.count)
        
        return (avgSender1Response, avgSender2Response)
    }
    
    private static func calculateConversationPatterns(_ messages: [ChatMessage], sender1: String, sender2: String) -> (Double, Double) {
        let sortedMessages = messages.sorted { $0.timestamp < $1.timestamp }
        var sender1Starts = 0
        var sender2Starts = 0
        var sender1Ends = 0
        var sender2Ends = 0
        
        // Sohbet başlatma analizi (günlük bazda)
        let dailyMessages = Dictionary(grouping: sortedMessages) { 
            Calendar.current.startOfDay(for: $0.timestamp) 
        }
        
        for (_, dayMessages) in dailyMessages {
            if let firstMessage = dayMessages.first {
                if firstMessage.sender == sender1 {
                    sender1Starts += 1
                } else {
                    sender2Starts += 1
                }
            }
            
            if let lastMessage = dayMessages.last {
                if lastMessage.sender == sender1 {
                    sender1Ends += 1
                } else {
                    sender2Ends += 1
                }
            }
        }
        
        let totalStarts = sender1Starts + sender2Starts
        let totalEnds = sender1Ends + sender2Ends
        
        let starterRatio = totalStarts > 0 ? Double(sender1Starts) / Double(totalStarts) : 0.5
        let enderRatio = totalEnds > 0 ? Double(sender1Ends) / Double(totalEnds) : 0.5
        
        return (starterRatio, enderRatio)
    }
    
    // MARK: - Emoji Analysis
    static func analyzeEmojis(_ messages: [ChatMessage]) -> EmojiAnalysis {
        var emojiCounts: [String: Int] = [:]
        var senderEmojiUsage: [String: [EmojiUsage]] = [:]
        var emojiTrendOverTime: [Date: Int] = [:]
        var categoryCounts: [EmojiCategory: Int] = [:]
        
        // Initialize category counts
        for category in EmojiCategory.allCases {
            categoryCounts[category] = 0
        }
        
        // Initialize sender emoji usage
        let senders = Set(messages.map { $0.sender }).filter { !$0.isEmpty }
        for sender in senders {
            senderEmojiUsage[sender] = []
        }
        
        // Analyze each message
        for message in messages {
            let emojis = extractEmojisFromText(message.content)
            
            // Count emojis by date
            let dateKey = Calendar.current.startOfDay(for: message.timestamp)
            emojiTrendOverTime[dateKey, default: 0] += emojis.count
            
            // Count emojis globally and by sender
            for emoji in emojis {
                emojiCounts[emoji, default: 0] += 1
                
                // Categorize emoji
                let category = categorizeEmoji(emoji)
                categoryCounts[category, default: 0] += 1
                
                // Track by sender
                if let existingUsage = senderEmojiUsage[message.sender]?.first(where: { $0.emoji == emoji }) {
                    // Update existing usage count
                    if let index = senderEmojiUsage[message.sender]?.firstIndex(where: { $0.emoji == emoji }) {
                        senderEmojiUsage[message.sender]?[index] = EmojiUsage(
                            emoji: emoji,
                            count: existingUsage.count + 1,
                            sender: message.sender,
                            category: category
                        )
                    }
                } else {
                    // Add new emoji usage
                    senderEmojiUsage[message.sender, default: []].append(
                        EmojiUsage(emoji: emoji, count: 1, sender: message.sender, category: category)
                    )
                }
            }
        }
        
        // Find most used emoji
        let mostUsedEmoji = emojiCounts.max { $0.value < $1.value }?.key ?? ""
        let mostUsedEmojiCount = emojiCounts[mostUsedEmoji] ?? 0
        
        // Calculate love and laughter emoji counts
        let loveEmojiCount = categoryCounts[.love] ?? 0
        let laughterEmojiCount = categoryCounts[.laughter] ?? 0
        
        // Find romantic day (day with most love emojis)
        var romanticDay: Date?
        var maxLoveEmojis = 0
        for (date, count) in emojiTrendOverTime {
            let dayMessages = messages.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: date) }
            let dayLoveEmojis = dayMessages.flatMap { extractEmojisFromText($0.content) }
                .filter { categorizeEmoji($0) == .love }
                .count
            
            if dayLoveEmojis > maxLoveEmojis {
                maxLoveEmojis = dayLoveEmojis
                romanticDay = date
            }
        }
        
        // Calculate laughter ratio
        let totalMessages = messages.count
        let laughterRatio = totalMessages > 0 ? Double(laughterEmojiCount) / Double(totalMessages) : 0.0
        
        return EmojiAnalysis(
            totalEmojis: emojiCounts.values.reduce(0, +),
            mostUsedEmoji: mostUsedEmoji,
            mostUsedEmojiCount: mostUsedEmojiCount,
            categoryDistribution: categoryCounts,
            senderEmojiUsage: senderEmojiUsage,
            emojiTrendOverTime: emojiTrendOverTime,
            loveEmojiCount: loveEmojiCount,
            laughterEmojiCount: laughterEmojiCount,
            romanticDay: romanticDay,
            laughterRatio: laughterRatio
        )
    }
    
    // MARK: - Helper Methods
    private static func extractEmojisFromText(_ text: String) -> [String] {
        let emojiPattern = "[\\p{So}\\p{Cn}]"
        let regex = try? NSRegularExpression(pattern: emojiPattern, options: [])
        let range = NSRange(location: 0, length: text.utf16.count)
        
        var emojis: [String] = []
        regex?.enumerateMatches(in: text, options: [], range: range) { match, _, _ in
            if let matchRange = match?.range {
                let emoji = (text as NSString).substring(with: matchRange)
                if emoji.unicodeScalars.allSatisfy({ $0.properties.isEmoji }) {
                    emojis.append(emoji)
                }
            }
        }
        return emojis
    }
    
    private static func categorizeEmoji(_ emoji: String) -> EmojiCategory {
        for category in EmojiCategory.allCases {
            if category.emojis.contains(emoji) {
                return category
            }
        }
        return .neutral
    }
}

// MARK: - Date Formatter Extension
extension DateFormatter {
    static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter
    }()
}
