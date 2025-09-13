import SwiftUI
import Charts

struct FunAnalysisView: View {
    let analysisResult: ChatAnalysisResult
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Fun scores overview
                FunScoresCard(funStats: analysisResult.funStatistics)
                
                // Record day
                RecordDayCard(funStats: analysisResult.funStatistics)
                
                // Message extremes
                MessageExtremesCard(funStats: analysisResult.funStatistics)
                
                // Conversation statistics
                ConversationStatsCard(funStats: analysisResult.funStatistics)
                
                // Most repeated sentence
                MostRepeatedSentenceCard(funStats: analysisResult.funStatistics)
                
                // Laughter analysis
                LaughterAnalysisCard(funStats: analysisResult.funStatistics)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

struct FunScoresCard: View {
    let funStats: FunStatistics
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Eğlence ve Romantik Puanlar")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            HStack(spacing: 20) {
                // Fun Score
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .stroke(Color.orange.opacity(0.2), lineWidth: 8)
                            .frame(width: 80, height: 80)
                        
                        Circle()
                            .trim(from: 0, to: funStats.funScore / 100)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.orange, Color.yellow]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .frame(width: 80, height: 80)
                            .rotationEffect(.degrees(-90))
                        
                        Text(String(format: "%.0f", funStats.funScore))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }
                    
                    Text("Eğlence Puanı")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Romantic Score
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .stroke(Color.pink.opacity(0.2), lineWidth: 8)
                            .frame(width: 80, height: 80)
                        
                        Circle()
                            .trim(from: 0, to: funStats.romanticScore / 100)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.pink, Color.red]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .frame(width: 80, height: 80)
                            .rotationEffect(.degrees(-90))
                        
                        Text(String(format: "%.0f", funStats.romanticScore))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.pink)
                    }
                    
                    Text("Romantik Puanı")
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
                
                Text(interpretFunScores(funStats.funScore, funStats.romanticScore))
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
    
    private func interpretFunScores(_ funScore: Double, _ romanticScore: Double) -> String {
        if funScore > 80 && romanticScore > 80 {
            return "Mükemmel bir denge! Hem eğlenceli hem de romantik bir ilişkiniz var."
        } else if funScore > 70 && romanticScore > 70 {
            return "Çok güzel bir ilişki! Hem eğlence hem de romantizm açısından yüksek puanlar."
        } else if funScore > romanticScore {
            return "Eğlenceli bir ilişkiniz var! Romantik anları da artırabilirsiniz."
        } else if romanticScore > funScore {
            return "Romantik bir ilişkiniz var! Biraz daha eğlence ekleyebilirsiniz."
        } else {
            return "Dengeli bir ilişkiniz var. Her iki alanda da gelişim fırsatları var."
        }
    }
}

struct RecordDayCard: View {
    let funStats: FunStatistics
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Rekor Gün")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("En çok mesaj atılan gün")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(funStats.recordDay, style: .date)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Text("\(funStats.recordDayMessageCount)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    
                    Text("mesaj")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct MessageExtremesCard: View {
    let funStats: FunStatistics
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mesaj Uçları")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            VStack(spacing: 16) {
                // Longest message
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "text.alignleft")
                            .font(.title3)
                            .foregroundColor(.green)
                        
                        Text("En Uzun Mesaj")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                    
                    Text(funStats.longestMessage)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                }
                
                Divider()
                
                // Shortest message
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "text.alignleft")
                            .font(.title3)
                            .foregroundColor(.blue)
                        
                        Text("En Kısa Mesaj")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                    
                    Text(funStats.shortestMessage)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct ConversationStatsCard: View {
    let funStats: FunStatistics
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Konuşma İstatistikleri")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                StatRow(
                    title: "Toplam Konuşma Günü",
                    value: "\(funStats.totalConversationDays) gün",
                    icon: "calendar",
                    color: Color.blue
                )
                
                StatRow(
                    title: "Ortalama Mesaj/Gün",
                    value: String(format: "%.1f", funStats.averageMessagesPerDay),
                    icon: "message.fill",
                    color: Color.green
                )
                
                StatRow(
                    title: "En Uzun Seri",
                    value: "\(funStats.longestStreak) gün",
                    icon: "flame.fill",
                    color: Color.orange
                )
                
                StatRow(
                    title: "En Uzun Sessizlik",
                    value: "\(funStats.longestSilence) gün",
                    icon: "moon.fill",
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

struct MostRepeatedSentenceCard: View {
    let funStats: FunStatistics
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("En Çok Tekrar Edilen Cümle")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            if !funStats.mostRepeatedSentence.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("\"\(funStats.mostRepeatedSentence)\"")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text("\(funStats.mostRepeatedSentenceCount) kez tekrar edilmiş")
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

struct LaughterAnalysisCard: View {
    let funStats: FunStatistics
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Gülme Analizi")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            HStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text(String(format: "%.1f%%", funStats.laughterRatio * 100))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    
                    Text("Gülme Oranı")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 8) {
                    Text("😂")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("En Çok Kullanılan")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 8) {
                    Text(interpretLaughterRatio(funStats.laughterRatio))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("Seviye")
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
                
                Text(getLaughterInterpretation(funStats.laughterRatio))
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
    
    private func interpretLaughterRatio(_ ratio: Double) -> String {
        if ratio > 0.15 {
            return "Çok Yüksek"
        } else if ratio > 0.10 {
            return "Yüksek"
        } else if ratio > 0.05 {
            return "Orta"
        } else {
            return "Düşük"
        }
    }
    
    private func getLaughterInterpretation(_ ratio: Double) -> String {
        if ratio > 0.15 {
            return "Harika! Çok eğlenceli bir ilişkiniz var. Gülmek ilişkinizi güçlendiriyor."
        } else if ratio > 0.10 {
            return "Güzel! İlişkinizde eğlence var. Biraz daha mizah ekleyebilirsiniz."
        } else if ratio > 0.05 {
            return "Orta düzeyde eğlence. Daha fazla gülmek ilişkinizi güçlendirebilir."
        } else {
            return "Eğlence seviyesi düşük. Biraz daha mizah ve eğlence ekleyebilirsiniz."
        }
    }
}

#Preview {
    let mockFunStats = FunStatistics(
        recordDay: Date().addingTimeInterval(-30 * 24 * 60 * 60),
        recordDayMessageCount: 250,
        longestMessage: "Bu gerçekten çok uzun bir mesaj. Belki de en uzun mesajımız bu olabilir. Ne kadar uzun olabileceğini görmek için yazıyorum.",
        shortestMessage: "k",
        mostRepeatedSentence: "napıyorsun",
        mostRepeatedSentenceCount: 150,
        funScore: 75.0,
        romanticScore: 85.0,
        laughterRatio: 0.12,
        totalConversationDays: 90,
        averageMessagesPerDay: 16.7,
        longestStreak: 15,
        longestSilence: 3
    )
    
    FunAnalysisView(analysisResult: ChatAnalysisResult(
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
        funStatistics: mockFunStats,
        analysisDate: Date(),
        totalAnalysisTime: 0
    ))
}
