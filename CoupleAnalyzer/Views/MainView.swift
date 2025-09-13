import SwiftUI
import UniformTypeIdentifiers

struct MainView: View {
    @StateObject private var viewModel = ChatAnalyzerViewModel()
    @State private var showingFilePicker = false
    @State private var showingMockDataAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.pink.opacity(0.05),
                        Color.purple.opacity(0.05),
                        Color.blue.opacity(0.05)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.pink, Color.purple]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Text("CoupleAnalyzer")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("WhatsApp sohbetlerinizi analiz edin ve ilişkiniz hakkında eğlenceli raporlar alın")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 32)
                    }
                    
                    // Action buttons
                    VStack(spacing: 20) {
                        // File upload button
                        Button(action: {
                            showingFilePicker = true
                        }) {
                            HStack {
                                Image(systemName: "doc.text.fill")
                                    .font(.title2)
                                Text("WhatsApp Sohbeti Yükle")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        
                        // Mock data button
                        Button(action: {
                            showingMockDataAlert = true
                        }) {
                            HStack {
                                Image(systemName: "wand.and.stars")
                                    .font(.title2)
                                Text("Demo Verilerle Dene")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.pink)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.pink.opacity(0.1))
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.pink.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    // Features preview
                    VStack(spacing: 16) {
                        Text("Analiz Özellikleri")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            FeatureCard(
                                icon: "face.smiling",
                                title: "Emoji Analizi",
                                description: "En çok kullandığınız emojiler",
                                color: Color.orange
                            )
                            
                            FeatureCard(
                                icon: "text.bubble.fill",
                                title: "Kelime Analizi",
                                description: "En sık kullanılan kelimeler",
                                color: Color.green
                            )
                            
                            FeatureCard(
                                icon: "chart.bar.fill",
                                title: "İstatistikler",
                                description: "Mesaj sayıları ve süreler",
                                color: Color.blue
                            )
                            
                            FeatureCard(
                                icon: "heart.fill",
                                title: "Romantik Analiz",
                                description: "Sevgi ve duygu analizi",
                                color: Color.pink
                            )
                        }
                        .padding(.horizontal, 32)
                    }
                    
                    Spacer()
                }
            }
        }
        .fileImporter(
            isPresented: $showingFilePicker,
            allowedContentTypes: [UTType.plainText],
            allowsMultipleSelection: false
        ) { result in
            handleFileImport(result)
        }
        .alert("Demo Veriler", isPresented: $showingMockDataAlert) {
            Button("İptal", role: .cancel) { }
            Button("Demo Başlat") {
                viewModel.analyzeWithMockData()
            }
        } message: {
            Text("Demo verilerle analiz yapmak istediğinizden emin misiniz? Bu işlem örnek WhatsApp sohbet verileri kullanacaktır.")
        }
        .fullScreenCover(isPresented: $viewModel.showingResults) {
            if let analysisResult = viewModel.analysisResult {
                DashboardView(analysisResult: analysisResult, viewModel: viewModel)
            }
        }
        .overlay(
            // Loading overlay
            Group {
                if viewModel.isLoading {
                    LoadingView()
                }
            }
        )
        .alert("Hata", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("Tamam") {
                viewModel.clearError()
            }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }
    
    private func handleFileImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            
            do {
                let content = try String(contentsOf: url, encoding: .utf8)
                viewModel.loadAndAnalyzeChat(content)
            } catch {
                viewModel.errorMessage = "Dosya okunamadı: \(error.localizedDescription)"
            }
            
        case .failure(let error):
            viewModel.errorMessage = "Dosya seçilemedi: \(error.localizedDescription)"
        }
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color.white.opacity(0.8))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

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

#Preview {
    MainView()
}
