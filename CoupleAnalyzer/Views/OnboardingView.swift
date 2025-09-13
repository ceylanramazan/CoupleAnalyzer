import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showingMainApp = false
    @State private var showingPremiumPreview = false
    @State private var isAnimating = false
    
    let onboardingPages = [
        OnboardingPage(
            title: "CoupleAnalyzer'a Hoş Geldiniz! 💕",
            description: "WhatsApp sohbetlerinizi analiz ederek ilişkiniz hakkında eğlenceli ve ilginç bilgiler keşfedin.",
            icon: "heart.fill",
            gradient: [Color.pink.opacity(0.8), Color.purple.opacity(0.6)],
            accentColor: .pink,
            features: ["Ücretsiz analiz", "Gizlilik garantisi", "Anında sonuçlar"]
        ),
        OnboardingPage(
            title: "Sohbet Analizi 📊",
            description: "En çok kullandığınız kelimeler, emojiler ve mesaj istatistiklerinizi görün.",
            icon: "chart.bar.fill",
            gradient: [Color.blue.opacity(0.8), Color.cyan.opacity(0.6)],
            accentColor: .blue,
            features: ["Emoji analizi", "Kelime istatistikleri", "Zaman analizi"]
        ),
        OnboardingPage(
            title: "İlişki Dinamikleri 💑",
            description: "Kim daha çok mesaj atıyor? En romantik gününüz hangisi? Bu ve daha fazlasını öğrenin!",
            icon: "person.2.fill",
            gradient: [Color.purple.opacity(0.8), Color.pink.opacity(0.6)],
            accentColor: .purple,
            features: ["Uyumluluk puanı", "Romantik günler", "İletişim kalıpları"]
        ),
        OnboardingPage(
            title: "Premium Özellikler ✨",
            description: "Daha derinlemesine analizler, romantik özellikler ve sınırsız analiz hakkı!",
            icon: "star.fill",
            gradient: [Color.orange.opacity(0.8), Color.yellow.opacity(0.6)],
            accentColor: .orange,
            features: ["Sınırsız analiz", "AI öngörüleri", "Romantik özellikler"],
            isPremium: true
        ),
        OnboardingPage(
            title: "Başlayalım! 🚀",
            description: "WhatsApp sohbet dosyanızı yükleyin ve analiz etmeye başlayın. Tüm verileriniz cihazınızda kalır.",
            icon: "arrow.right.circle.fill",
            gradient: [Color.green.opacity(0.8), Color.mint.opacity(0.6)],
            accentColor: .green,
            features: ["Güvenli analiz", "Hızlı işlem", "Detaylı raporlar"]
        )
    ]
    
    var body: some View {
        if showingMainApp {
            MainView()
        } else if showingPremiumPreview {
            PremiumPreviewPlaceholder(onDismiss: { showingPremiumPreview = false })
        } else {
            GeometryReader { geometry in
                ZStack {
                    // Dynamic background gradient with enhanced animation
                    LinearGradient(
                        gradient: Gradient(colors: onboardingPages[currentPage].gradient),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 1.2), value: currentPage)
                    
                    // Enhanced floating particles with more variety
                    ForEach(0..<25, id: \.self) { index in
                        ParticleView(
                            index: index,
                            geometry: geometry,
                            currentPage: currentPage
                        )
                    }
                    
                    // Animated background shapes
                    ForEach(0..<3, id: \.self) { index in
                        AnimatedShape(
                            index: index,
                            geometry: geometry,
                            currentPage: currentPage
                        )
                    }
                    
                    VStack(spacing: 0) {
                        // Main content with enhanced transitions
                        TabView(selection: $currentPage) {
                            ForEach(0..<onboardingPages.count, id: \.self) { index in
                                EnhancedOnboardingPageView(
                                    page: onboardingPages[index],
                                    geometry: geometry,
                                    isAnimating: isAnimating
                                )
                                .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .animation(.easeInOut(duration: 0.8), value: currentPage)
                        
                        // Enhanced page indicator at bottom with premium styling
                        VStack(spacing: 20) {
                            // Premium preview button for page 3
                            if currentPage == 3 {
                                Button(action: {
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                        showingPremiumPreview = true
                                    }
                                }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 16, weight: .bold))
                                        Text("Premium Özellikleri Gör")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [Color.orange, Color.yellow]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .shadow(color: .orange.opacity(0.3), radius: 10, x: 0, y: 5)
                                    )
                                }
                                .scaleEffect(isAnimating ? 1.05 : 1.0)
                                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                            }
                            
                            // Page indicator moved to bottom
                            HStack(spacing: 12) {
                                ForEach(0..<onboardingPages.count, id: \.self) { index in
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(index == currentPage ? Color.white : Color.white.opacity(0.3))
                                        .frame(width: index == currentPage ? 32 : 8, height: 8)
                                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: currentPage)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                }
                            }
                            
                            // Start button only on last page
                            if currentPage == onboardingPages.count - 1 {
                                Button(action: {
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                        showingMainApp = true
                                    }
                                }) {
                                    HStack(spacing: 12) {
                                        Text("Başla")
                                            .font(.system(size: 18, weight: .bold))
                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 16, weight: .bold))
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 32)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 30)
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [Color.green, Color.mint]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .shadow(color: .green.opacity(0.3), radius: 10, x: 0, y: 5)
                                    )
                                }
                            }
                        }
                        .padding(.bottom, 50)
                    }
                }
            }
            .onAppear {
                isAnimating = true
            }
        }
    }
}

