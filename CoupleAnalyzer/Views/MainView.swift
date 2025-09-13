import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = ChatAnalyzerViewModel()
    @State private var showingFilePicker = false
    @State private var showingPremium = false
    @State private var animateElements = false
    @State private var animateCards = false
    @State private var animateHero = false
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.98, green: 0.95, blue: 1.0),
                    Color(red: 0.95, green: 0.98, blue: 1.0),
                    Color(red: 0.92, green: 0.95, blue: 1.0)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // Hero Section
                    HeroSection(animateHero: $animateHero)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    
                    // Main Action Card
                    MainActionCard(
                        showingFilePicker: $showingFilePicker,
                        animateElements: $animateElements
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                    
                    // Features Section
                    FeaturesSection(animateCards: $animateCards)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                    
                    // Premium Preview
                    PremiumPreviewCard(showingPremium: $showingPremium)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                    
                    // How It Works
                    HowItWorksSection()
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.8)) {
                    animateHero = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeOut(duration: 0.6)) {
                        animateElements = true
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation(.easeOut(duration: 0.6)) {
                        animateCards = true
                    }
                }
            }
            
            // Analysis Results
            if let analysisResult = viewModel.analysisResult {
                DashboardView(analysisResult: analysisResult, viewModel: viewModel)
            }
        }
        .sheet(isPresented: $showingFilePicker) {
            DocumentPicker { url in
                // File analysis işlemi
                print("File selected: \(url)")
            }
        }
        .sheet(isPresented: $showingPremium) {
            PremiumPlaceholderView()
        }
        .overlay(
            // Loading overlay
            Group {
                if viewModel.isLoading {
                    LoadingView()
                }
            }
        )
    }
}

// MARK: - Hero Section
struct HeroSection: View {
    @Binding var animateHero: Bool
    @State private var heartBeat = false
    
    var body: some View {
        VStack(spacing: 16) {
            // App Icon with Animation
            ZStack {
                // Glow effect
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.pink.opacity(0.2),
                                Color.purple.opacity(0.1),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 20,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                    .scaleEffect(heartBeat ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: heartBeat)
                
                // Main icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.pink, Color.purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .shadow(color: Color.pink.opacity(0.3), radius: 20, x: 0, y: 10)
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 50, weight: .medium))
                        .foregroundColor(.white)
                        .scaleEffect(heartBeat ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: heartBeat)
                }
            }
            .scaleEffect(animateHero ? 1.0 : 0.8)
            .opacity(animateHero ? 1.0 : 0.0)
            
            // Title and Description
            VStack(spacing: 12) {
                Text("CoupleAnalyzer")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .scaleEffect(animateHero ? 1.0 : 0.9)
                    .opacity(animateHero ? 1.0 : 0.0)
                
                Text("WhatsApp sohbetlerinizi analiz edin ve ilişkiniz hakkında eğlenceli raporlar alın")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 32)
                    .scaleEffect(animateHero ? 1.0 : 0.9)
                    .opacity(animateHero ? 1.0 : 0.0)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                heartBeat = true
            }
        }
    }
}

// MARK: - Main Action Card
struct MainActionCard: View {
    @Binding var showingFilePicker: Bool
    @Binding var animateElements: Bool
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Card Header
            VStack(spacing: 12) {
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(.pink)
                
                Text("Sohbetinizi Analiz Edin")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("WhatsApp sohbet dosyanızı yükleyin ve ilişkiniz hakkında detaylı analiz alın")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            
            // Upload Button
            Button(action: {
                showingFilePicker = true
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("WhatsApp Sohbeti Yükle")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.pink, Color.purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: Color.pink.opacity(0.3), radius: 12, x: 0, y: 6)
            }
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isPressed = false
                    }
                }
            }
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 20, x: 0, y: 10)
        )
        .scaleEffect(animateElements ? 1.0 : 0.9)
        .opacity(animateElements ? 1.0 : 0.0)
    }
}

// MARK: - Features Section
struct FeaturesSection: View {
    @Binding var animateCards: Bool
    
