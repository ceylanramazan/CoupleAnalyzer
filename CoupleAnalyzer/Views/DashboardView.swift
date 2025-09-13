import SwiftUI
import Charts

struct DashboardView: View {
    let analysisResult: ChatAnalysisResult
    let viewModel: ChatAnalyzerViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.pink.opacity(0.05),
                        Color.purple.opacity(0.05),
                        Color.blue.opacity(0.05)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with summary
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Analiz Tamamlandı!")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                
                                Text("\(analysisResult.messages.count) mesaj analiz edildi")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.dismissResults()
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        // Quick stats
                        HStack(spacing: 16) {
                            QuickStatCard(
                                title: "En Aktif",
                                value: viewModel.mostActiveSender,
                                icon: "person.fill",
                                color: Color.blue
                            )
                            
                            QuickStatCard(
                                title: "En Çok Emoji",
                                value: analysisResult.emojiAnalysis.mostUsedEmoji,
                                icon: "face.smiling",
                                color: Color.orange
                            )
                            
                            QuickStatCard(
                                title: "Duygu",
                                value: analysisResult.sentimentAnalysis.overallSentiment.emoji,
                                icon: "heart.fill",
                                color: Color.pink
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Tab selector
                    Picker("Analiz Türü", selection: $selectedTab) {
                        Text("Genel").tag(0)
                        Text("Emoji").tag(1)
                        Text("Kelime").tag(2)
                        Text("İlişki").tag(3)
                        Text("Eğlence").tag(4)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    // Content
                    TabView(selection: $selectedTab) {
                        GeneralAnalysisView(analysisResult: analysisResult)
                            .tag(0)
                        
                        EmojiAnalysisView(analysisResult: analysisResult)
                            .tag(1)
                        
                        WordAnalysisView(analysisResult: analysisResult)
                            .tag(2)
                        
                        RelationshipAnalysisView(analysisResult: analysisResult)
                            .tag(3)
                        
                        FunAnalysisView(analysisResult: analysisResult)
                            .tag(4)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.8))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - General Analysis View
struct GeneralAnalysisView: View {
    let analysisResult: ChatAnalysisResult
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Message statistics
                MessageStatsCard(stats: analysisResult.messageStats)
                
                // Sender comparison
                SenderComparisonCard(comparison: analysisResult.senderComparison)
                
                // Time analysis
                TimeAnalysisCard(messages: analysisResult.messages)
                
                // Sentiment overview
                SentimentOverviewCard(sentiment: analysisResult.sentimentAnalysis)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

struct MessageStatsCard: View {
    let stats: MessageStats
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mesaj İstatistikleri")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                StatRow(
                    title: "Toplam Mesaj",
                    value: "\(stats.totalMessages)",
                    icon: "message.fill",
                    color: Color.blue
                )
                
                StatRow(
                    title: "Ortalama Uzunluk",
                    value: String(format: "%.1f karakter", stats.averageMessageLength),
                    icon: "text.alignleft",
                    color: Color.green
                )
                
                StatRow(
                    title: "En Aktif Saat",
                    value: "\(stats.mostActiveHour):00",
                    icon: "clock.fill",
                    color: Color.orange
                )
                
                StatRow(
                    title: "En Aktif Gün",
                    value: stats.mostActiveDay,
                    icon: "calendar",
                    color: Color.purple
                )
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct StatRow: View {
    let title: String
    let value: String
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
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
        }
    }
}

struct SenderComparisonCard: View {
    let comparison: SenderComparison
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Gönderici Karşılaştırması")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            VStack(spacing: 16) {
                // Message count comparison
                VStack(spacing: 8) {
                    HStack {
                        Text(comparison.sender1)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Spacer()
                        Text("\(comparison.sender1MessageCount) mesaj")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    ProgressView(value: Double(comparison.sender1MessageCount), total: Double(comparison.sender1MessageCount + comparison.sender2MessageCount))
                        .progressViewStyle(LinearProgressViewStyle(tint: Color.pink))
                    
                    HStack {
                        Text(comparison.sender2)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Spacer()
                        Text("\(comparison.sender2MessageCount) mesaj")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Divider()
                
                // Response time comparison
                VStack(spacing: 8) {
                    HStack {
                        Text("Ortalama Cevap Süresi")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Spacer()
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(comparison.sender1)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(formatResponseTime(comparison.sender1ResponseTime))
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text(comparison.sender2)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(formatResponseTime(comparison.sender2ResponseTime))
                                .font(.subheadline)
                                .fontWeight(.semibold)
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

struct TimeAnalysisCard: View {
    let messages: [ChatMessage]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Zaman Analizi")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            // Hourly distribution chart
            if #available(iOS 16.0, *) {
                let hourlyData = createHourlyData()
                Chart(hourlyData, id: \.hour) { data in
                    BarMark(
                        x: .value("Saat", data.hour),
                        y: .value("Mesaj Sayısı", data.count)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.pink, Color.purple]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(values: .stride(by: 2)) { _ in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel()
                    }
                }
            } else {
                // Fallback for older iOS versions
                Text("Zaman analizi grafiği iOS 16+ gerektirir")
                    .foregroundColor(.secondary)
                    .frame(height: 200)
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    private func createHourlyData() -> [HourlyData] {
        let hourlyCounts = Dictionary(grouping: messages) { 
            Calendar.current.component(.hour, from: $0.timestamp) 
        }.mapValues { $0.count }
        
        return (0...23).map { hour in
            HourlyData(hour: hour, count: hourlyCounts[hour] ?? 0)
        }
    }
}

struct HourlyData {
    let hour: Int
    let count: Int
}

struct SentimentOverviewCard: View {
    let sentiment: SentimentAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Duygu Analizi")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            HStack(spacing: 20) {
                SentimentItem(
                    sentiment: .positive,
                    count: sentiment.positiveCount,
                    emoji: "😊"
                )
                
                SentimentItem(
                    sentiment: .neutral,
                    count: sentiment.neutralCount,
                    emoji: "😐"
                )
                
                SentimentItem(
                    sentiment: .negative,
                    count: sentiment.negativeCount,
                    emoji: "😔"
                )
            }
            
            // Overall sentiment
            HStack {
                Text("Genel Duygu:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                HStack(spacing: 8) {
                    Text(sentiment.overallSentiment.emoji)
                        .font(.title2)
                    Text(sentiment.overallSentiment.displayName)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct SentimentItem: View {
    let sentiment: Sentiment
    let count: Int
    let emoji: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(emoji)
                .font(.title)
            
            Text("\(count)")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text(sentiment.displayName)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.5))
        .cornerRadius(12)
    }
}

#Preview {
    let mockResult = ChatAnalysisResult(
        messages: [],
        messageStats: MessageStats(
            totalMessages: 1500,
            averageMessageLength: 25.5,
            longestMessage: "En uzun mesaj burada",
            shortestMessage: "k",
            mostActiveHour: 20,
            mostActiveDay: "Pazartesi",
            longestConversation: 3600,
            longestSilence: 86400
        ),
        senderComparison: SenderComparison(
            sender1: "Ayşe",
            sender2: "Mehmet",
            sender1MessageCount: 800,
            sender2MessageCount: 700,
            sender1AverageLength: 30.0,
            sender2AverageLength: 20.0,
            sender1ResponseTime: 300,
            sender2ResponseTime: 450,
            conversationStarterRatio: 0.6,
            conversationEnderRatio: 0.4
        ),
        emojiAnalysis: EmojiAnalysis(
            totalEmojis: 500,
            mostUsedEmoji: "❤️",
            mostUsedEmojiCount: 100,
            categoryDistribution: [:],
            senderEmojiUsage: [:],
            emojiTrendOverTime: [:],
            loveEmojiCount: 200,
            laughterEmojiCount: 150,
            romanticDay: Date(),
            laughterRatio: 0.1
        ),
        wordAnalysis: WordAnalysis(
            totalWords: 10000,
            mostUsedWords: [],
            loveWordsCount: 200,
            negativeWordsCount: 50,
            positiveNegativeRatio: 4.0,
            averageWordsPerMessage: 6.7,
            senderWordUsage: [:],
            mostRepeatedPhrase: "napıyorsun",
            mostRepeatedPhraseCount: 50,
            wordCloud: [:]
        ),
        sentimentAnalysis: SentimentAnalysis(
            positiveCount: 800,
            negativeCount: 100,
            neutralCount: 600,
            overallSentiment: .positive,
            sentimentScore: 0.4,
            dailySentimentTrend: [:]
        ),
        relationshipDynamics: RelationshipDynamics(
            conversationStarters: [:],
            conversationEnders: [:],
            averageResponseTime: [:],
            responseTimeByTimeOfDay: [:],
            messageBalance: 0.6,
            firstMessageSender: "Ayşe",
            firstMessageDate: Date(),
            firstEmojiDate: Date(),
            firstLoveEmojiDate: Date(),
            firstGoodNightDate: Date(),
            firstGoodMorningDate: Date(),
            totalGoodNights: 100,
            totalGoodMornings: 80
        ),
        funStatistics: FunStatistics(
            recordDay: Date(),
            recordDayMessageCount: 200,
            longestMessage: "En uzun mesaj",
            shortestMessage: "k",
            mostRepeatedSentence: "napıyorsun",
            mostRepeatedSentenceCount: 50,
            funScore: 75.0,
            romanticScore: 85.0,
            laughterRatio: 0.1,
            totalConversationDays: 90,
            averageMessagesPerDay: 16.7,
            longestStreak: 15,
            longestSilence: 3
        ),
        analysisDate: Date(),
        totalAnalysisTime: 2.5
    )
    
    return DashboardView(
        analysisResult: mockResult,
        viewModel: ChatAnalyzerViewModel()
    )
}