// MARK: - Enhanced Onboarding Page View
struct EnhancedOnboardingPageView: View {
    let page: OnboardingPage
    let geometry: GeometryProxy
    let isAnimating: Bool
    
    @State private var iconScale: CGFloat = 0.8
    @State private var titleOffset: CGFloat = 50
    @State private var descriptionOffset: CGFloat = 30
    @State private var featuresOffset: CGFloat = 20
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Spacer(minLength: 60)
                
                // Enhanced animated icon with premium styling
                ZStack {
                    // Glow effect
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [Color.white.opacity(0.3), Color.clear]),
                                center: .center,
                                startRadius: 0,
                                endRadius: 80
                            )
                        )
                        .frame(width: 160, height: 160)
                        .blur(radius: 20)
                    
                    // Main icon container
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 120, height: 120)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: 2)
                        )
                    
                    // Icon with premium styling
                    Image(systemName: page.icon)
                        .font(.system(size: 50, weight: .light))
                        .foregroundColor(.white)
                        .scaleEffect(iconScale)
                        .shadow(color: .white.opacity(0.5), radius: 10, x: 0, y: 0)
                    
                    // Premium badge for premium page
                    if page.isPremium {
                        VStack {
                            HStack {
                                Spacer()
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.yellow)
                                    .padding(8)
                                    .background(
                                        Circle()
                                            .fill(Color.white)
                                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                                    )
                            }
                            Spacer()
                        }
                        .frame(width: 120, height: 120)
                    }
                }
                .onAppear {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
                        iconScale = 1.0
                    }
                }
                
                // Enhanced title with better typography - NO TRUNCATION
                Text(page.title)
                    .font(.system(size: min(28, geometry.size.width * 0.07), weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .fixedSize(horizontal: false, vertical: true)
                    .offset(y: titleOffset)
                    .onAppear {
                        withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.4)) {
                            titleOffset = 0
                        }
                    }
                
                // Enhanced description - NO TRUNCATION
                Text(page.description)
                    .font(.system(size: min(18, geometry.size.width * 0.045), weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 30)
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
                    .offset(y: descriptionOffset)
                    .onAppear {
                        withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.6)) {
                            descriptionOffset = 0
                        }
                    }
                
                // Feature highlights - NO TRUNCATION
                if !page.features.isEmpty {
                    VStack(spacing: 12) {
                        ForEach(Array(page.features.enumerated()), id: \.offset) { index, feature in
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(page.accentColor)
                                
                                Text(feature)
                                    .font(.system(size: min(16, geometry.size.width * 0.04), weight: .medium))
                                    .foregroundColor(.white.opacity(0.9))
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .offset(y: featuresOffset)
                            .onAppear {
                                withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.8 + Double(index) * 0.1)) {
                                    featuresOffset = 0
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                }
                
                Spacer(minLength: 100)
            }
        }
        .onAppear {
            // Reset animations when page changes
            iconScale = 0.8
            titleOffset = 50
            descriptionOffset = 30
            featuresOffset = 20
            
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
                iconScale = 1.0
            }
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.4)) {
                titleOffset = 0
            }
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.6)) {
                descriptionOffset = 0
            }
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.8)) {
                featuresOffset = 0
            }
        }
    }
}