    let features = [
        FeatureItem(
            icon: "face.smiling",
            title: "Emoji Analizi",
            description: "En çok kullandığınız emojiler ve duygusal durumunuz",
            color: Color.orange
        ),
        FeatureItem(
            icon: "text.bubble.fill",
            title: "Kelime Analizi",
            description: "En sık kullanılan kelimeler ve iletişim tarzınız",
            color: Color.green
        ),
        FeatureItem(
            icon: "chart.bar.fill",
            title: "İstatistikler",
            description: "Mesaj sayıları, aktif saatler ve iletişim kalıpları",
            color: Color.blue
        ),
        FeatureItem(
            icon: "heart.fill",
            title: "Romantik Analiz",
            description: "Sevgi ifadeleri ve duygusal bağ analizi",
            color: Color.pink
        )
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Analiz Özellikleri")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 20) {
                ForEach(Array(features.enumerated()), id: \.offset) { index, feature in
                    FeatureCard(feature: feature)
                        .scaleEffect(animateCards ? 1.0 : 0.8)
                        .opacity(animateCards ? 1.0 : 0.0)
                        .animation(
                            .easeOut(duration: 0.6)
                            .delay(Double(index) * 0.1),
                            value: animateCards
                        )
                }
            }
        }
    }
}

struct FeatureItem {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

struct FeatureCard: View {
    let feature: FeatureItem
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(feature.color.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: feature.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(feature.color)
            }
            
            VStack(spacing: 8) {
                Text(feature.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(feature.description)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
        }
        .frame(height: 160)
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
        }
    }
}

// MARK: - Premium Preview Card
struct PremiumPreviewCard: View {
    @Binding var showingPremium: Bool
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Image(systemName: "crown.fill")
                            .font(.title2)
                            .foregroundColor(.yellow)
                        
                        Text("Premium")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primary)
                    }
                    
                    Text("Gelişmiş analizler ve özel özellikler")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button("Görüntüle") {
                    showingPremium = true
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.pink)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.pink.opacity(0.1))
                )
            }
            
            HStack(spacing: 16) {
                PremiumFeatureItem(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Trend Analizi"
                )
                
                PremiumFeatureItem(
                    icon: "square.and.arrow.up",
                    title: "Paylaşım"
                )
                
                PremiumFeatureItem(
                    icon: "infinity",
                    title: "Sınırsız Analiz"
                )
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.yellow.opacity(0.1),
                            Color.orange.opacity(0.05)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                )
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
        }
    }
}

struct PremiumFeatureItem: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.yellow)
            
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - How It Works Section
struct HowItWorksSection: View {
    let steps = [
        HowItWorksStep(
            number: "1",
            title: "Sohbeti Yükle",
            description: "WhatsApp'tan sohbeti dışa aktarın",
            icon: "square.and.arrow.up"
        ),
        HowItWorksStep(
            number: "2",
            title: "Analiz Et",
            description: "AI sohbetinizi detaylı analiz eder",
            icon: "brain.head.profile"
        ),
        HowItWorksStep(
            number: "3",
            title: "Raporu Gör",
            description: "İlişkiniz hakkında eğlenceli raporlar",
            icon: "chart.bar.doc.horizontal"
        )
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Nasıl Çalışır?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                Spacer()
            }
            
            VStack(spacing: 20) {
                ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                    HowItWorksStepView(step: step, index: index)
                }
            }
        }
    }
}

struct HowItWorksStep {
    let number: String
    let title: String
    let description: String
    let icon: String
}

struct HowItWorksStepView: View {
    let step: HowItWorksStep
    let index: Int
    
    var body: some View {
        HStack(spacing: 20) {
            // Step Number
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.pink, Color.purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Text(step.number)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // Step Content
            VStack(alignment: .leading, spacing: 4) {
                Text(step.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(step.description)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Step Icon
            Image(systemName: step.icon)
                .font(.title2)
                .foregroundColor(.pink)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - Document Picker
struct DocumentPicker: UIViewControllerRepresentable {
    let onDocumentPicked: (URL) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.text])
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            parent.onDocumentPicked(url)
        }
    }
}

// MARK: - Loading View
struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .stroke(Color.pink.opacity(0.3), lineWidth: 4)
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.pink, Color.purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                }
                
                Text("Analiz ediliyor...")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(32)
            .background(Color.black.opacity(0.8))
            .cornerRadius(20)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Premium Placeholder
struct PremiumPlaceholderView: View {
    var body: some View {
        VStack {
            Text("Premium Özellikler")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Text("Premium özellikler yakında gelecek!")
                .font(.body)
                .foregroundColor(.secondary)
                .padding()
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    MainView()
}