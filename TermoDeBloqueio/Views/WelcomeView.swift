import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var currentPage = 0
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.96, green: 0.96, blue: 0.97), Color(red: 0.92, green: 0.92, blue: 0.94)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    if currentPage < 4 {
                        Button(action: {
                            coordinator.dismissWelcome()
                        }) {
                            Text("Pular")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                        }
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal, 24)
                
                Spacer()
                
                TabView(selection: $currentPage) {
                    WelcomePage(
                        icon: "brain.head.profile",
                        iconColor: Color(red: 0.40, green: 0.71, blue: 0.38),
                        title: "Bem-vindo ao\nPalavrada de Bloqueio",
                        subtitle: "Transforme seu vício em apps em um hábito de treinar o cérebro!",
                        features: [
                            ("checkmark.circle.fill", "Bloqueie apps distrativos"),
                            ("gamecontroller.fill", "Jogue Palavrada para desbloquear"),
                            ("calendar", "Desafios diários")
                        ],
                        showDots: true,
                        currentPage: $currentPage,
                        pageNumber: 0
                    )
                    .tag(0)
                    
                    WelcomePage(
                        icon: "lock.shield.fill",
                        iconColor: Color(red: 0.90, green: 0.30, blue: 0.30),
                        title: "Como Funciona\no Bloqueio",
                        subtitle: "Escolha apps que você quer usar menos (Instagram, TikTok, etc). Eles ficarão bloqueados até você resolver as Palavradas do dia.",
                        features: [
                            ("iphone.and.arrow.forward", "Selecione os apps"),
                            ("moon.zzz.fill", "Bloqueio automático à meia-noite"),
                            ("lock.open.fill", "Desbloqueie jogando")
                        ],
                        showDots: true,
                        currentPage: $currentPage,
                        pageNumber: 1
                    )
                    .tag(1)
                    
                    WelcomePage(
                        icon: "gamecontroller.fill",
                        iconColor: Color(red: 0.85, green: 0.73, blue: 0.20),
                        title: "3 Modos de Jogo",
                        subtitle: "Quanto mais difícil, mais palavras você precisa descobrir para desbloquear:",
                        features: [
                            ("square.fill", "Palavrada: 1 palavra (Fácil)"),
                            ("square.split.2x1.fill", "Dueto: 2 palavras (Médio)"),
                            ("square.grid.2x2.fill", "Quarteto: 4 palavras (Difícil)")
                        ],
                        showDots: true,
                        currentPage: $currentPage,
                        pageNumber: 2
                    )
                    .tag(2)
                    
                    WelcomePage(
                        icon: "hand.raised.fill",
                        iconColor: Color(red: 0.35, green: 0.65, blue: 0.85),
                        title: "Sua Privacidade\nem Primeiro Lugar",
                        subtitle: "Usamos o FamilyControls da Apple para bloquear apps. Seus dados nunca saem do seu iPhone.",
                        features: [
                            ("checkmark.shield.fill", "100% local no seu iPhone"),
                            ("eye.slash.fill", "Nenhuma coleta de dados"),
                            ("leaf.fill", "Open source e gratuito")
                        ],
                        showDots: true,
                        currentPage: $currentPage,
                        pageNumber: 3
                    )
                    .tag(3)
                    
                    WelcomePage(
                        icon: "star.fill",
                        iconColor: Color(red: 0.40, green: 0.71, blue: 0.38),
                        title: "Pronto para\nComeçar?",
                        subtitle: "Configure sua dificuldade, selecione os apps que quer bloquear e comece a treinar seu cérebro!",
                        features: [],
                        showDots: true,
                        currentPage: $currentPage,
                        pageNumber: 4,
                        isLast: true,
                        onContinue: {
                            coordinator.dismissWelcome()
                        }
                    )
                    .tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                Spacer()
            }
            .opacity(showContent ? 1.0 : 0.0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showContent = true
            }
        }
    }
}

struct WelcomePage: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let features: [(String, String)]
    let showDots: Bool
    @Binding var currentPage: Int
    let pageNumber: Int
    var isLast: Bool = false
    var onContinue: (() -> Void)? = nil
    
    @State private var showFeatures = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 120, height: 120)
                
                Image(systemName: icon)
                    .font(.system(size: 56, weight: .bold))
                    .foregroundColor(iconColor)
            }
            .padding(.top, 40)
            
            Spacer()
                .frame(height: 40)
            
            VStack(spacing: 16) {
                Text(title)
                    .font(.system(size: 30, weight: .black, design: .rounded))
                    .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .lineSpacing(4)
                
                Text(subtitle)
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .lineSpacing(6)
            }
            
            if !features.isEmpty {
                VStack(spacing: 16) {
                    ForEach(Array(features.enumerated()), id: \.offset) { index, feature in
                        HStack(spacing: 16) {
                            Image(systemName: feature.0)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(iconColor)
                                .frame(width: 32)
                            
                            Text(feature.1)
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(Color(red: 0.30, green: 0.30, blue: 0.30))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
                        )
                        .opacity(showFeatures ? 1.0 : 0.0)
                        .offset(y: showFeatures ? 0 : 20)
                        .animation(.spring(response: 0.5, dampingFraction: 0.75).delay(Double(index) * 0.1 + 0.3), value: showFeatures)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.top, 32)
            }
            
            Spacer()
            
            if showDots {
                HStack(spacing: 10) {
                    ForEach(0..<5) { index in
                        Circle()
                            .fill(currentPage == index ? iconColor : Color.gray.opacity(0.3))
                            .frame(width: currentPage == index ? 10 : 8, height: currentPage == index ? 10 : 8)
                            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentPage)
                    }
                }
                .padding(.bottom, 20)
            }
            
            if isLast {
                Button(action: {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    onContinue?()
                }) {
                    HStack(spacing: 12) {
                        Text("Começar Agora")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 20, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [iconColor, iconColor.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: iconColor.opacity(0.4), radius: 16, y: 8)
                    )
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
                .accessibilityLabel("Começar a usar o app")
            } else {
                Spacer()
                    .frame(height: 100)
            }
        }
        .onAppear {
            if !features.isEmpty {
                withAnimation {
                    showFeatures = true
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(AppCoordinator())
}
