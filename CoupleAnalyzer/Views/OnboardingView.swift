import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showingMainApp = false
    @State private var dragOffset: CGFloat = 0
    
    let onboardingPages = [
        OnboardingPage(
            title: "CoupleAnalyzer'a Hoş Geldiniz! 💕",
            description: "WhatsApp sohbetlerinizi analiz ederek ilişkiniz hakkında eğlenceli ve ilginç bilgiler keşfedin.",
            icon: "heart.fill",
            gradient: [Color.pink.opacity(0.8), Color.purple.opacity(0.6)],
            accentColor: .pink
        ),
        OnboardingPage(
            title: "Sohbet Analizi 📊",
            description: "En çok kullandığınız kelimeler, emojiler ve mesaj istatistiklerinizi görün.",
            icon: "chart.bar.fill",
            gradient: [Color.blue.opacity(0.8), Color.cyan.opacity(0.6)],
            accentColor: .blue
        ),
        OnboardingPage(
            title: "İlişki Dinamikleri 💑",
            description: "Kim daha çok mesaj atıyor? En romantik gününüz hangisi? Bu ve daha fazlasını öğrenin!",
            icon: "person.2.fill",
            gradient: [Color.purple.opacity(0.8), Color.pink.opacity(0.6)],
            accentColor: .purple
        ),
        OnboardingPage(
            title: "Başlayalım! 🚀",
            description: "WhatsApp sohbet dosyanızı yükleyin ve analiz etmeye başlayın. Tüm verileriniz cihazınızda kalır.",
            icon: "arrow.right.circle.fill",
            gradient: [Color.green.opacity(0.8), Color.mint.opacity(0.6)],
            accentColor: .green
        )
    ]
    
    var body: some View {
        if showingMainApp {
            MainView()
        } else {
            GeometryReader { geometry in
                ZStack {
                    // Dynamic background gradient
                    LinearGradient(
                        gradient: Gradient(colors: onboardingPages[currentPage].gradient),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 0.8), value: currentPage)
                    
                    // Floating particles effect
                    ForEach(0..<15, id: \.self) { index in
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
                    
                    VStack(spacing: 0) {
                        // Custom page indicator
                        HStack(spacing: 12) {
                            ForEach(0..<onboardingPages.count, id: \.self) { index in
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(index == currentPage ? Color.white : Color.white.opacity(0.3))
                                    .frame(width: index == currentPage ? 24 : 8, height: 8)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: currentPage)
                            }
                        }
                        .padding(.top, 60)
                        .padding(.bottom, 40)
                        
                        // Main content with smooth transitions
                        TabView(selection: $currentPage) {
                            ForEach(0..<onboardingPages.count, id: \.self) { index in
                                OnboardingPageView(
                                    page: onboardingPages[index],
                                    geometry: geometry
                                )
                                .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .animation(.easeInOut(duration: 0.5), value: currentPage)
                        
                        Spacer()
                        
                        // Navigation buttons with beautiful styling
                        HStack {
                            if currentPage > 0 {
                                Button(action: {
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                        currentPage -= 1
                                    }
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "chevron.left")
                                            .font(.system(size: 16, weight: .semibold))
                                        Text("Geri")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    .foregroundColor(.white)
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
                                }
                            }
                            
                            Spacer()
                            
                            if currentPage < onboardingPages.count - 1 {
                                Button(action: {
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                        currentPage += 1
                                    }
                                }) {
                                    HStack(spacing: 8) {
                                        Text("İleri")
                                            .font(.system(size: 16, weight: .semibold))
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(Color.white.opacity(0.3))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 25)
                                                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                            )
                                    )
                                }
                            } else {
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
                                    .foregroundColor(onboardingPages[currentPage].accentColor)
                                    .padding(.horizontal, 32)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 30)
                                            .fill(Color.white)
                                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 50)
                    }
                }
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let icon: String
    let gradient: [Color]
    let accentColor: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let geometry: GeometryProxy
    
    @State private var iconScale: CGFloat = 0.8
    @State private var titleOffset: CGFloat = 50
    @State private var descriptionOffset: CGFloat = 30
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Animated icon with glow effect
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 120, height: 120)
                    .blur(radius: 20)
                
                Image(systemName: page.icon)
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(.white)
                    .scaleEffect(iconScale)
                    .shadow(color: .white.opacity(0.3), radius: 10, x: 0, y: 0)
            }
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
                    iconScale = 1.0
                }
            }
            
            // Title with slide-in animation
            Text(page.title)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .offset(y: titleOffset)
                .onAppear {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.4)) {
                        titleOffset = 0
                    }
                }
            
            // Description with fade-in animation
            Text(page.description)
                .font(.system(size: 18, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.9))
                .padding(.horizontal, 30)
                .lineSpacing(6)
                .offset(y: descriptionOffset)
                .onAppear {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.6)) {
                        descriptionOffset = 0
                    }
                }
            
            Spacer()
        }
        .onAppear {
            // Reset animations when page changes
            iconScale = 0.8
            titleOffset = 50
            descriptionOffset = 30
            
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
                iconScale = 1.0
            }
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.4)) {
                titleOffset = 0
            }
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.6)) {
                descriptionOffset = 0
            }
        }
    }
}

#Preview {
    OnboardingView()
}
