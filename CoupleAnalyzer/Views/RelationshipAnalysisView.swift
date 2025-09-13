import SwiftUI
import Charts

struct RelationshipAnalysisView: View {
    let analysisResult: ChatAnalysisResult
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Relationship overview
                RelationshipOverviewCard(dynamics: analysisResult.relationshipDynamics)
                
                // First messages and milestones
                MilestonesCard(dynamics: analysisResult.relationshipDynamics)
                
                // Conversation patterns
                ConversationPatternsCard(dynamics: analysisResult.relationshipDynamics)
                
                // Response time analysis
                ResponseTimeCard(dynamics: analysisResult.relationshipDynamics)
                
                // Message balance
                MessageBalanceCard(dynamics: analysisResult.relationshipDynamics)
                
                // Good morning/night analysis
                GreetingAnalysisCard(dynamics: analysisResult.relationshipDynamics)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

struct RelationshipOverviewCard: View {
    let dynamics: RelationshipDynamics
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("İlişki Genel Bakış")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            HStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text(dynamics.firstMessageSender)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.pink)
                    
                    Text("İlk Mesajı Atan")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 8) {
                    Text(String(format: "%.0f%%", dynamics.messageBalance * 100))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text("Mesaj Dengesi")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 8) {
                    Text("\(dynamics.totalGoodNights + dynamics.totalGoodMornings)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("Selamlaşma")
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

struct MilestonesCard: View {
    let dynamics: RelationshipDynamics
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("İlişki Kilometre Taşları")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                MilestoneRow(
                    title: "İlk Mesaj",
                    date: dynamics.firstMessageDate,
                    icon: "message.fill",
                    color: .blue
                )
                
                if let firstEmojiDate = dynamics.firstEmojiDate {
                    MilestoneRow(
                        title: "İlk Emoji",
                        date: firstEmojiDate,
                        icon: "face.smiling",
                        color: .orange
                    )
                }
                
                if let firstLoveEmojiDate = dynamics.firstLoveEmojiDate {
                    MilestoneRow(
                        title: "İlk ❤️",
                        date: firstLoveEmojiDate,
                        icon: "heart.fill",
                        color: .pink
                    )
                }
                
                if let firstGoodNightDate = dynamics.firstGoodNightDate {
                    MilestoneRow(
                        title: "İlk İyi Geceler",
                        date: firstGoodNightDate,
                        icon: "moon.fill",
                        color: .purple
                    )
                }
                
                if let firstGoodMorningDate = dynamics.firstGoodMorningDate {
                    MilestoneRow(
                        title: "İlk Günaydın",
                        date: firstGoodMorningDate,
                        icon: "sun.max.fill",
                        color: .yellow
                    )
                }
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct MilestoneRow: View {
    let title: String
    let date: Date
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(date, style: .date)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
        }
    }
}

struct ConversationPatternsCard: View {
    let dynamics: RelationshipDynamics
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sohbet Kalıpları")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            VStack(spacing: 16) {
                // Conversation starters
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sohbeti Başlatma")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    ForEach(Array(dynamics.conversationStarters.keys), id: \.self) { sender in
                        if let count = dynamics.conversationStarters[sender] {
                            HStack {
                                Text(sender)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text("\(count) kez")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
                
                Divider()
                
                // Conversation enders
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sohbeti Bitirme")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    ForEach(Array(dynamics.conversationEnders.keys), id: \.self) { sender in
                        if let count = dynamics.conversationEnders[sender] {
                            HStack {
                                Text(sender)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text("\(count) kez")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                            }
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

struct ResponseTimeCard: View {
    let dynamics: RelationshipDynamics
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Cevap Süreleri")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                ForEach(Array(dynamics.averageResponseTime.keys), id: \.self) { sender in
                    if let responseTime = dynamics.averageResponseTime[sender] {
                        HStack {
                            Text(sender)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Text(formatResponseTime(responseTime))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            // Time of day analysis
            if !dynamics.responseTimeByTimeOfDay.isEmpty {
                Divider()
                
                Text("Günün Saatine Göre Cevap Süreleri")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                VStack(spacing: 8) {
                    ForEach(Array(dynamics.responseTimeByTimeOfDay.keys), id: \.self) { sender in
                        if let timeData = dynamics.responseTimeByTimeOfDay[sender] {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(sender)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                HStack(spacing: 16) {
                                    ForEach(TimeOfDay.allCases, id: \.self) { timeOfDay in
                                        if let responseTime = timeData[timeOfDay] {
                                            VStack(spacing: 2) {
                                                Text(timeOfDay.emoji)
                                                    .font(.caption)
                                                Text(formatResponseTime(responseTime))
                                                    .font(.caption2)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                    }
                                }
                            }
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
    
    private func formatResponseTime(_ timeInterval: TimeInterval) -> String {
        if timeInterval < 60 {
            return String(format: "%.0f saniye", timeInterval)
        } else if timeInterval < 3600 {
            return String(format: "%.1f dakika", timeInterval / 60)
        } else {
            return String(format: "%.1f saat", timeInterval / 3600)
        }
    }
}

struct MessageBalanceCard: View {
    let dynamics: RelationshipDynamics
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mesaj Dengesi")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                HStack {
                    Text("Mesaj Dağılımı")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(String(format: "%.0f%% / %.0f%%", 
                               dynamics.messageBalance * 100, 
                               (1 - dynamics.messageBalance) * 100))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                
                ProgressView(value: dynamics.messageBalance, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.pink))
                
                // Interpretation
                Text(interpretMessageBalance(dynamics.messageBalance))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    private func interpretMessageBalance(_ balance: Double) -> String {
        if balance > 0.7 {
            return "Bir kişi daha çok mesaj atıyor. Bu normal olabilir, ancak dengeli bir iletişim önemlidir."
        } else if balance > 0.6 {
            return "Mesaj dağılımı biraz dengesiz. Her iki tarafın da aktif olması sağlıklıdır."
        } else if balance > 0.4 {
            return "Dengeli bir mesaj dağılımı! Her iki taraf da eşit şekilde katkıda bulunuyor."
        } else {
            return "Mesaj dağılımı dengeli. İletişimde her iki taraf da aktif."
        }
    }
}

struct GreetingAnalysisCard: View {
    let dynamics: RelationshipDynamics
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Selamlaşma Analizi")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            HStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("\(dynamics.totalGoodMornings)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                    
                    Text("Günaydın")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 8) {
                    Text("\(dynamics.totalGoodNights)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                    
                    Text("İyi Geceler")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 8) {
                    Text("\(dynamics.totalGoodMornings + dynamics.totalGoodNights)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("Toplam")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            
            // Interpretation
            VStack(alignment: .leading, spacing: 8) {
                Text("Yorum")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(interpretGreetings(dynamics.totalGoodMornings, dynamics.totalGoodNights))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            .padding(.top, 8)
        }
        .padding(20)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    private func interpretGreetings(_ goodMornings: Int, _ goodNights: Int) -> String {
        let total = goodMornings + goodNights
        
        if total > 200 {
            return "Çok düzenli selamlaşma alışkanlığınız var! Bu, güçlü bir bağın göstergesi."
        } else if total > 100 {
            return "İyi bir selamlaşma alışkanlığınız var. Bu, ilişkinizde düzenli iletişim olduğunu gösteriyor."
        } else if total > 50 {
            return "Orta düzeyde selamlaşma alışkanlığınız var. Daha sık selamlaşmak ilişkinizi güçlendirebilir."
        } else {
            return "Selamlaşma alışkanlığınız az. Düzenli selamlaşma ilişkinizi güçlendirebilir."
        }
    }
}

#Preview {
    let mockDynamics = RelationshipDynamics(
        conversationStarters: [
            "Ayşe": 45,
            "Mehmet": 35
        ],
        conversationEnders: [
            "Ayşe": 40,
            "Mehmet": 40
        ],
        averageResponseTime: [
            "Ayşe": 300, // 5 dakika
            "Mehmet": 450 // 7.5 dakika
        ],
        responseTimeByTimeOfDay: [
            "Ayşe": [
                .morning: 200,
                .afternoon: 300,
                .evening: 400,
                .night: 600
            ],
            "Mehmet": [
                .morning: 300,
                .afternoon: 400,
                .evening: 500,
                .night: 800
            ]
        ],
        messageBalance: 0.55,
        firstMessageSender: "Ayşe",
        firstMessageDate: Date().addingTimeInterval(-90 * 24 * 60 * 60), // 90 gün önce
        firstEmojiDate: Date().addingTimeInterval(-85 * 24 * 60 * 60),
        firstLoveEmojiDate: Date().addingTimeInterval(-80 * 24 * 60 * 60),
        firstGoodNightDate: Date().addingTimeInterval(-75 * 24 * 60 * 60),
        firstGoodMorningDate: Date().addingTimeInterval(-70 * 24 * 60 * 60),
        totalGoodNights: 120,
        totalGoodMornings: 100
    )
    
    RelationshipAnalysisView(analysisResult: ChatAnalysisResult(
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
        emojiAnalysis: EmojiAnalysis(
            totalEmojis: 0,
            mostUsedEmoji: "",
            mostUsedEmojiCount: 0,
            categoryDistribution: [:],
            senderEmojiUsage: [:],
            emojiTrendOverTime: [:],
            loveEmojiCount: 0,
            laughterEmojiCount: 0,
            romanticDay: nil,
            laughterRatio: 0
        ),
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
        relationshipDynamics: mockDynamics,
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
