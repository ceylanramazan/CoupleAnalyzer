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
            PremiumPreviewView(onDismiss: { showingPremiumPreview = false })
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

// MARK: - Premium Preview View
struct PremiumPreviewView: View {
    let onDismiss: () -> Void
    @State private var selectedFeature = 0
    
    let premiumFeatures = [
        PremiumFeature(
            title: "Sınırsız Analiz",
            description: "İstediğiniz kadar sohbet analiz edin",
            icon: "infinity.circle.fill",
            color: .blue
        ),
        PremiumFeature(
            title: "AI Öngörüleri",
            description: "Yapay zeka ile ilişki öngörüleri",
            icon: "brain.head.profile",
            color: .purple
        ),
        PremiumFeature(
            title: "Romantik Özellikler",
            description: "Aşk mektubu oluşturucu ve hediye önerileri",
            icon: "heart.text.square.fill",
            color: .pink
        ),
        PremiumFeature(
            title: "Özel Temalar",
            description: "Kişiselleştirilebilir arayüz temaları",
            icon: "paintbrush.fill",
            color: .orange
        )
    ]
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [Color.orange.opacity(0.8), Color.yellow.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Header
                HStack {
                    Button("Geri") {
                        onDismiss()
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("Premium")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Sınırsız Özellikler")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    // Placeholder for symmetry
                    Color.clear
                        .frame(width: 40)
                }
                .padding(.horizontal, 30)
                .padding(.top, 60)
                
                // Features showcase
                TabView(selection: $selectedFeature) {
                    ForEach(0..<premiumFeatures.count, id: \.self) { index in
                        PremiumFeatureCard(feature: premiumFeatures[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 300)
                
                // Pricing
                VStack(spacing: 16) {
                    Text("Özel Fiyat")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 20) {
                        VStack(spacing: 4) {
                            Text("29.99₺")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            Text("Aylık")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        VStack(spacing: 4) {
                            Text("199.99₺")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            Text("Yıllık")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }
                
                Spacer()
                
                // CTA Button
                Button("Premium'u Dene") {
                    // TODO: Implement premium purchase
                    onDismiss()
                }
                .foregroundColor(.orange)
                .font(.system(size: 18, weight: .bold))
                .padding(.horizontal, 40)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                )
                .padding(.bottom, 50)
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

struct PremiumFeatureCard: View {
    let feature: PremiumFeature
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: feature.icon)
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.white)
            
            Text(feature.title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(feature.description)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.horizontal, 30)
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

struct PremiumFeature {
    let title: String
    let description: String
    let icon: String
    let color: Color
}

#Preview {
    OnboardingView()
}