import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var currentPage = 0
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.97, blue: 0.97)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                TabView(selection: $currentPage) {
                    WelcomePage(
                        icon: "gamecontroller.fill",
                        iconColor: Color(red: 0.40, green: 0.71, blue: 0.38),
                        title: "Bem-vindo ao Termo de Bloqueio",
                        subtitle: "O app que te ajuda a usar menos o celular jogando Termo!",
                        showDots: true,
                        currentPage: $currentPage
                    )
                    .tag(0)
                    
                    WelcomePage(
                        icon: "lock.shield.fill",
                        iconColor: Color(red: 0.85, green: 0.73, blue: 0.20),
                        title: "Bloqueie Apps Distrativos",
                        subtitle: "Selecione apps como Instagram, TikTok e Twitter que você quer bloquear",
                        showDots: true,
                        currentPage: $currentPage
                    )
                    .tag(1)
                    
                    WelcomePage(
                        icon: "brain.head.profile",
                        iconColor: Color(red: 0.90, green: 0.30, blue: 0.30),
                        title: "Resolva Termos Diários",
                        subtitle: "Todo dia você precisa resolver Termos para desbloquear seus apps",
                        showDots: true,
                        currentPage: $currentPage
                    )
                    .tag(2)
                    
                    WelcomePage(
                        icon: "checkmark.circle.fill",
                        iconColor: Color(red: 0.40, green: 0.71, blue: 0.38),
                        title: "Escolha sua Dificuldade",
                        subtitle: "Fácil, Médio ou Difícil - quanto mais difícil, mais Termos você resolve!",
                        showDots: true,
                        currentPage: $currentPage,
                        isLast: true,
                        onContinue: {
                            coordinator.dismissWelcome()
                        }
                    )
                    .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 500)
                
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
    let showDots: Bool
    @Binding var currentPage: Int
    var isLast: Bool = false
    var onContinue: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 32) {
            Image(systemName: icon)
                .font(.system(size: 80, weight: .semibold))
                .foregroundColor(iconColor)
                .padding(.top, 40)
            
            VStack(spacing: 16) {
                Text(title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Text(subtitle)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .lineSpacing(4)
            }
            
            Spacer()
            
            if showDots {
                HStack(spacing: 8) {
                    ForEach(0..<4) { index in
                        Circle()
                            .fill(currentPage == index ? iconColor : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                    }
                }
                .padding(.bottom, 16)
            }
            
            if isLast {
                Button(action: {
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    onContinue?()
                }) {
                    Text("Começar!")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(iconColor)
                                .shadow(color: iconColor.opacity(0.4), radius: 12, y: 6)
                        )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            } else {
                Color.clear
                    .frame(height: 80)
            }
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(AppCoordinator())
}
