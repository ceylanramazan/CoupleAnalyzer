import SwiftUI
import Charts

struct WordAnalysisView: View {
    let analysisResult: ChatAnalysisResult
    @State private var animateCards = false
    @State private var selectedWordIndex: Int? = nil
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                // Word overview with enhanced animations
                WordOverviewCard(wordAnalysis: analysisResult.wordAnalysis, delay: 0.1)
                    .scaleEffect(animateCards ? 1.0 : 0.95)
                    .opacity(animateCards ? 1.0 : 0.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateCards)
                
                // Most used words with interactive elements
                MostUsedWordsCard(wordAnalysis: analysisResult.wordAnalysis, selectedIndex: $selectedWordIndex, delay: 0.2)
                    .scaleEffect(animateCards ? 1.0 : 0.95)
                    .opacity(animateCards ? 1.0 : 0.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateCards)
                
                // Love words analysis with romantic animations
                LoveWordsCard(wordAnalysis: analysisResult.wordAnalysis, delay: 0.3)
                    .scaleEffect(animateCards ? 1.0 : 0.95)
                    .opacity(animateCards ? 1.0 : 0.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateCards)
                
                // Sentiment analysis with enhanced visuals
                WordSentimentCard(sentimentAnalysis: analysisResult.sentimentAnalysis, delay: 0.4)
                    .scaleEffect(animateCards ? 1.0 : 0.95)
                    .opacity(animateCards ? 1.0 : 0.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateCards)
                
                // Most repeated phrase with highlight effect
                MostRepeatedPhraseCard(wordAnalysis: analysisResult.wordAnalysis, delay: 0.5)
                    .scaleEffect(animateCards ? 1.0 : 0.95)
                    .opacity(animateCards ? 1.0 : 0.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: animateCards)
                
                // Sender word usage with comparison charts
                SenderWordUsageCard(wordAnalysis: analysisResult.wordAnalysis, delay: 0.6)
                    .scaleEffect(animateCards ? 1.0 : 0.95)
                    .opacity(animateCards ? 1.0 : 0.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateCards)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                animateCards = true
            }
        }
    }
}

struct WordOverviewCard: View {
    let wordAnalysis: WordAnalysis
    let delay: Double
    
    @State private var animateStats = false
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "text.bubble.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                Text("Kelime Genel Bakış")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            HStack(spacing: 20) {
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 60, height: 60)
                            .scaleEffect(animateStats ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(delay), value: animateStats)
                        
                        Text("\(wordAnalysis.totalWords)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .scaleEffect(animateStats ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(delay), value: animateStats)
                    }
                    
                    Text("Toplam Kelime")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.1))
                            .frame(width: 60, height: 60)
                            .scaleEffect(animateStats ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(delay + 0.1), value: animateStats)
                        
                        Text(String(format: "%.1f", wordAnalysis.averageWordsPerMessage))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                            .scaleEffect(animateStats ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(delay + 0.1), value: animateStats)
                    }
                    
                    Text("Ortalama/Mesaj")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color.pink.opacity(0.1))
                            .frame(width: 60, height: 60)
                            .scaleEffect(animateStats ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(delay + 0.2), value: animateStats)
                        
                        Text("\(wordAnalysis.loveWordsCount)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.pink)
                            .scaleEffect(animateStats ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(delay + 0.2), value: animateStats)
                    }
                    
                    Text("Sevgi Kelimesi")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.9))
                .shadow(color: Color.blue.opacity(0.1), radius: 12, x: 0, y: 6)
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
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
                animateStats = true
            }
        }
    }
}

struct MostUsedWordsCard: View {
    let wordAnalysis: WordAnalysis
    @Binding var selectedIndex: Int?
    let delay: Double
    
    @State private var animateWords = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "textformat.abc")
                    .font(.title2)
                    .foregroundColor(.orange)
                
                Text("En Çok Kullanılan Kelimeler")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                ForEach(Array(wordAnalysis.mostUsedWords.prefix(10).enumerated()), id: \.element.id) { index, wordUsage in
                    InteractiveWordRow(
                        wordUsage: wordUsage,
                        index: index,
                        isSelected: selectedIndex == index,
                        delay: delay + Double(index) * 0.05,
                        onTap: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedIndex = selectedIndex == index ? nil : index
                            }
                        }
                    )
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.9))
                .shadow(color: Color.orange.opacity(0.1), radius: 12, x: 0, y: 6)
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                animateWords = true
            }
        }
    }
}

struct InteractiveWordRow: View {
    let wordUsage: WordUsage
    let index: Int
    let isSelected: Bool
    let delay: Double
    let onTap: () -> Void
    
