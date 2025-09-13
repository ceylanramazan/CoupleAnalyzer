import Foundation

// MARK: - Premium Feature Types
enum PremiumFeatureType: String, CaseIterable {
    case unlimitedAnalysis = "unlimited_analysis"
    case advancedAnalytics = "advanced_analytics"
    case romanticFeatures = "romantic_features"
    case customThemes = "custom_themes"
    case exportReports = "export_reports"
    case aiInsights = "ai_insights"
    case relationshipPredictions = "relationship_predictions"
    case loveLetterGenerator = "love_letter_generator"
    case giftSuggestions = "gift_suggestions"
    case anniversaryReminders = "anniversary_reminders"
    
    var title: String {
        switch self {
        case .unlimitedAnalysis:
            return "Sınırsız Analiz"
        case .advancedAnalytics:
            return "Gelişmiş Analitikler"
        case .romanticFeatures:
            return "Romantik Özellikler"
        case .customThemes:
            return "Özel Temalar"
        case .exportReports:
            return "Rapor Dışa Aktarma"
        case .aiInsights:
            return "AI Öngörüleri"
        case .relationshipPredictions:
            return "İlişki Öngörüleri"
        case .loveLetterGenerator:
            return "Aşk Mektubu Oluşturucu"
        case .giftSuggestions:
            return "Hediye Önerileri"
        case .anniversaryReminders:
            return "Yıldönümü Hatırlatıcıları"
        }
    }
    
    var description: String {
        switch self {
        case .unlimitedAnalysis:
            return "İstediğiniz kadar sohbet analiz edin"
        case .advancedAnalytics:
            return "Detaylı istatistikler ve grafikler"
        case .romanticFeatures:
            return "Özel romantik analizler ve özellikler"
        case .customThemes:
            return "Kişiselleştirilebilir arayüz temaları"
        case .exportReports:
            return "Analiz raporlarını PDF olarak kaydedin"
        case .aiInsights:
            return "Yapay zeka ile ilişki öngörüleri"
        case .relationshipPredictions:
            return "İlişkinizin geleceği hakkında tahminler"
        case .loveLetterGenerator:
            return "AI ile kişiselleştirilmiş aşk mektupları"
        case .giftSuggestions:
            return "Partneriniz için özel hediye önerileri"
        case .anniversaryReminders:
            return "Özel günleri unutmayın"
        }
    }
    
    var icon: String {
        switch self {
        case .unlimitedAnalysis:
            return "infinity.circle.fill"
        case .advancedAnalytics:
            return "chart.bar.xaxis"
        case .romanticFeatures:
            return "heart.text.square.fill"
        case .customThemes:
            return "paintbrush.fill"
        case .exportReports:
            return "square.and.arrow.up.fill"
        case .aiInsights:
            return "brain.head.profile"
        case .relationshipPredictions:
            return "crystal.ball.fill"
        case .loveLetterGenerator:
            return "envelope.fill"
        case .giftSuggestions:
            return "gift.fill"
        case .anniversaryReminders:
            return "calendar.badge.clock"
        }
    }
    
    var color: String {
        switch self {
        case .unlimitedAnalysis:
            return "blue"
        case .advancedAnalytics:
            return "purple"
        case .romanticFeatures:
            return "pink"
        case .customThemes:
            return "orange"
        case .exportReports:
            return "green"
        case .aiInsights:
            return "indigo"
        case .relationshipPredictions:
            return "cyan"
        case .loveLetterGenerator:
            return "red"
        case .giftSuggestions:
            return "yellow"
        case .anniversaryReminders:
            return "mint"
        }
    }
    
    var category: PremiumCategory {
        switch self {
        case .unlimitedAnalysis, .advancedAnalytics, .exportReports:
            return .analytics
        case .aiInsights, .relationshipPredictions:
            return .ai
        case .romanticFeatures, .loveLetterGenerator, .giftSuggestions, .anniversaryReminders:
            return .romance
        case .customThemes:
            return .personalization
        }
    }
}

// MARK: - Premium Categories
enum PremiumCategory: String, CaseIterable {
    case analytics = "analytics"
    case ai = "ai"
    case romance = "romance"
    case personalization = "personalization"
    
    var title: String {
        switch self {
        case .analytics:
            return "Analitik & Raporlama"
        case .ai:
            return "Yapay Zeka Özellikleri"
        case .romance:
            return "Romantik Özellikler"
        case .personalization:
            return "Kişiselleştirme"
        }
    }
    
    var description: String {
        switch self {
        case .analytics:
            return "Detaylı analizler ve raporlar"
        case .ai:
            return "AI destekli öngörüler ve öneriler"
        case .romance:
            return "İlişkinizi güçlendiren özellikler"
        case .personalization:
            return "Uygulamayı kendinize özel yapın"
        }
    }
    
