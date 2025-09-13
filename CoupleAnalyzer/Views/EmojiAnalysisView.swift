import SwiftUI
import Charts

struct EmojiAnalysisView: View {
    let analysisResult: ChatAnalysisResult
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Emoji overview
                EmojiOverviewCard(emojiAnalysis: analysisResult.emojiAnalysis)
                
                // Most used emojis
                MostUsedEmojisCard(emojiAnalysis: analysisResult.emojiAnalysis)
                
                // Category distribution
                EmojiCategoryCard(emojiAnalysis: analysisResult.emojiAnalysis)
                
                // Sender emoji usage
                SenderEmojiUsageCard(emojiAnalysis: analysisResult.emojiAnalysis)
                
                // Romantic day
                if let romanticDay = analysisResult.emojiAnalysis.romanticDay {
                    RomanticDayCard(romanticDay: romanticDay)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

struct EmojiOverviewCard: View {
    let emojiAnalysis: EmojiAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Emoji Genel Bakış")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            HStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("\(emojiAnalysis.totalEmojis)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.pink)
                    
                    Text("Toplam Emoji")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 8) {
                    Text(emojiAnalysis.mostUsedEmoji)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("En Çok Kullanılan")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 8) {
                    Text("\(emojiAnalysis.loveEmojiCount)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    
                    Text("Sevgi Emojisi")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(20)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct MostUsedEmojisCard: View {
    let emojiAnalysis: EmojiAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("En Çok Kullanılan Emojiler")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            // Show emojis by sender
            VStack(spacing: 16) {
                ForEach(Array(emojiAnalysis.senderEmojiUsage.keys), id: \.self) { sender in
                    if let emojis = emojiAnalysis.senderEmojiUsage[sender] {
                        VStack(alignment: .leading, spacing: 12) {
                            // Sender name
                            Text(sender)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                                .padding(.bottom, 4)
                            
                            // Top emojis for this sender
                            VStack(spacing: 8) {
                                ForEach(emojis.prefix(5), id: \.id) { emojiUsage in
                                    HStack {
                                        Text(emojiUsage.emoji)
                                            .font(.title2)
                                        
                                        Spacer()
                                        
                                        Text("\(emojiUsage.count)")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primary)
                                    }
                                    .padding(.vertical, 2)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                        
                        if sender != Array(emojiAnalysis.senderEmojiUsage.keys).last {
                            Divider()
                                .padding(.vertical, 8)
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    

}

struct EmojiUsageData {
    let emoji: String
    let count: Int
}

struct EmojiCategoryCard: View {
    let emojiAnalysis: EmojiAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Emoji Kategorileri")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            HStack(spacing: 20) {
                // Chart
                if #available(iOS 16.0, *) {
                    let categoryData = createCategoryData()
                    Chart(categoryData, id: \.category) { data in
                        SectorMark(
                            angle: .value("Count", data.count),
                            innerRadius: .ratio(0.5),
                            angularInset: 2
                        )
                        .foregroundStyle(data.color)
                        .opacity(0.8)
                    }
                    .frame(width: 150, height: 150)
                    .chartBackground { chartProxy in
                        VStack {
                            Text("Toplam")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text("\(emojiAnalysis.totalEmojis)")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                    }
                }
                
                // Category list
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(EmojiCategory.allCases, id: \.self) { category in
                        let count = emojiAnalysis.categoryDistribution[category] ?? 0
                        if count > 0 {
                            HStack(spacing: 6) {
                                // Color indicator
                                Circle()
                                    .fill(category.color)
                                    .frame(width: 10, height: 10)
                                
                                Text(category.displayName)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                // Percentage
                                let percentage = Double(count) / Double(emojiAnalysis.totalEmojis) * 100
                                Text("\(Int(percentage))%")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                                
                                Text("(\(count))")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 1)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    @available(iOS 16.0, *)
    private func createCategoryData() -> [CategoryData] {
        return EmojiCategory.allCases.compactMap { category in
            let count = emojiAnalysis.categoryDistribution[category] ?? 0
            guard count > 0 else { return nil }
            
            return CategoryData(
                category: category.displayName,
                count: count,
                color: colorForCategory(category)
            )
        }
    }
    
    private func colorForCategory(_ category: EmojiCategory) -> Color {
        switch category {
        case .love: return .pink
        case .laughter: return .orange
        case .anger: return .red
        case .surprise: return .yellow
        case .sadness: return .blue
        case .neutral: return .gray
        }
    }
}

@available(iOS 16.0, *)
struct CategoryData {
    let category: String
    let count: Int
    let color: Color
}

struct SenderEmojiUsageCard: View {
    let emojiAnalysis: EmojiAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Gönderici Bazında Emoji Kullanımı")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            VStack(spacing: 16) {
                ForEach(Array(emojiAnalysis.senderEmojiUsage.keys), id: \.self) { sender in
                    if let emojis = emojiAnalysis.senderEmojiUsage[sender] {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(sender)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            // Show top 5 emojis for this sender
                            HStack {
                                ForEach(emojis.prefix(5), id: \.id) { emojiUsage in
                                    VStack(spacing: 4) {
                                        Text(emojiUsage.emoji)
                                            .font(.title3)
                                        
                                        Text("\(emojiUsage.count)")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                if emojis.count > 5 {
                                    Text("+\(emojis.count - 5)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                        }
                        .padding(.vertical, 8)
                        
                        if sender != Array(emojiAnalysis.senderEmojiUsage.keys).last {
                            Divider()
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct RomanticDayCard: View {
    let romanticDay: Date
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("En Romantik Gün")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("En çok ❤️ kullanılan gün")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(romanticDay, style: .date)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.pink)
                }
                
                Spacer()
                
                Image(systemName: "heart.fill")
                    .font(.title)
                    .foregroundColor(.pink)
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    let mockEmojiAnalysis = EmojiAnalysis(
        totalEmojis: 500,
        mostUsedEmoji: "❤️",
        mostUsedEmojiCount: 100,
        categoryDistribution: [
            .love: 200,
            .laughter: 150,
            .surprise: 80,
            .neutral: 50,
            .anger: 15,
            .sadness: 5
        ],
        senderEmojiUsage: [
            "Ayşe": [
                EmojiUsage(emoji: "❤️", count: 60, sender: "Ayşe", category: .love),
                EmojiUsage(emoji: "😂", count: 40, sender: "Ayşe", category: .laughter),
                EmojiUsage(emoji: "😊", count: 30, sender: "Ayşe", category: .neutral)
            ],
            "Mehmet": [
                EmojiUsage(emoji: "❤️", count: 40, sender: "Mehmet", category: .love),
                EmojiUsage(emoji: "😂", count: 50, sender: "Mehmet", category: .laughter),
                EmojiUsage(emoji: "😍", count: 25, sender: "Mehmet", category: .love)
            ]
        ],
        emojiTrendOverTime: [:],
        loveEmojiCount: 200,
        laughterEmojiCount: 150,
        romanticDay: Date(),
        laughterRatio: 0.1
    )
    
    EmojiAnalysisView(analysisResult: ChatAnalysisResult(
        messages: [],
        messageStats: MessageStats(
            totalMessages: 0,
            averageMessageLength: 0,
            longestMessage: "",
            shortestMessage: "",
            mostActiveHour: 0,
            mostActiveDay: "",
            longestConversation: 0,
            longestSilence: 0
        ),
        senderComparison: SenderComparison(
            sender1: "Sen",
            sender2: "Partner",
            sender1MessageCount: 1200,
            sender2MessageCount: 800,
            sender1AverageLength: 15.5,
            sender2AverageLength: 12.3,
            sender1ResponseTime: 300.0,
            sender2ResponseTime: 450.0,
            conversationStarterRatio: 0.6,
            conversationEnderRatio: 0.4
        ),
        emojiAnalysis: mockEmojiAnalysis,
        wordAnalysis: WordAnalysis(
            totalWords: 0,
            mostUsedWords: [],
            loveWordsCount: 0,
            negativeWordsCount: 0,
            positiveNegativeRatio: 0,
            averageWordsPerMessage: 0,
            senderWordUsage: [:],
            mostRepeatedPhrase: "",
            mostRepeatedPhraseCount: 0,
            wordCloud: [:]
        ),
        sentimentAnalysis: SentimentAnalysis(
            positiveCount: 0,
            negativeCount: 0,
            neutralCount: 0,
            overallSentiment: .neutral,
            sentimentScore: 0,
            dailySentimentTrend: [:]
        ),
        relationshipDynamics: RelationshipDynamics(
            conversationStarters: [:],
            conversationEnders: [:],
            averageResponseTime: [:],
            responseTimeByTimeOfDay: [:],
            messageBalance: 0,
            firstMessageSender: "",
            firstMessageDate: Date(),
            firstEmojiDate: nil,
            firstLoveEmojiDate: nil,
            firstGoodNightDate: nil,
            firstGoodMorningDate: nil,
            totalGoodNights: 0,
            totalGoodMornings: 0
        ),
        funStatistics: FunStatistics(
            recordDay: Date(),
            recordDayMessageCount: 0,
            longestMessage: "",
            shortestMessage: "",
            mostRepeatedSentence: "",
            mostRepeatedSentenceCount: 0,
            funScore: 0,
            romanticScore: 0,
            laughterRatio: 0,
            totalConversationDays: 0,
            averageMessagesPerDay: 0,
            longestStreak: 0,
            longestSilence: 0
        ),
        analysisDate: Date(),
        totalAnalysisTime: 0
    ))
}
