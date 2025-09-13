import SwiftUI
import Charts

struct WordAnalysisView: View {
    let analysisResult: ChatAnalysisResult
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Word overview
                WordOverviewCard(wordAnalysis: analysisResult.wordAnalysis)
                
                // Most used words
                MostUsedWordsCard(wordAnalysis: analysisResult.wordAnalysis)
                
                // Love words analysis
                LoveWordsCard(wordAnalysis: analysisResult.wordAnalysis)
                
                // Sentiment analysis
                WordSentimentCard(sentimentAnalysis: analysisResult.sentimentAnalysis)
                
                // Most repeated phrase
                MostRepeatedPhraseCard(wordAnalysis: analysisResult.wordAnalysis)
                
                // Sender word usage
                SenderWordUsageCard(wordAnalysis: analysisResult.wordAnalysis)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

struct WordOverviewCard: View {
    let wordAnalysis: WordAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Kelime Genel Bakış")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            HStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("\(wordAnalysis.totalWords)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text("Toplam Kelime")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 8) {
                    Text(String(format: "%.1f", wordAnalysis.averageWordsPerMessage))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("Ortalama/Mesaj")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 8) {
                    Text("\(wordAnalysis.loveWordsCount)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.pink)
                    
                    Text("Sevgi Kelimesi")
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

struct MostUsedWordsCard: View {
    let wordAnalysis: WordAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("En Çok Kullanılan Kelimeler")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                ForEach(wordAnalysis.mostUsedWords.prefix(15), id: \.id) { wordUsage in
                    HStack {
                        Text(wordUsage.word.capitalized)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text("\(wordUsage.count)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct LoveWordsCard: View {
    let wordAnalysis: WordAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sevgi Kelimeleri Analizi")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            HStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("\(wordAnalysis.loveWordsCount)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.pink)
                    
                    Text("Sevgi Kelimesi")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 8) {
                    Text("\(wordAnalysis.negativeWordsCount)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    
                    Text("Negatif Kelime")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 8) {
                    Text(String(format: "%.1f", wordAnalysis.positiveNegativeRatio))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("Pozitif/Negatif")
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
                
                Text(interpretLoveWordsRatio(wordAnalysis.positiveNegativeRatio))
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