    var icon: String {
        switch self {
        case .analytics:
            return "chart.bar.fill"
        case .ai:
            return "brain.head.profile"
        case .romance:
            return "heart.fill"
        case .personalization:
            return "paintbrush.fill"
        }
    }
}

// MARK: - Premium Feature Model
struct PremiumFeature: Identifiable, Hashable {
    let id = UUID()
    let type: PremiumFeatureType
    let isUnlocked: Bool
    let isPopular: Bool
    
    var title: String { type.title }
    var description: String { type.description }
    var icon: String { type.icon }
    var color: String { type.color }
    var category: PremiumCategory { type.category }
    
    init(type: PremiumFeatureType, isUnlocked: Bool = false, isPopular: Bool = false) {
        self.type = type
        self.isUnlocked = isUnlocked
        self.isPopular = isPopular
    }
}

// MARK: - Premium Subscription Plan
struct PremiumPlan: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let currency: String
    let period: String
    let originalPrice: Double?
    let discount: String?
    let isPopular: Bool
    let features: [PremiumFeatureType]
    
    var monthlyPrice: Double {
        if period == "year" {
            return price / 12
        }
        return price
    }
    
    var savings: Double? {
        guard let originalPrice = originalPrice else { return nil }
        return originalPrice - price
    }
    
    static let monthly = PremiumPlan(
        name: "Aylık",
        price: 29.99,
        currency: "₺",
        period: "month",
        originalPrice: nil,
        discount: nil,
        isPopular: false,
        features: PremiumFeatureType.allCases
    )
    
    static let yearly = PremiumPlan(
        name: "Yıllık",
        price: 199.99,
        currency: "₺",
        period: "year",
        originalPrice: 359.88,
        discount: "44% İndirim",
        isPopular: true,
        features: PremiumFeatureType.allCases
    )
}

// MARK: - Premium User Model
class PremiumUser: ObservableObject {
    @Published var isPremium: Bool = false
    @Published var subscriptionType: String? = nil
    @Published var expirationDate: Date? = nil
    @Published var features: Set<PremiumFeatureType> = []
    
    func hasFeature(_ feature: PremiumFeatureType) -> Bool {
        return isPremium && features.contains(feature)
    }
    
    func canAccessFeature(_ feature: PremiumFeatureType) -> Bool {
        return hasFeature(feature)
    }
    
    func unlockFeature(_ feature: PremiumFeatureType) {
        features.insert(feature)
    }
    
    func lockFeature(_ feature: PremiumFeatureType) {
        features.remove(feature)
    }
}

// MARK: - Premium Testimonials
struct PremiumTestimonial: Identifiable {
    let id = UUID()
    let name: String
    let rating: Int
    let comment: String
    let avatar: String
    
    static let samples = [
        PremiumTestimonial(
            name: "Ayşe & Mehmet",
            rating: 5,
            comment: "İlişkimiz hakkında hiç bilmediğimiz şeyleri öğrendik! Çok eğlenceli ve bilgilendirici.",
            avatar: "person.circle.fill"
        ),
        PremiumTestimonial(
            name: "Zeynep & Can",
            rating: 5,
            comment: "AI öngörüleri gerçekten doğru çıktı. İlişkimizi daha iyi anlıyoruz artık.",
            avatar: "person.circle.fill"
        ),
        PremiumTestimonial(
            name: "Elif & Burak",
            rating: 5,
            comment: "Aşk mektubu oluşturucu harika! Partnerim çok etkilendi.",
            avatar: "person.circle.fill"
        )
    ]
}

// MARK: - Premium FAQ
struct PremiumFAQ: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
    
    static let samples = [
        PremiumFAQ(
            question: "Premium özellikler neler?",
            answer: "Sınırsız analiz, AI öngörüleri, romantik özellikler, özel temalar ve daha fazlası!"
        ),
        PremiumFAQ(
            question: "İptal edebilir miyim?",
            answer: "Evet, istediğiniz zaman iptal edebilirsiniz. İptal sonrası premium özellikler dönem sonuna kadar aktif kalır."
        ),
        PremiumFAQ(
            question: "Verilerim güvende mi?",
            answer: "Evet, tüm verileriniz cihazınızda kalır ve hiçbir sunucuya gönderilmez. Gizliliğiniz bizim için önemli."
        ),
        PremiumFAQ(
            question: "7 gün ücretsiz deneme var mı?",
            answer: "Evet! Premium'u 7 gün ücretsiz deneyebilir, beğenmezseniz iptal edebilirsiniz."
        )
    ]
}