// MARK: - Supporting Views
struct ParticleView: View {
    let index: Int
    let geometry: GeometryProxy
    let currentPage: Int
    
    var body: some View {
        Circle()
            .fill(Color.white.opacity(0.1))
            .frame(width: CGFloat.random(in: 4...12))
            .position(
                x: CGFloat.random(in: 0...geometry.size.width),
                y: CGFloat.random(in: 0...geometry.size.height)
            )
            .animation(
                Animation.easeInOut(duration: Double.random(in: 3...6))
                    .repeatForever(autoreverses: true)
                    .delay(Double.random(in: 0...2)),
                value: currentPage
            )
    }
}

struct AnimatedShape: View {
    let index: Int
    let geometry: GeometryProxy
    let currentPage: Int
    
    var body: some View {
        Circle()
            .fill(Color.white.opacity(0.05))
            .frame(width: CGFloat.random(in: 100...200))
            .position(
                x: CGFloat.random(in: 0...geometry.size.width),
                y: CGFloat.random(in: 0...geometry.size.height)
            )
            .animation(
                Animation.easeInOut(duration: Double.random(in: 8...12))
                    .repeatForever(autoreverses: true)
                    .delay(Double.random(in: 0...4)),
                value: currentPage
            )
    }
}


// MARK: - Data Models
struct OnboardingPage {
    let title: String
    let description: String
    let icon: String
    let gradient: [Color]
    let accentColor: Color
    let features: [String]
    let isPremium: Bool
    
    init(title: String, description: String, icon: String, gradient: [Color], accentColor: Color, features: [String] = [], isPremium: Bool = false) {
        self.title = title
        self.description = description
        self.icon = icon
        self.gradient = gradient
        self.accentColor = accentColor
        self.features = features
        self.isPremium = isPremium
    }
}

// MARK: - Premium Preview Placeholder
struct PremiumPreviewPlaceholder: View {
    let onDismiss: () -> Void
    @State private var currentFeatureIndex = 0
    @State private var isAnimating = false
    
