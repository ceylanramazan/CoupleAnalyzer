import Foundation

// MARK: - Word Analyzer Service
class WordAnalyzer {
    
    // MARK: - Main Word Analysis
    static func analyzeWords(_ messages: [ChatMessage]) -> WordAnalysis {
        let allWords = extractWords(from: messages)
        let totalWords = allWords.count
        
        // En çok kullanılan kelimeler (fuzzy matching ile)
        let normalizedWords = allWords.map { wordUsage in
            WordUsage(
                word: normalizeWord(wordUsage.word),
                count: wordUsage.count,
                sender: wordUsage.sender
            )
        }
        
        let wordCounts = Dictionary(grouping: normalizedWords) { $0.word.lowercased() }
            .mapValues { $0.count }
            .sorted { $0.value > $1.value }
        
        let mostUsedWords = wordCounts.prefix(20).map { wordCount in
            WordUsage(
                word: wordCount.key,
                count: wordCount.value,
                sender: "combined" // Burada gönderici bilgisi kayboluyor, gerekirse ayrı hesaplanabilir
            )
        }
        
        // Sevgi kelimeleri analizi
        let loveWordsCount = countLoveWords(messages)
        
        // Negatif kelimeler analizi
        let negativeWordsCount = countNegativeWords(messages)
        
        // Pozitif/negatif oranı
        let positiveNegativeRatio = negativeWordsCount > 0 ? Double(loveWordsCount) / Double(negativeWordsCount) : Double(loveWordsCount)
        
        // Ortalama kelime sayısı
        let averageWordsPerMessage = messages.isEmpty ? 0 : Double(totalWords) / Double(messages.count)
        
        // Gönderici bazında kelime kullanımı
        let senderWordUsage = calculateSenderWordUsage(messages)
        
        // En çok tekrar eden cümle
        let (mostRepeatedPhrase, mostRepeatedPhraseCount) = findMostRepeatedPhrase(messages)
        
        // Kelime bulutu için
        let wordCloud = Dictionary(uniqueKeysWithValues: wordCounts.prefix(50).map { ($0.key, $0.value) })
        
        return WordAnalysis(
            totalWords: totalWords,
            mostUsedWords: mostUsedWords,
            loveWordsCount: loveWordsCount,
            negativeWordsCount: negativeWordsCount,
            positiveNegativeRatio: positiveNegativeRatio,
            averageWordsPerMessage: averageWordsPerMessage,
            senderWordUsage: senderWordUsage,
            mostRepeatedPhrase: mostRepeatedPhrase,
            mostRepeatedPhraseCount: mostRepeatedPhraseCount,
            wordCloud: wordCloud
        )
    }
    
    // MARK: - Sentiment Analysis
    static func analyzeSentiment(_ messages: [ChatMessage]) -> SentimentAnalysis {
        var positiveCount = 0
        var negativeCount = 0
        var neutralCount = 0
        var dailySentiment: [Date: Sentiment] = [:]
        
        for message in messages {
            let sentiment = analyzeMessageSentiment(message.content)
            
            switch sentiment {
            case .positive:
                positiveCount += 1
            case .negative:
                negativeCount += 1
            case .neutral:
                neutralCount += 1
            }
            
            let day = Calendar.current.startOfDay(for: message.timestamp)
            dailySentiment[day] = sentiment
        }
        
        let totalMessages = messages.count
        let sentimentScore = totalMessages > 0 ? 
            (Double(positiveCount - negativeCount) / Double(totalMessages)) : 0.0
        
        let overallSentiment: Sentiment = {
            if sentimentScore > 0.1 { return .positive }
            else if sentimentScore < -0.1 { return .negative }
            else { return .neutral }
        }()
        
        return SentimentAnalysis(
            positiveCount: positiveCount,
            negativeCount: negativeCount,
            neutralCount: neutralCount,
            overallSentiment: overallSentiment,
            sentimentScore: sentimentScore,
            dailySentimentTrend: dailySentiment
        )
    }
    
    // MARK: - Private Helper Methods
    
    /// Yazım hatalarını düzeltmek için kelime normalizasyonu
    private static func normalizeWord(_ word: String) -> String {
        let cleanWord = word.lowercased()
            .replacingOccurrences(of: "ğ", with: "g")
            .replacingOccurrences(of: "ü", with: "u")
            .replacingOccurrences(of: "ş", with: "s")
            .replacingOccurrences(of: "ı", with: "i")
            .replacingOccurrences(of: "ö", with: "o")
            .replacingOccurrences(of: "ç", with: "c")
        
        // Yaygın yazım hatalarını düzelt
        let commonMistakes: [String: String] = [
            "napıyorsun": "ne yapıyorsun",
            "napıyon": "ne yapıyorsun",
            "napıyosun": "ne yapıyorsun"
        ]
        
        // Eğer kelime yaygın hatalar listesinde varsa düzelt
        if let corrected = commonMistakes[cleanWord] {
            return corrected
        }
        
        // Levenshtein distance ile benzer kelimeleri bul
        return findSimilarWord(cleanWord) ?? cleanWord
    }
    
