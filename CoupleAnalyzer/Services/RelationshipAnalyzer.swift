import Foundation

// MARK: - Relationship Analyzer Service
class RelationshipAnalyzer {
    
    // MARK: - Main Relationship Analysis
    static func analyzeRelationshipDynamics(_ messages: [ChatMessage]) -> RelationshipDynamics {
        let sortedMessages = messages.sorted { $0.timestamp < $1.timestamp }
        
        // Sohbet başlatma ve bitirme analizi
        let (conversationStarters, conversationEnders) = analyzeConversationPatterns(sortedMessages)
        
        // Cevap süresi analizi
        let averageResponseTime = calculateAverageResponseTimes(sortedMessages)
        let responseTimeByTimeOfDay = calculateResponseTimeByTimeOfDay(sortedMessages)
        
        // Mesaj dengesizliği
        let messageBalance = calculateMessageBalance(sortedMessages)
        
        // İlk mesaj analizi
        let firstMessageSender = sortedMessages.first?.sender ?? ""
        let firstMessageDate = sortedMessages.first?.timestamp ?? Date()
        
        // İlk emoji ve sevgi emojisi tarihleri
        let firstEmojiDate = findFirstEmojiDate(sortedMessages)
        let firstLoveEmojiDate = findFirstLoveEmojiDate(sortedMessages)
        
        // İlk "iyi geceler" ve "günaydın" tarihleri
        let firstGoodNightDate = findFirstGoodNightDate(sortedMessages)
        let firstGoodMorningDate = findFirstGoodMorningDate(sortedMessages)
        
        // Toplam "iyi geceler" ve "günaydın" sayıları
        let totalGoodNights = countGoodNights(sortedMessages)
        let totalGoodMornings = countGoodMornings(sortedMessages)
        
        return RelationshipDynamics(
            conversationStarters: conversationStarters,
            conversationEnders: conversationEnders,
            averageResponseTime: averageResponseTime,
            responseTimeByTimeOfDay: responseTimeByTimeOfDay,
            messageBalance: messageBalance,
            firstMessageSender: firstMessageSender,
            firstMessageDate: firstMessageDate,
            firstEmojiDate: firstEmojiDate,
            firstLoveEmojiDate: firstLoveEmojiDate,
            firstGoodNightDate: firstGoodNightDate,
            firstGoodMorningDate: firstGoodMorningDate,
            totalGoodNights: totalGoodNights,
            totalGoodMornings: totalGoodMornings
        )
    }
    
    // MARK: - Fun Statistics Analysis
    static func analyzeFunStatistics(_ messages: [ChatMessage]) -> FunStatistics {
        let sortedMessages = messages.sorted { $0.timestamp < $1.timestamp }
        
        // Rekor gün (en çok mesaj atılan gün)
        let (recordDay, recordDayMessageCount) = findRecordDay(sortedMessages)
        
        // En uzun ve en kısa mesaj
        let longestMessage = sortedMessages.max { $0.content.count < $1.content.count }?.content ?? ""
        let shortestMessage = sortedMessages.min { $0.content.count < $1.content.count }?.content ?? ""
        
        // En çok tekrar eden cümle
        let (mostRepeatedSentence, mostRepeatedSentenceCount) = findMostRepeatedSentence(sortedMessages)
        
        // Eğlence ve romantik puanları
        let (funScore, romanticScore) = calculateFunAndRomanticScores(sortedMessages)
        
        // Gülme oranı
        let laughterRatio = calculateLaughterRatio(sortedMessages)
        
        // Konuşma günleri analizi
        let totalConversationDays = calculateTotalConversationDays(sortedMessages)
        let averageMessagesPerDay = sortedMessages.isEmpty ? 0 : Double(sortedMessages.count) / Double(totalConversationDays)
        
        // En uzun seri ve sessizlik
        let (longestStreak, longestSilence) = calculateStreaksAndSilences(sortedMessages)
        
        return FunStatistics(
            recordDay: recordDay,
            recordDayMessageCount: recordDayMessageCount,
            longestMessage: longestMessage,
            shortestMessage: shortestMessage,
            mostRepeatedSentence: mostRepeatedSentence,
            mostRepeatedSentenceCount: mostRepeatedSentenceCount,
            funScore: funScore,
            romanticScore: romanticScore,
            laughterRatio: laughterRatio,
            totalConversationDays: totalConversationDays,
            averageMessagesPerDay: averageMessagesPerDay,
            longestStreak: longestStreak,
            longestSilence: longestSilence
        )
    }
    
    // MARK: - Private Helper Methods
    private static func analyzeConversationPatterns(_ messages: [ChatMessage]) -> ([String: Int], [String: Int]) {
        let dailyMessages = Dictionary(grouping: messages) { 
            Calendar.current.startOfDay(for: $0.timestamp) 
        }
        
        var conversationStarters: [String: Int] = [:]
        var conversationEnders: [String: Int] = [:]
        
        for (_, dayMessages) in dailyMessages {
            let sortedDayMessages = dayMessages.sorted { $0.timestamp < $1.timestamp }
            
            // Günün ilk mesajını başlatıcı olarak say
            if let firstMessage = sortedDayMessages.first {
                conversationStarters[firstMessage.sender, default: 0] += 1
            }
            
            // Günün son mesajını bitirici olarak say
            if let lastMessage = sortedDayMessages.last {
                conversationEnders[lastMessage.sender, default: 0] += 1
            }
        }
        
        return (conversationStarters, conversationEnders)
    }
    
