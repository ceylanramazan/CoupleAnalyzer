import Foundation
import Combine
import SwiftUI

// MARK: - Chat Analyzer ViewModel
@MainActor
class ChatAnalyzerViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var messages: [ChatMessage] = []
    @Published var analysisResult: ChatAnalysisResult?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentStep: AnalysisStep = .onboarding
    @Published var showingResults = false
    
    // MARK: - Analysis Steps
    enum AnalysisStep {
        case onboarding
        case fileSelection
        case analyzing
        case results
        case error
    }
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let analysisQueue = DispatchQueue(label: "com.coupleanalyzer.analysis", qos: .userInitiated)
    
    // MARK: - Initialization
    init() {
        setupMockDataForPreview()
    }
    
    // MARK: - Public Methods
    
    /// WhatsApp chat dosyasını yükle ve analiz et
    func loadAndAnalyzeChat(_ content: String) {
        isLoading = true
        errorMessage = nil
        currentStep = .analyzing
        
        analysisQueue.async { [weak self] in
            guard let self = self else { return }
            
            do {
                // WhatsApp formatını parse et
                let parsedMessages = WhatsAppParser.parseWhatsAppExport(content)
                
                // Analiz işlemlerini gerçekleştir
                let analysisResult = self.performAnalysis(messages: parsedMessages)
                
                DispatchQueue.main.async {
                    self.messages = parsedMessages
                    self.analysisResult = analysisResult
                    self.isLoading = false
                    self.currentStep = .results
                    self.showingResults = true
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Analiz sırasında hata oluştu: \(error.localizedDescription)"
                    self.isLoading = false
                    self.currentStep = .error
                }
            }
        }
    }
    
    /// Mock data ile analiz yap (preview için)
    func analyzeWithMockData() {
        isLoading = true
        errorMessage = nil
        currentStep = .analyzing
        
        analysisQueue.async { [weak self] in
            guard let self = self else { return }
            
            let mockMessages = MockDataGenerator.generateMockMessages()
            let analysisResult = self.performAnalysis(messages: mockMessages)
            
            DispatchQueue.main.async {
                self.messages = mockMessages
                self.analysisResult = analysisResult
                self.isLoading = false
                self.currentStep = .results
                self.showingResults = true
            }
        }
    }
    
    /// Analiz sonuçlarını sıfırla
    func resetAnalysis() {
        messages = []
        analysisResult = nil
        errorMessage = nil
        currentStep = .onboarding
    }
    
    /// Hata mesajını temizle
    func clearError() {
        errorMessage = nil
        currentStep = .onboarding
    }
    
    // MARK: - Private Methods
    
    private func performAnalysis(messages: [ChatMessage]) -> ChatAnalysisResult {
        let startTime = Date()
        
        // Tüm analiz işlemlerini paralel olarak gerçekleştir
        let messageStats = MessageAnalyzer.analyzeMessageStats(messages)
        let senderComparison = MessageAnalyzer.analyzeSenderComparison(messages)
        let emojiAnalysis = EmojiAnalyzer.analyzeEmojis(messages)
        let wordAnalysis = WordAnalyzer.analyzeWords(messages)
        let sentimentAnalysis = WordAnalyzer.analyzeSentiment(messages)
        let relationshipDynamics = RelationshipAnalyzer.analyzeRelationshipDynamics(messages)
        let funStatistics = RelationshipAnalyzer.analyzeFunStatistics(messages)
        
        let endTime = Date()
        let analysisTime = endTime.timeIntervalSince(startTime)
        
        return ChatAnalysisResult(
            messages: messages,
            messageStats: messageStats,
            senderComparison: senderComparison ?? SenderComparison(
                sender1: "Bilinmeyen",
                sender2: "Bilinmeyen",
                sender1MessageCount: 0,
                sender2MessageCount: 0,
                sender1AverageLength: 0,
                sender2AverageLength: 0,
                sender1ResponseTime: 0,
                sender2ResponseTime: 0,
                conversationStarterRatio: 0.5,
                conversationEnderRatio: 0.5
            ),
            emojiAnalysis: emojiAnalysis,
            wordAnalysis: wordAnalysis,
            sentimentAnalysis: sentimentAnalysis,
            relationshipDynamics: relationshipDynamics,
            funStatistics: funStatistics,
            analysisDate: Date(),
            totalAnalysisTime: analysisTime
        )
    }
    
    private func setupMockDataForPreview() {
        // Preview için mock data hazırla
        #if DEBUG
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            analyzeWithMockData()
        }
        #endif
    }
}

// MARK: - Computed Properties for UI
extension ChatAnalyzerViewModel {
    
    /// Analiz tamamlandı mı?
    var isAnalysisComplete: Bool {
        analysisResult != nil && !isLoading
    }
    
    /// Gönderici isimleri
    var senderNames: [String] {
        let senders = Set(messages.map { $0.sender }).filter { !$0.isEmpty }
        return Array(senders).sorted()
    }
    
    /// Toplam mesaj sayısı
    var totalMessageCount: Int {
        messages.count
    }
    
    /// Analiz süresi (formatlanmış)
    var formattedAnalysisTime: String {
        guard let result = analysisResult else { return "0.0s" }
        return String(format: "%.1fs", result.totalAnalysisTime)
    }
    
    /// En çok mesaj atan kişi
    var mostActiveSender: String {
        let senderCounts = Dictionary(grouping: messages) { $0.sender }
            .mapValues { $0.count }
        return senderCounts.max { $0.value < $1.value }?.key ?? "Bilinmeyen"
    }
    
    /// En çok kullanılan emoji
    var mostUsedEmoji: String {
        analysisResult?.emojiAnalysis.mostUsedEmoji ?? "😊"
    }
    
    /// Genel duygu durumu
    var overallSentiment: Sentiment {
        analysisResult?.sentimentAnalysis.overallSentiment ?? .neutral
    }
    
    /// Eğlence puanı
    var funScore: Double {
        analysisResult?.funStatistics.funScore ?? 0.0
    }
    
    /// Romantik puanı
    var romanticScore: Double {
        analysisResult?.funStatistics.romanticScore ?? 0.0
    }
}

// MARK: - Analysis Summary
extension ChatAnalyzerViewModel {
    
    /// Analiz özeti
    var analysisSummary: AnalysisSummary {
        guard let result = analysisResult else {
            return AnalysisSummary(
                totalMessages: 0,
                analysisDuration: "0.0s",
                mostActiveSender: "Bilinmeyen",
                mostUsedEmoji: "😊",
                overallSentiment: .neutral,
                funScore: 0.0,
                romanticScore: 0.0
            )
        }
        
        return AnalysisSummary(
            totalMessages: result.messages.count,
            analysisDuration: formattedAnalysisTime,
            mostActiveSender: mostActiveSender,
            mostUsedEmoji: result.emojiAnalysis.mostUsedEmoji,
            overallSentiment: result.sentimentAnalysis.overallSentiment,
            funScore: result.funStatistics.funScore,
            romanticScore: result.funStatistics.romanticScore
        )
    }
}

// MARK: - Analysis Summary Model
struct AnalysisSummary {
    let totalMessages: Int
    let analysisDuration: String
    let mostActiveSender: String
    let mostUsedEmoji: String
    let overallSentiment: Sentiment
    let funScore: Double
    let romanticScore: Double
}

// MARK: - Dismiss Functions
extension ChatAnalyzerViewModel {
    func dismissResults() {
        showingResults = false
        currentStep = .fileSelection
    }
}