    let premiumFeatures = [
        PremiumFeatureData(
            icon: "infinity.circle.fill",
            title: "Sınırsız Analiz",
            description: "İstediğiniz kadar sohbet analiz edin",
            color: .blue
        ),
        PremiumFeatureData(
            icon: "brain.head.profile",
            title: "AI Öngörüleri",
            description: "Yapay zeka ile ilişki öngörüleri",
            color: .purple
        ),
        PremiumFeatureData(
            icon: "heart.text.square.fill",
            title: "Romantik Özellikler",
            description: "Aşk mektubu oluşturucu ve hediye önerileri",
            color: .pink
        ),
        PremiumFeatureData(
            icon: "paintbrush.fill",
            title: "Özel Temalar",
            description: "Kişiselleştirilebilir arayüz temaları",
            color: .orange
        )
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Enhanced Background with multiple gradients
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.purple.opacity(0.8),
                            Color.pink.opacity(0.7),
                            Color.orange.opacity(0.6)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    // Animated background shapes
                    ForEach(0..<5, id: \.self) { index in
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: CGFloat.random(in: 100...300))
                            .position(
                                x: CGFloat.random(in: 0...geometry.size.width),
                                y: CGFloat.random(in: 0...geometry.size.height)
                            )
                            .animation(
                                Animation.easeInOut(duration: Double.random(in: 3...6))
                                    .repeatForever(autoreverses: true)
                                    .delay(Double.random(in: 0...2)),
                                value: isAnimating
                            )
                    }
                }
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Enhanced Header
                        VStack(spacing: 0) {
                            // Top row with X button
                            HStack {
                                Spacer()
                                
                                // X Button
                                Button(action: onDismiss) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.white.opacity(0.15))
                                            .frame(width: 36, height: 36)
                                        
                                        Image(systemName: "xmark")
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 60)
                            .padding(.bottom, 20)
                            
                            // Centered title
                            VStack(spacing: 6) {
                                Text("Premium")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("Sınırsız Özellikler")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .padding(.bottom, 20)
                        }
                        
                        // Hero Section
                        VStack(spacing: 24) {
                            // Premium Badge with Animation
                            HStack(spacing: 12) {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.yellow)
                                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                                
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
                        .padding(.top, 20)
                        
                        // Feature Showcase
                        VStack(spacing: 24) {
                            Text("Premium Özellikler")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                ForEach(Array(premiumFeatures.enumerated()), id: \.offset) { index, feature in
                                    PremiumFeatureCard(feature: feature, index: index)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.top, 40)
                        
                        // Pricing Section
                        VStack(spacing: 20) {
                            Text("Planınızı Seçin")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            VStack(spacing: 16) {
                                // Yearly Plan (Popular)
                                PremiumPlanCard(
                                    title: "Yıllık",
                                    price: "199.99₺",
                                    period: "yıl",
                                    originalPrice: "359.88₺",
                                    discount: "44% İndirim",
                                    isPopular: true
                                )
                                
                                // Monthly Plan
                                PremiumPlanCard(
                                    title: "Aylık",
                                    price: "29.99₺",
                                    period: "ay",
                                    originalPrice: nil,
                                    discount: nil,
                                    isPopular: false
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.top, 40)
                        
                        // Testimonials
                        VStack(spacing: 20) {
                            Text("Kullanıcı Yorumları")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            TabView(selection: $currentFeatureIndex) {
                                ForEach(0..<3, id: \.self) { index in
                                    PremiumTestimonialCard(index: index)
                                        .tag(index)
                                }
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            .frame(height: 200)
                            
                            // Page indicator
                            HStack(spacing: 8) {
                                ForEach(0..<3, id: \.self) { index in
                                    Circle()
                                        .fill(index == currentFeatureIndex ? Color.white : Color.white.opacity(0.3))
                                        .frame(width: 8, height: 8)
                                }
                            }
                        }
                        .padding(.top, 40)
                        
                        // CTA Button
                        VStack(spacing: 16) {
                            Button(action: {
                                // TODO: Implement premium purchase
                                onDismiss()
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "crown.fill")
                                        .font(.system(size: 18, weight: .bold))
                                    
                                    Text("Premium'u Başlat")
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
                            .padding(.horizontal, 20)
                            
                            // Terms
                            Text("7 gün ücretsiz deneme, sonrasında 199.99₺/yıl")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.horizontal, 40)
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 50)
                    }
                }
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Supporting Views
struct PremiumFeatureData {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

struct PremiumFeatureCard: View {
    let feature: PremiumFeatureData
    let index: Int
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: feature.icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
            }
            .scaleEffect(isAnimating ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
            
            // Content
            VStack(spacing: 8) {
                Text(feature.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(feature.description)
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
            withAnimation(.easeInOut(duration: 0.5).delay(Double(index) * 0.1)) {
                isAnimating = true
            }
        }
    }
}

struct PremiumPlanCard: View {
    let title: String
    let price: String
    let period: String
    let originalPrice: String?
    let discount: String?
    let isPopular: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        if isPopular {
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
                        Text(price)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("/ \(period)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Spacer()
                    }
                    
                    if let discount = discount {
                        Text(discount)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.green)
                    }
                }
                
                Spacer()
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isPopular ? Color.white.opacity(0.2) : Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isPopular ? Color.white : Color.white.opacity(0.3), lineWidth: isPopular ? 2 : 1)
                )
        )
    }
}

struct PremiumTestimonialCard: View {
    let index: Int
    
    let testimonials = [
        ("Ayşe & Mehmet", "İlişkimiz hakkında hiç bilmediğimiz şeyleri öğrendik! Çok eğlenceli ve bilgilendirici.", 5),
        ("Zeynep & Can", "AI öngörüleri gerçekten doğru çıktı. İlişkimizi daha iyi anlıyoruz artık.", 5),
        ("Elif & Burak", "Aşk mektubu oluşturucu harika! Partnerim çok etkilendi.", 5)
    ]
    
    var body: some View {
        let testimonial = testimonials[index]
        
        VStack(spacing: 16) {
            // Rating
            HStack(spacing: 4) {
                ForEach(0..<testimonial.2, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.yellow)
                }
            }
            
            // Comment
            Text(testimonial.1)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
            
            // Author
            Text("- \(testimonial.0)")
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

#Preview {
    OnboardingView()
}