    private static func calculateAverageResponseTimes(_ messages: [ChatMessage]) -> [String: TimeInterval] {
        guard messages.count > 1 else {
            return [:]
        }
        
        let senders = Set(messages.map { $0.sender }).filter { !$0.isEmpty }
        var responseTimes: [String: [TimeInterval]] = [:]
        
        for sender in senders {
            responseTimes[sender] = []
        }
        
        for i in 0..<messages.count - 1 {
            let currentMessage = messages[i]
            let nextMessage = messages[i + 1]
            
            if currentMessage.sender != nextMessage.sender {
                let responseTime = nextMessage.timestamp.timeIntervalSince(currentMessage.timestamp)
                responseTimes[nextMessage.sender]?.append(responseTime)
            }
        }
        
        var averageResponseTimes: [String: TimeInterval] = [:]
        for (sender, times) in responseTimes {
            averageResponseTimes[sender] = times.isEmpty ? 0 : times.reduce(0, +) / Double(times.count)
        }
        
        return averageResponseTimes
    }
    
    private static func calculateResponseTimeByTimeOfDay(_ messages: [ChatMessage]) -> [String: [TimeOfDay: TimeInterval]] {
        guard messages.count > 1 else {
            return [:]
        }
        
        let senders = Set(messages.map { $0.sender }).filter { !$0.isEmpty }
        var responseTimesByTime: [String: [TimeOfDay: [TimeInterval]]] = [:]
        
        for sender in senders {
            responseTimesByTime[sender] = [:]
            for timeOfDay in TimeOfDay.allCases {
                responseTimesByTime[sender]?[timeOfDay] = []
            }
        }
        
        for i in 0..<messages.count - 1 {
            let currentMessage = messages[i]
            let nextMessage = messages[i + 1]
            
            if currentMessage.sender != nextMessage.sender {
                let responseTime = nextMessage.timestamp.timeIntervalSince(currentMessage.timestamp)
                let timeOfDay = getTimeOfDay(from: nextMessage.timestamp)
                responseTimesByTime[nextMessage.sender]?[timeOfDay]?.append(responseTime)
            }
        }
        
        var averageResponseTimesByTime: [String: [TimeOfDay: TimeInterval]] = [:]
        for (sender, timeData) in responseTimesByTime {
            averageResponseTimesByTime[sender] = [:]
            for (timeOfDay, times) in timeData {
                averageResponseTimesByTime[sender]?[timeOfDay] = times.isEmpty ? 0 : times.reduce(0, +) / Double(times.count)
            }
        }
        
        return averageResponseTimesByTime
    }
    
    private static func getTimeOfDay(from date: Date) -> TimeOfDay {
        let hour = Calendar.current.component(.hour, from: date)
        switch hour {
        case 0..<6: return .night
        case 6..<12: return .morning
        case 12..<18: return .afternoon
        default: return .evening
        }
    }
    
    private static func calculateMessageBalance(_ messages: [ChatMessage]) -> Double {
        let senders = Set(messages.map { $0.sender }).filter { !$0.isEmpty }
        guard senders.count == 2 else { return 0.5 }
        
        let sender1 = senders.first!
        let sender1Count = messages.filter { $0.sender == sender1 }.count
        let totalCount = messages.count
        
        return Double(sender1Count) / Double(totalCount)
    }
    
    private static func findFirstEmojiDate(_ messages: [ChatMessage]) -> Date? {
        for message in messages {
            if !extractEmojisFromText(message.content).isEmpty {
                return message.timestamp
            }
        }
        return nil
    }
    
    private static func findFirstLoveEmojiDate(_ messages: [ChatMessage]) -> Date? {
        for message in messages {
            let emojis = extractEmojisFromText(message.content)
            if emojis.contains(where: { EmojiCategory.love.emojis.contains($0) }) {
                return message.timestamp
            }
        }
        return nil
    }
    
    private static func findFirstGoodNightDate(_ messages: [ChatMessage]) -> Date? {
        let goodNightPhrases = ["iyi geceler", "good night", "gece geceler", "tatlı rüyalar"]
        
        for message in messages {
            let content = message.content.lowercased()
            if goodNightPhrases.contains(where: { content.contains($0) }) {
                return message.timestamp
            }
        }
        return nil
    }
    
    private static func findFirstGoodMorningDate(_ messages: [ChatMessage]) -> Date? {
        let goodMorningPhrases = ["günaydın", "good morning", "gün aydın", "sabah şerifler"]
        
        for message in messages {
            let content = message.content.lowercased()
            if goodMorningPhrases.contains(where: { content.contains($0) }) {
                return message.timestamp
            }
        }
        return nil
    }
    
