import SwiftUI

struct GameOverModal: View {
    let isWin: Bool
    let gameType: GameType
    let onContinue: () -> Void
    let onRetry: () -> Void
    
    @StateObject private var blockManager = BlockManager.shared
    @State private var showContent = false
    @State private var showConfetti = false
    
    private var totalRequired: Int {
        blockManager.currentDifficulty.gamesRequired.count
    }
    
    private var completedCount: Int {
        blockManager.dailyProgress.completedGames.count
    }
    
    private var allCompleted: Bool {
        completedCount == totalRequired
    }
    
    private var progressPercentage: CGFloat {
        guard totalRequired > 0 else { return 0 }
        return CGFloat(completedCount) / CGFloat(totalRequired)
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                }
            
            VStack(spacing: 0) {
                VStack(spacing: 24) {
                    ZStack {
                        if isWin {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(red: 0.40, green: 0.71, blue: 0.38), Color(red: 0.50, green: 0.81, blue: 0.48)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)
                                .scaleEffect(showConfetti ? 1.1 : 1.0)
                                .shadow(color: Color(red: 0.40, green: 0.71, blue: 0.38).opacity(0.4), radius: 20, y: 10)
                            
                            Image(systemName: allCompleted ? "star.fill" : "checkmark")
                                .font(.system(size: 50, weight: .bold))
                                .foregroundColor(.white)
                                .rotationEffect(.degrees(showConfetti ? 360 : 0))
                        } else {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color(red: 0.90, green: 0.30, blue: 0.30), Color(red: 0.95, green: 0.40, blue: 0.40)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)
                                .shadow(color: Color(red: 0.90, green: 0.30, blue: 0.30).opacity(0.4), radius: 20, y: 10)
                            
                            Image(systemName: "xmark")
                                .font(.system(size: 50, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .scaleEffect(showContent ? 1.0 : 0.5)
                    .opacity(showContent ? 1.0 : 0.0)
                    
                    VStack(spacing: 8) {
                        Text(isWin ? (allCompleted ? "INCRÍVEL!" : "PARABÉNS!") : "QUASE LÁ!")
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                        
                        Text(getMessage())
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .padding(.horizontal, 20)
                    }
                    .opacity(showContent ? 1.0 : 0.0)
                    
                    if isWin {
                        VStack(spacing: 16) {
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(red: 0.92, green: 0.92, blue: 0.92))
                                        .frame(height: 16)
                                    
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color(red: 0.40, green: 0.71, blue: 0.38), Color(red: 0.50, green: 0.81, blue: 0.48)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(width: geometry.size.width * progressPercentage, height: 16)
                                        .shadow(color: Color(red: 0.40, green: 0.71, blue: 0.38).opacity(0.3), radius: 4, y: 2)
                                }
                            }
                            .frame(height: 16)
                            
                            HStack(spacing: 20) {
                                VStack(spacing: 4) {
                                    Text("\(completedCount)/\(totalRequired)")
                                        .font(.system(size: 24, weight: .bold, design: .rounded))
                                        .foregroundColor(Color(red: 0.40, green: 0.71, blue: 0.38))
                                    
                                    Text("Jogos Completos")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .foregroundColor(Color(red: 0.60, green: 0.60, blue: 0.60))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(red: 0.40, green: 0.71, blue: 0.38).opacity(0.1))
                                )
                                
                                VStack(spacing: 4) {
                                    Image(systemName: allCompleted ? "lock.open.fill" : "lock.fill")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(allCompleted ? Color(red: 0.40, green: 0.71, blue: 0.38) : Color(red: 0.85, green: 0.73, blue: 0.20))
                                    
                                    Text(allCompleted ? "Desbloqueado" : "Bloqueado")
                                        .font(.system(size: 12, weight: .medium, design: .rounded))
                                        .foregroundColor(Color(red: 0.60, green: 0.60, blue: 0.60))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            allCompleted 
                                                ? Color(red: 0.40, green: 0.71, blue: 0.38).opacity(0.1)
                                                : Color(red: 0.85, green: 0.73, blue: 0.20).opacity(0.1)
                                        )
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                        .opacity(showContent ? 1.0 : 0.0)
                    }
                    
                    VStack(spacing: 12) {
                        Button(action: {
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.success)
                            onContinue()
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: isWin ? (allCompleted ? "checkmark.circle.fill" : "arrow.right.circle.fill") : "arrow.clockwise.circle.fill")
                                    .font(.system(size: 18, weight: .bold))
                                Text(isWin ? (allCompleted ? "Ver Apps" : "Continuar") : "Tentar Novamente")
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(
                                        isWin 
                                            ? LinearGradient(
                                                colors: [Color(red: 0.40, green: 0.71, blue: 0.38), Color(red: 0.50, green: 0.81, blue: 0.48)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                            : LinearGradient(
                                                colors: [Color(red: 0.90, green: 0.30, blue: 0.30), Color(red: 0.95, green: 0.40, blue: 0.40)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                    )
                                    .shadow(
                                        color: (isWin ? Color(red: 0.40, green: 0.71, blue: 0.38) : Color(red: 0.90, green: 0.30, blue: 0.30)).opacity(0.4), 
                                        radius: 12, 
                                        y: 6
                                    )
                            )
                        }
                        .accessibilityLabel(isWin ? "Continuar" : "Tentar novamente")
                        
                        if !isWin {
                            Button(action: {
                                let generator = UIImpactFeedbackGenerator(style: .light)
                                generator.impactOccurred()
                                onContinue()
                            }) {
                                Text("Voltar ao Menu")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                            }
                            .accessibilityLabel("Voltar ao menu principal")
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    .opacity(showContent ? 1.0 : 0.0)
                }
                .padding(.vertical, 36)
                .padding(.horizontal, 24)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.2), radius: 30, y: 15)
                )
                .padding(.horizontal, 32)
            }
            .scaleEffect(showContent ? 1.0 : 0.8)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
                showContent = true
            }
            
            if isWin {
                withAnimation(.spring(response: 1.2, dampingFraction: 0.5).delay(0.2)) {
                    showConfetti = true
                }
                
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let gen = UIImpactFeedbackGenerator(style: .medium)
                    gen.impactOccurred()
                }
            }
        }
    }
    
    private func getMessage() -> String {
        if isWin {
            if allCompleted {
                return "Você completou todos os desafios de hoje!\nSeus apps foram desbloqueados! 🎉"
            } else {
                let remaining = totalRequired - completedCount
                if remaining == 1 {
                    return "Ótimo! Falta apenas 1 jogo para desbloquear seus apps."
                } else {
                    return "Muito bem! Faltam \(remaining) jogos para desbloquear seus apps."
                }
            }
        } else {
            return "Suas tentativas acabaram, mas não desista!\nTente novamente para alcançar a vitória."
        }
    }
}

#Preview("Vitória - Parcial") {
    GameOverModal(
        isWin: true,
        gameType: .palavrada,
        onContinue: {},
        onRetry: {}
    )
}

#Preview("Vitória - Completo") {
    GameOverModal(
        isWin: true,
        gameType: .quarteto,
        onContinue: {},
        onRetry: {}
    )
}

#Preview("Derrota") {
    GameOverModal(
        isWin: false,
        gameType: .palavrada,
        onContinue: {},
        onRetry: {}
    )
}