    @State private var animate = false
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Rank indicator
            ZStack {
                Circle()
                    .fill(isSelected ? Color.orange : Color.orange.opacity(0.1))
                    .frame(width: 32, height: 32)
                
                Text("\(index + 1)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(isSelected ? .white : .orange)
            }
            
            // Word
            Text(wordUsage.word.capitalized)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Spacer()
            
            // Count with progress bar
            HStack(spacing: 8) {
                Text("\(wordUsage.count)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.orange.opacity(0.1))
                    )
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color.orange.opacity(0.1) : Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.orange.opacity(0.3) : Color.clear, lineWidth: 1)
                )
        )
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
            onTap()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                animate = true
            }
        }
    }
}

struct LoveWordsCard: View {
    let wordAnalysis: WordAnalysis
    let delay: Double
    
    @State private var animateLove = false
    @State private var heartBeat = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "heart.fill")
                    .font(.title2)
                    .foregroundColor(.pink)
                    .scaleEffect(heartBeat ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true).delay(delay), value: heartBeat)
                
                Text("Sevgi Kelimeleri Analizi")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            HStack(spacing: 20) {
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color.pink.opacity(0.1))
                            .frame(width: 60, height: 60)
                            .scaleEffect(animateLove ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(delay), value: animateLove)
                        
                        Text("\(wordAnalysis.loveWordsCount)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.pink)
                            .scaleEffect(animateLove ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(delay), value: animateLove)
                    }
                    
                    Text("Sevgi Kelimesi")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color.red.opacity(0.1))
                            .frame(width: 60, height: 60)
                            .scaleEffect(animateLove ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(delay + 0.1), value: animateLove)
                        
                        Text("\(wordAnalysis.negativeWordsCount)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .scaleEffect(animateLove ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(delay + 0.1), value: animateLove)
                    }
                    
                    Text("Negatif Kelime")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.1))
                            .frame(width: 60, height: 60)
                            .scaleEffect(animateLove ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(delay + 0.2), value: animateLove)
                        
                        Text(String(format: "%.1f", wordAnalysis.positiveNegativeRatio))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                            .scaleEffect(animateLove ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true).delay(delay + 0.2), value: animateLove)
                    }
                    
                    Text("Pozitif/Negatif")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            
            // Interpretation with enhanced styling
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.yellow)
                    
                    Text("Yorum")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }
                
                Text(interpretLoveWordsRatio(wordAnalysis.positiveNegativeRatio))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.yellow.opacity(0.1))
                    )
            }
            .padding(.top, 8)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.9))
                .shadow(color: Color.pink.opacity(0.1), radius: 12, x: 0, y: 6)
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                animateLove = true
                heartBeat = true
            }
        }
    }
    
    private func interpretLoveWordsRatio(_ ratio: Double) -> String {
        if ratio > 5.0 {
            return "Çok pozitif bir ilişki! Sevgi kelimeleri negatif kelimelerden çok daha fazla kullanılmış."
        } else if ratio > 2.0 {
            return "Pozitif bir ilişki. Sevgi kelimeleri daha çok kullanılmış."
        } else if ratio > 1.0 {
            return "Dengeli bir ilişki. Pozitif ve negatif kelimeler benzer oranda."
        } else {
            return "İlişkide bazı zorluklar olabilir. Negatif kelimeler daha çok kullanılmış."
        }
    }
}

struct WordSentimentCard: View {
    let sentimentAnalysis: SentimentAnalysis
    let delay: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Duygu Analizi")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            if #available(iOS 16.0, *) {
                let sentimentData = createSentimentData()
                Chart(sentimentData, id: \.sentiment) { data in
                    BarMark(
                        x: .value("Sentiment", data.sentiment),
                        y: .value("Count", data.count)
                    )
                    .foregroundStyle(data.color)
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel()
                    }
                }
            } else {
                // Fallback for older iOS versions
                VStack(spacing: 12) {
                    SentimentBar(
                        sentiment: .positive,
                        count: sentimentAnalysis.positiveCount,
                        color: .green
                    )
                    
                    SentimentBar(
                        sentiment: .neutral,
                        count: sentimentAnalysis.neutralCount,
                        color: .gray
                    )
                    
                    SentimentBar(
                        sentiment: .negative,
                        count: sentimentAnalysis.negativeCount,
                        color: .red
                    )
                }
            }
            
            // Overall sentiment
            HStack {
                Text("Genel Duygu:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                HStack(spacing: 8) {
                    Text(sentimentAnalysis.overallSentiment.emoji)
                        .font(.title2)
                    Text(sentimentAnalysis.overallSentiment.displayName)
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
    
    @available(iOS 16.0, *)
    private func createSentimentData() -> [SentimentData] {
        return [
            SentimentData(sentiment: "Pozitif", count: sentimentAnalysis.positiveCount, color: .green),
            SentimentData(sentiment: "Nötr", count: sentimentAnalysis.neutralCount, color: .gray),
            SentimentData(sentiment: "Negatif", count: sentimentAnalysis.negativeCount, color: .red)
        ]
    }
}

@available(iOS 16.0, *)
struct SentimentData {
    let sentiment: String
    let count: Int
    let color: Color
}

struct SentimentBar: View {
    let sentiment: Sentiment
    let count: Int
    let color: Color
    
    var body: some View {
        HStack {
            Text(sentiment.displayName)
                .font(.subheadline)
                .foregroundColor(.primary)
                .frame(width: 60, alignment: .leading)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 20)
                        .cornerRadius(10)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(count) / CGFloat(max(count, 1)), height: 20)
                        .cornerRadius(10)
                }
            }
            .frame(height: 20)
            
            Text("\(count)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .frame(width: 40, alignment: .trailing)
        }
    }
}

