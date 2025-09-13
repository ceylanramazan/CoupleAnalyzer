import Foundation
import StoreKit

// MARK: - Premium Manager
class PremiumManager: ObservableObject {
    static let shared = PremiumManager()
    
    @Published var isPremium: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let userDefaults = UserDefaults.standard
    private let premiumKey = "isPremium"
    private let subscriptionTypeKey = "subscriptionType"
    private let expirationDateKey = "expirationDate"
    
    private init() {
        loadPremiumStatus()
    }
    
    // MARK: - Premium Status Management
    func loadPremiumStatus() {
        isPremium = userDefaults.bool(forKey: premiumKey)
    }
    
    func setPremium(_ premium: Bool, type: String? = nil, expirationDate: Date? = nil) {
        isPremium = premium
        userDefaults.set(premium, forKey: premiumKey)
        
        if let type = type {
            userDefaults.set(type, forKey: subscriptionTypeKey)
        }
        
        if let expirationDate = expirationDate {
            userDefaults.set(expirationDate, forKey: expirationDateKey)
        }
    }
    
    func clearPremium() {
        isPremium = false
        userDefaults.removeObject(forKey: premiumKey)
        userDefaults.removeObject(forKey: subscriptionTypeKey)
        userDefaults.removeObject(forKey: expirationDateKey)
    }
    
    // MARK: - Feature Access Control
    func hasFeature(_ feature: PremiumFeatureType) -> Bool {
        return isPremium
    }
    
    func canAccessFeature(_ feature: PremiumFeatureType) -> Bool {
        return hasFeature(feature)
    }
    
    func requirePremium(for feature: PremiumFeatureType, completion: @escaping (Bool) -> Void) {
        if isPremium {
            completion(true)
        } else {
            // Show premium upgrade prompt
            completion(false)
        }
    }
    
    // MARK: - Mock Premium Purchase (for development)
    func mockPurchasePremium(type: String = "yearly") {
        isLoading = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.setPremium(true, type: type, expirationDate: Calendar.current.date(byAdding: .year, value: 1, to: Date()))
            self.isLoading = false
        }
    }
    
    // MARK: - Real StoreKit Integration (for production)
    func purchasePremium(plan: PremiumPlan) {
        isLoading = true
        errorMessage = nil
        
        // TODO: Implement real StoreKit purchase
        // This is a placeholder for actual StoreKit integration
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Simulate successful purchase
            self.setPremium(true, type: plan.period, expirationDate: Calendar.current.date(byAdding: plan.period == "year" ? .year : .month, value: 1, to: Date()))
            self.isLoading = false
        }
    }
    
    func restorePurchases() {
        isLoading = true
        errorMessage = nil
        
        // TODO: Implement real StoreKit restore
        // This is a placeholder for actual StoreKit restore
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Simulate restore
            self.loadPremiumStatus()
            self.isLoading = false
        }
    }
    
    // MARK: - Analytics
    func trackPremiumEvent(_ event: PremiumEvent) {
        // TODO: Implement analytics tracking
        print("Premium Event: \(event)")
    }
}

// MARK: - Premium Events
enum PremiumEvent: String {
    case viewPremiumPage = "view_premium_page"
    case selectPlan = "select_plan"
    case startPurchase = "start_purchase"
    case completePurchase = "complete_purchase"
    case cancelPurchase = "cancel_purchase"
    case restorePurchases = "restore_purchases"
    case usePremiumFeature = "use_premium_feature"
    case premiumExpired = "premium_expired"
}

// MARK: - Premium Feature Gates
extension PremiumManager {
    
    // Analytics Features
    func canAccessUnlimitedAnalysis() -> Bool {
        return hasFeature(.unlimitedAnalysis)
    }
    
    func canAccessAdvancedAnalytics() -> Bool {
        return hasFeature(.advancedAnalytics)
    }
    
    func canExportReports() -> Bool {
        return hasFeature(.exportReports)
    }
    
    // AI Features
    func canAccessAIInsights() -> Bool {
        return hasFeature(.aiInsights)
    }
    
    func canAccessRelationshipPredictions() -> Bool {
        return hasFeature(.relationshipPredictions)
    }
    
    // Romance Features
    func canAccessRomanticFeatures() -> Bool {
        return hasFeature(.romanticFeatures)
    }
    
    func canGenerateLoveLetters() -> Bool {
        return hasFeature(.loveLetterGenerator)
    }
    
    func canGetGiftSuggestions() -> Bool {
        return hasFeature(.giftSuggestions)
    }
    
    func canSetAnniversaryReminders() -> Bool {
        return hasFeature(.anniversaryReminders)
    }
    
    // Personalization Features
    func canUseCustomThemes() -> Bool {
        return hasFeature(.customThemes)
    }
}

// MARK: - Premium Usage Limits
struct PremiumLimits {
    static let freeAnalysisLimit = 3
    static let freeExportLimit = 1
    static let freeAIInsightLimit = 1
    
    static func getAnalysisLimit(isPremium: Bool) -> Int {
        return isPremium ? Int.max : freeAnalysisLimit
    }
    
    static func getExportLimit(isPremium: Bool) -> Int {
        return isPremium ? Int.max : freeExportLimit
    }
    
    static func getAIInsightLimit(isPremium: Bool) -> Int {
        return isPremium ? Int.max : freeAIInsightLimit
    }
}
