import SwiftUI

struct PremiumView: View {
    @StateObject private var premiumManager = PremiumManager.shared
    @State private var selectedPlan: PremiumPlan = .yearly
    @State private var showingPurchaseAlert = false
    @State private var currentTestimonialIndex = 0
    @State private var isAnimating = false
    
    let onDismiss: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.orange.opacity(0.9),
                        Color.pink.opacity(0.8),
                        Color.purple.opacity(0.7)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header
                        PremiumHeaderView(onDismiss: onDismiss)
                        
                        // Hero Section
                        PremiumHeroView()
                            .padding(.top, 20)
                        
                        // Feature Categories
                        PremiumFeatureCategoriesView()
                            .padding(.top, 40)
                        
                        // Pricing Plans
                        PremiumPricingView(selectedPlan: $selectedPlan)
                            .padding(.top, 40)
                        
                        // Testimonials
                        PremiumTestimonialsView(currentIndex: $currentTestimonialIndex)
                            .padding(.top, 40)
                        
                        // FAQ Section
                        PremiumFAQView()
                            .padding(.top, 40)
                        
                        // CTA Button
                        PremiumCTAView(
                            selectedPlan: selectedPlan,
                            isLoading: premiumManager.isLoading,
                            onPurchase: {
                                premiumManager.purchasePremium(plan: selectedPlan)
                                showingPurchaseAlert = true
                            }
                        )
                        .padding(.top, 40)
                        .padding(.bottom, 50)
                    }
                }
            }
        }
        .onAppear {
            isAnimating = true
        }
        .alert("Premium Satın Alındı!", isPresented: $showingPurchaseAlert) {
            Button("Harika!") {
                onDismiss()
            }
        } message: {
            Text("Premium özellikleriniz aktif edildi. Artık tüm özelliklerden yararlanabilirsiniz!")
        }
    }
}

// MARK: - Premium Header
struct PremiumHeaderView: View {
    let onDismiss: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onDismiss) {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Geri")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(.white)
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Text("Premium")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Sınırsız Özellikler")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
            
            // Placeholder for symmetry
            Color.clear
                .frame(width: 60)
        }
        .padding(.horizontal, 24)
        .padding(.top, 60)
    }
}

// MARK: - Premium Hero
struct PremiumHeroView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Premium Badge
            HStack(spacing: 12) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.yellow)
                
                Text("Premium Üyelik")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            )
            .scaleEffect(isAnimating ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
            
            // Main Message
            VStack(spacing: 16) {
                Text("İlişkinizi Yeni Seviyeye Taşıyın")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("AI destekli analizler, romantik özellikler ve sınırsız analiz hakkı ile ilişkinizi daha iyi anlayın.")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 20)
            }
            
            // Free Trial Badge
            HStack(spacing: 8) {
                Image(systemName: "gift.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                Text("7 Gün Ücretsiz Deneme")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.green.opacity(0.8))
            )
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Feature Categories
struct PremiumFeatureCategoriesView: View {
    let categories = PremiumCategory.allCases
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Premium Özellikler")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(categories, id: \.self) { category in
                    PremiumCategoryCard(category: category)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct PremiumCategoryCard: View {
    let category: PremiumCategory
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: category.icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
            }
            .scaleEffect(isAnimating ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
            
            // Content
            VStack(spacing: 8) {
                Text(category.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(category.description)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Pricing Plans
struct PremiumPricingView: View {
    @Binding var selectedPlan: PremiumPlan
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Planınızı Seçin")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 16) {
                // Yearly Plan (Popular)
                PremiumPlanCard(
                    plan: .yearly,
                    isSelected: selectedPlan.period == "year",
                    onSelect: { selectedPlan = .yearly }
                )
                
                // Monthly Plan
                PremiumPlanCard(
                    plan: .monthly,
                    isSelected: selectedPlan.period == "month",
                    onSelect: { selectedPlan = .monthly }
                )
            }
            .padding(.horizontal, 20)
        }
    }
}

struct PremiumPlanCard: View {
    let plan: PremiumPlan
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                // Selection indicator
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.white : Color.clear)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.orange)
                    }
                }
                
                // Plan info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(plan.name)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        if plan.isPopular {
                            Text("Popüler")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.orange)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.white)
                                )
                        }
                        
                        Spacer()
                    }
                    
                    HStack(alignment: .bottom, spacing: 4) {
                        Text("\(Int(plan.price))")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(plan.currency)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("/ \(plan.period == "year" ? "yıl" : "ay")")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Spacer()
                    }
                    
                    if let discount = plan.discount {
                        Text(discount)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.green)
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.white.opacity(0.2) : Color.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.white : Color.white.opacity(0.3), lineWidth: isSelected ? 2 : 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Testimonials
struct PremiumTestimonialsView: View {
    @Binding var currentIndex: Int
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Kullanıcı Yorumları")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            TabView(selection: $currentIndex) {
                ForEach(Array(PremiumTestimonial.samples.enumerated()), id: \.offset) { index, testimonial in
                    PremiumTestimonialCard(testimonial: testimonial)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 200)
            
            // Page indicator
            HStack(spacing: 8) {
                ForEach(0..<PremiumTestimonial.samples.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.white : Color.white.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentIndex = (currentIndex + 1) % PremiumTestimonial.samples.count
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

struct PremiumTestimonialCard: View {
    let testimonial: PremiumTestimonial
    
    var body: some View {
        VStack(spacing: 16) {
            // Rating
            HStack(spacing: 4) {
                ForEach(0..<testimonial.rating, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.yellow)
                }
            }
            
            // Comment
            Text(testimonial.comment)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
            
            // Author
            Text("- \(testimonial.name)")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
    }
}

// MARK: - FAQ Section
struct PremiumFAQView: View {
    @State private var expandedFAQ: UUID?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sık Sorulan Sorular")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                ForEach(PremiumFAQ.samples) { faq in
                    PremiumFAQCard(
                        faq: faq,
                        isExpanded: expandedFAQ == faq.id,
                        onToggle: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                expandedFAQ = expandedFAQ == faq.id ? nil : faq.id
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct PremiumFAQCard: View {
    let faq: PremiumFAQ
    let isExpanded: Bool
    let onToggle: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: onToggle) {
                HStack {
                    Text(faq.question)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
                .padding(16)
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack {
                    Divider()
                        .background(Color.white.opacity(0.3))
                    
                    Text(faq.answer)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

// MARK: - CTA Button
struct PremiumCTAView: View {
    let selectedPlan: PremiumPlan
    let isLoading: Bool
    let onPurchase: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Button(action: onPurchase) {
                HStack(spacing: 12) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 18, weight: .bold))
                    }
                    
                    Text(isLoading ? "İşleniyor..." : "Premium'u Başlat")
                        .font(.system(size: 18, weight: .bold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.white, Color.white.opacity(0.9)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 28)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                )
            }
            .disabled(isLoading)
            .padding(.horizontal, 20)
            
            // Terms
            Text("7 gün ücretsiz deneme, sonrasında \(selectedPlan.price)\(selectedPlan.currency)/\(selectedPlan.period == "year" ? "yıl" : "ay")")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 40)
        }
    }
}

#Preview {
    PremiumView(onDismiss: {})
}