struct MostRepeatedPhraseCard: View {
    let wordAnalysis: WordAnalysis
    let delay: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("En Çok Tekrar Edilen Cümle")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            if !wordAnalysis.mostRepeatedPhrase.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("\"\(wordAnalysis.mostRepeatedPhrase)\"")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text("\(wordAnalysis.mostRepeatedPhraseCount) kez tekrar edilmiş")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Image(systemName: "repeat")
                            .font(.title3)
                            .foregroundColor(.orange)
                    }
                }
            } else {
                Text("Tekrar edilen cümle bulunamadı")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct SenderWordUsageCard: View {
    let wordAnalysis: WordAnalysis
    let delay: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Gönderici Bazında Kelime Kullanımı")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            VStack(spacing: 16) {
                ForEach(Array(wordAnalysis.senderWordUsage.keys), id: \.self) { sender in
                    if let words = wordAnalysis.senderWordUsage[sender] {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(sender)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            // Show top 5 words for this sender
                            VStack(spacing: 4) {
                                ForEach(words.prefix(5), id: \.id) { wordUsage in
                                    HStack {
                                        Text(wordUsage.word.capitalized)
                                            .font(.caption)
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        Text("\(wordUsage.count)")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                if words.count > 5 {
                                    Text("+\(words.count - 5) kelime daha...")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                        
                        if sender != Array(wordAnalysis.senderWordUsage.keys).last {
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

#Preview {
    let mockWordAnalysis = WordAnalysis(
        totalWords: 10000,
        mostUsedWords: [
            WordUsage(word: "napıyorsun", count: 150, sender: "combined"),
            WordUsage(word: "nasılsın", count: 120, sender: "combined"),
            WordUsage(word: "aşkım", count: 100, sender: "combined"),
            WordUsage(word: "canım", count: 90, sender: "combined"),
            WordUsage(word: "iyi", count: 80, sender: "combined"),
            WordUsage(word: "günaydın", count: 70, sender: "combined"),
            WordUsage(word: "geceler", count: 65, sender: "combined"),
            WordUsage(word: "sevgilim", count: 60, sender: "combined"),
            WordUsage(word: "bebeğim", count: 55, sender: "combined"),
            WordUsage(word: "tatlım", count: 50, sender: "combined")
        ],
        loveWordsCount: 500,
        negativeWordsCount: 50,
        positiveNegativeRatio: 10.0,
        averageWordsPerMessage: 6.7,
        senderWordUsage: [
            "Ayşe": [
                WordUsage(word: "aşkım", count: 60, sender: "Ayşe"),
                WordUsage(word: "canım", count: 45, sender: "Ayşe"),
                WordUsage(word: "napıyorsun", count: 80, sender: "Ayşe")
            ],
            "Mehmet": [
                WordUsage(word: "sevgilim", count: 40, sender: "Mehmet"),
                WordUsage(word: "bebeğim", count: 35, sender: "Mehmet"),
                WordUsage(word: "nasılsın", count: 70, sender: "Mehmet")
            ]
        ],
        mostRepeatedPhrase: "napıyorsun",
        mostRepeatedPhraseCount: 150,
        wordCloud: [:]
    )
    
    let mockSentimentAnalysis = SentimentAnalysis(
        positiveCount: 800,
        negativeCount: 50,
        neutralCount: 650,
        overallSentiment: .positive,
        sentimentScore: 0.5,
        dailySentimentTrend: [:]
    )
    
    WordAnalysisView(analysisResult: ChatAnalysisResult(
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
        wordAnalysis: mockWordAnalysis,
        sentimentAnalysis: mockSentimentAnalysis,
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