    private static func countGoodNights(_ messages: [ChatMessage]) -> Int {
        let goodNightPhrases = ["iyi geceler", "good night", "gece geceler", "tatlı rüyalar"]
        var count = 0
        
        for message in messages {
            let content = message.content.lowercased()
            if goodNightPhrases.contains(where: { content.contains($0) }) {
                count += 1
            }
        }
        
        return count
    }
    
    private static func countGoodMornings(_ messages: [ChatMessage]) -> Int {
        let goodMorningPhrases = ["günaydın", "good morning", "gün aydın", "sabah şerifler"]
        var count = 0
        
        for message in messages {
            let content = message.content.lowercased()
            if goodMorningPhrases.contains(where: { content.contains($0) }) {
                count += 1
            }
        }
        
        return count
    }
    
    private static func findRecordDay(_ messages: [ChatMessage]) -> (Date, Int) {
        let dailyMessages = Dictionary(grouping: messages) { 
            Calendar.current.startOfDay(for: $0.timestamp) 
        }
        
        let maxDay = dailyMessages.max { $0.value.count < $1.value.count }
        return (maxDay?.key ?? Date(), maxDay?.value.count ?? 0)
    }
    
    private static func findMostRepeatedSentence(_ messages: [ChatMessage]) -> (String, Int) {
        var sentenceCounts: [String: Int] = [:]
        
        for message in messages {
            let content = message.content.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            if !content.isEmpty {
                sentenceCounts[content, default: 0] += 1
            }
        }
        
        let mostRepeated = sentenceCounts.max { $0.value < $1.value }
        return (mostRepeated?.key ?? "", mostRepeated?.value ?? 0)
    }
    
    private static func calculateFunAndRomanticScores(_ messages: [ChatMessage]) -> (Double, Double) {
        let totalMessages = messages.count
        guard totalMessages > 0 else { return (0, 0) }
        
        var funScore = 0.0
        var romanticScore = 0.0
        
        for message in messages {
            let content = message.content.lowercased()
            
            // Eğlence puanı (emoji, kahkaha, pozitif kelimeler)
            let emojiCount = extractEmojisFromText(message.content).count
            let laughterEmojis = extractEmojisFromText(message.content).filter { EmojiCategory.laughter.emojis.contains($0) }.count
            let positiveWords = LoveWords.turkishLoveWords.filter { content.contains($0) }.count
            
            funScore += Double(emojiCount) * 0.1 + Double(laughterEmojis) * 0.5 + Double(positiveWords) * 0.2
            
            // Romantik puanı (sevgi emojileri, romantik kelimeler)
            let loveEmojis = extractEmojisFromText(message.content).filter { EmojiCategory.love.emojis.contains($0) }.count
            let romanticWords = LoveWords.turkishLoveWords.filter { content.contains($0) }.count
            
            romanticScore += Double(loveEmojis) * 0.8 + Double(romanticWords) * 0.3
        }
        
        // 0-100 aralığına normalize et
        funScore = min(100, max(0, funScore / Double(totalMessages) * 10))
        romanticScore = min(100, max(0, romanticScore / Double(totalMessages) * 10))
        
        return (funScore, romanticScore)
    }
    
    private static func calculateLaughterRatio(_ messages: [ChatMessage]) -> Double {
        let totalMessages = messages.count
        guard totalMessages > 0 else { return 0 }
        
        let laughterEmojiCount = messages.flatMap { extractEmojisFromText($0.content) }
            .filter { EmojiCategory.laughter.emojis.contains($0) }
            .count
        
        return Double(laughterEmojiCount) / Double(totalMessages)
    }
    
    private static func calculateTotalConversationDays(_ messages: [ChatMessage]) -> Int {
        let uniqueDays = Set(messages.map { Calendar.current.startOfDay(for: $0.timestamp) })
        return uniqueDays.count
    }
    
    private static func calculateStreaksAndSilences(_ messages: [ChatMessage]) -> (Int, Int) {
        let dailyMessages = Dictionary(grouping: messages) { 
            Calendar.current.startOfDay(for: $0.timestamp) 
        }
        
        let sortedDays = dailyMessages.keys.sorted()
        guard sortedDays.count > 1 else {
            return (0, 0)
        }
        
        var currentStreak = 0
        var maxStreak = 0
        var currentSilence = 0
        var maxSilence = 0
        
        for i in 0..<sortedDays.count - 1 {
            let currentDay = sortedDays[i]
            let nextDay = sortedDays[i + 1]
            
            let daysBetween = Calendar.current.dateComponents([.day], from: currentDay, to: nextDay).day ?? 0
            
            if daysBetween == 1 {
                // Ardışık günler
                currentStreak += 1
                maxStreak = max(maxStreak, currentStreak)
                currentSilence = 0
            } else if daysBetween > 1 {
                // Sessizlik dönemi
                currentSilence = daysBetween - 1
                maxSilence = max(maxSilence, currentSilence)
                currentStreak = 0
            }
        }
        
        return (maxStreak, maxSilence)
    }
    
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
}
