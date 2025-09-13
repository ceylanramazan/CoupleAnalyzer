import SwiftUI
import Charts

struct DashboardView: View {
    let analysisResult: ChatAnalysisResult
    let viewModel: ChatAnalyzerViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    @State private var animateCards = false
    @State private var showCelebration = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Dynamic Background with Animation
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.pink.opacity(0.1),
                        Color.purple.opacity(0.08),
                        Color.blue.opacity(0.06),
                        Color.cyan.opacity(0.04)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: animateCards)
                
                VStack(spacing: 0) {
                    // Enhanced Header with Celebration
                    VStack(spacing: 20) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 8) {
                                    Text("🎉")
                                        .font(.title)
                                        .scaleEffect(showCelebration ? 1.2 : 1.0)
                                        .animation(.spring(response: 0.6, dampingFraction: 0.6), value: showCelebration)
                                    
                                    Text("Analiz Tamamlandı!")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                }
                                
                                Text("\(analysisResult.messages.count) mesaj analiz edildi")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                // Analysis time
                                HStack(spacing: 4) {
                                    Image(systemName: "clock.fill")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                    Text("Analiz süresi: \(String(format: "%.1f", analysisResult.totalAnalysisTime)) saniye")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation(.spring()) {
                                    viewModel.dismissResults()
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                    .scaleEffect(1.0)
                                    .animation(.spring(response: 0.3), value: showCelebration)
                            }
                        }
                        
                        // Enhanced Quick stats with animations
                        HStack(spacing: 12) {
                            QuickStatCard(
                                title: "En Aktif",
                                value: viewModel.mostActiveSender,
                                icon: "person.fill",
                                color: Color.blue,
                                delay: 0.1
                            )
                            
                            QuickStatCard(
                                title: "En Çok Emoji",
                                value: analysisResult.emojiAnalysis.mostUsedEmoji,
                                icon: "face.smiling",
                                color: Color.orange,
                                delay: 0.2
                            )
                            
                            QuickStatCard(
                                title: "Duygu",
                                value: analysisResult.sentimentAnalysis.overallSentiment.emoji,
                                icon: "heart.fill",
                                color: Color.pink,
                                delay: 0.3
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Modern Tab selector with icons
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(0..<5) { index in
                                TabButton(
                                    title: tabTitles[index],
                                    icon: tabIcons[index],
                                    isSelected: selectedTab == index,
                                    action: {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            selectedTab = index
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
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
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                animateCards = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                    showCelebration = true
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    private var tabTitles: [String] {
        ["Genel", "Emoji", "Kelime", "İlişki", "Eğlence"]
    }
    
    private var tabIcons: [String] {
        ["chart.bar.fill", "face.smiling", "text.bubble.fill", "heart.fill", "gamecontroller.fill"]
    }
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let delay: Double
    
    @State private var animate = false
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 40, height: 40)
                    .scaleEffect(animate ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(delay), value: animate)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .scaleEffect(animate ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(delay), value: animate)
            }
            
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
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.9))
                .shadow(color: color.opacity(0.2), radius: 8, x: 0, y: 4)
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                animate = true
            }
        }
    }
}

// MARK: - Tab Button
struct TabButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        isSelected ? 
                        LinearGradient(
                            gradient: Gradient(colors: [Color.pink, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ) : 
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(
                        color: isSelected ? Color.pink.opacity(0.3) : Color.black.opacity(0.1),
                        radius: isSelected ? 8 : 4,
                        x: 0,
                        y: isSelected ? 4 : 2
                    )
            )
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
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
    
    @State private var animateStats = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                Text("Mesaj İstatistikleri")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            VStack(spacing: 16) {
                StatRow(
                    title: "Toplam Mesaj",
                    value: "\(stats.totalMessages)",
                    icon: "message.fill",
                    color: Color.blue,
                    delay: 0.1
                )
                
                StatRow(
                    title: "Ortalama Uzunluk",
                    value: String(format: "%.1f karakter", stats.averageMessageLength),
                    icon: "text.alignleft",
                    color: Color.green,
                    delay: 0.2
                )
                
                StatRow(
                    title: "En Aktif Saat",
                    value: "\(stats.mostActiveHour):00",
                    icon: "clock.fill",
                    color: Color.orange,
                    delay: 0.3
                )
                
                StatRow(
                    title: "En Aktif Gün",
                    value: stats.mostActiveDay,
                    icon: "calendar",
                    color: Color.purple,
                    delay: 0.4
                )
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.9))
                .shadow(color: Color.blue.opacity(0.1), radius: 12, x: 0, y: 6)
        )
        .scaleEffect(animateStats ? 1.0 : 0.95)
        .opacity(animateStats ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateStats)
        .onAppear {
            animateStats = true
        }
    }
}

struct StatRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let delay: Double
    
    @State private var animate = false
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(color)
            }
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(color)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color.opacity(0.1))
                )
        }
        .padding(.vertical, 8)
        .scaleEffect(animate ? 1.0 : 0.95)
        .opacity(animate ? 1.0 : 0.0)
        .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(delay), value: animate)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
        .onTapGesture {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                animate = true
            }
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