    /// Levenshtein distance ile benzer kelime bulma
    private static func findSimilarWord(_ word: String) -> String? {
        let commonWords = [
            "merhaba", "selam", "nasılsın", "iyi", "güzel", "harika", "mükemmel",
            "aşkım", "canım", "bebeğim", "sevgilim", "tatlım", "hayatım",
            "ne", "yapıyorsun", "napıyorsun", "napıyon", "napıyosun",
            "evet", "hayır", "tamam", "olur", "olur", "olur",
            "teşekkür", "sağol", "sağol", "sağol", "rica", "ederim",
            "görüşürüz", "görüşürüz", "görüşürüz", "bay", "bay"
        ]
        
        var bestMatch: String?
        var minDistance = Int.max
        
        for commonWord in commonWords {
            let distance = levenshteinDistance(word, commonWord)
            if distance <= 2 && distance < minDistance { // 2 karakter farkına kadar kabul et
                minDistance = distance
                bestMatch = commonWord
            }
        }
        
        return bestMatch
    }
    
    /// Levenshtein distance hesaplama
    private static func levenshteinDistance(_ s1: String, _ s2: String) -> Int {
        let a = Array(s1)
        let b = Array(s2)
        let m = a.count
        let n = b.count
        
        var matrix = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)
        
        for i in 0...m {
            matrix[i][0] = i
        }
        
        for j in 0...n {
            matrix[0][j] = j
        }
        
        for i in 1...m {
            for j in 1...n {
                let cost = a[i-1] == b[j-1] ? 0 : 1
                matrix[i][j] = min(
                    matrix[i-1][j] + 1,      // deletion
                    matrix[i][j-1] + 1,      // insertion
                    matrix[i-1][j-1] + cost  // substitution
                )
            }
        }
        
        return matrix[m][n]
    }
    
    private static func extractWords(from messages: [ChatMessage]) -> [WordUsage] {
        var words: [WordUsage] = []
        
        for message in messages {
            let messageWords = message.content
                .components(separatedBy: .whitespacesAndNewlines)
                .filter { !$0.isEmpty && $0.count > 2 } // 2 karakterden uzun kelimeler
            
            for word in messageWords {
                let cleanWord = word.lowercased()
                    .trimmingCharacters(in: .punctuationCharacters)
                
                if !cleanWord.isEmpty {
                    words.append(WordUsage(
                        word: cleanWord,
                        count: 1,
                        sender: message.sender
                    ))
                }
            }
        }
        
        return words
    }
    
    private static func countLoveWords(_ messages: [ChatMessage]) -> Int {
        let allLoveWords = LoveWords.turkishLoveWords + LoveWords.englishLoveWords
        var count = 0
        
        for message in messages {
            let words = message.content.lowercased()
            for loveWord in allLoveWords {
                count += words.components(separatedBy: .whitespacesAndNewlines)
                    .filter { $0.contains(loveWord.lowercased()) }.count
            }
        }
        
        return count
    }
    
    private static func countNegativeWords(_ messages: [ChatMessage]) -> Int {
        let allNegativeWords = NegativeWords.turkishNegativeWords + NegativeWords.englishNegativeWords
        var count = 0
        
        for message in messages {
            let words = message.content.lowercased()
            for negativeWord in allNegativeWords {
                count += words.components(separatedBy: .whitespacesAndNewlines)
                    .filter { $0.contains(negativeWord.lowercased()) }.count
            }
        }
        
        return count
    }
    
    private static func calculateSenderWordUsage(_ messages: [ChatMessage]) -> [String: [WordUsage]] {
        var senderWords: [String: [WordUsage]] = [:]
        
        for message in messages {
            let words = extractWords(from: [message])
            if senderWords[message.sender] == nil {
                senderWords[message.sender] = []
            }
            senderWords[message.sender]?.append(contentsOf: words)
        }
        
        // Kelime sayılarını birleştir
        for sender in senderWords.keys {
            let wordCounts = Dictionary(grouping: senderWords[sender] ?? []) { $0.word }
                .mapValues { $0.count }
            
            senderWords[sender] = wordCounts.map { wordCount in
                WordUsage(word: wordCount.key, count: wordCount.value, sender: sender)
            }.sorted { $0.count > $1.count }
        }
        
        return senderWords
    }
    
    private static func findMostRepeatedPhrase(_ messages: [ChatMessage]) -> (String, Int) {
        var phraseCounts: [String: Int] = [:]
        
        for message in messages {
            let content = message.content.lowercased()
            
            // Yaygın cümle kalıplarını ara
            let commonPhrases = [
                "napıyorsun", "ne yapıyorsun", "nasılsın", "iyi misin",
                "günaydın", "iyi geceler", "görüşürüz", "hoşça kal",
                "teşekkürler", "sağol", "tamam", "evet", "hayır"
            ]
            
            for phrase in commonPhrases {
                if content.contains(phrase) {
                    phraseCounts[phrase, default: 0] += 1
                }
            }
        }
        
        let mostRepeated = phraseCounts.max { $0.value < $1.value }
        return (mostRepeated?.key ?? "", mostRepeated?.value ?? 0)
    }
    
    private static func analyzeMessageSentiment(_ text: String) -> Sentiment {
        let lowercasedText = text.lowercased()
        
        let loveWords = LoveWords.turkishLoveWords + LoveWords.englishLoveWords
        let negativeWords = NegativeWords.turkishNegativeWords + NegativeWords.englishNegativeWords
        
        let loveWordCount = loveWords.filter { lowercasedText.contains($0.lowercased()) }.count
        let negativeWordCount = negativeWords.filter { lowercasedText.contains($0.lowercased()) }.count
        
        if loveWordCount > negativeWordCount {
            return .positive
        } else if negativeWordCount > loveWordCount {
            return .negative
        } else {
            return .neutral
        }
    }
}
