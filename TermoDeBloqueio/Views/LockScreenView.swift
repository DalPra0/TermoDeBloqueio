import SwiftUI

struct LockScreenView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var blockManager = BlockManager.shared
    @State private var showContent = false
    @State private var pulseAnimation = false
    @State private var showCelebration = false
    @State private var progressBarWidth: CGFloat = 0
    
    private var progressPercentage: CGFloat {
        let total = getRequiredGames().count
        guard total > 0 else { return 1.0 }
        let completed = total - getRemainingGames().count
        return CGFloat(completed) / CGFloat(total)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: blockManager.isBlocked 
                    ? [Color(red: 0.10, green: 0.10, blue: 0.10), Color(red: 0.18, green: 0.18, blue: 0.18)]
                    : [Color(red: 0.35, green: 0.66, blue: 0.33), Color(red: 0.45, green: 0.76, blue: 0.43)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.6), value: blockManager.isBlocked)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 32) {
                    Spacer()
                        .frame(height: 40)
                    
                    ZStack {
                        if blockManager.isBlocked {
                            Circle()
                                .fill(Color(red: 0.90, green: 0.30, blue: 0.30).opacity(pulseAnimation ? 0.3 : 0.1))
                                .frame(width: 160, height: 160)
                                .blur(radius: 30)
                            
                            Circle()
                                .fill(Color(red: 0.25, green: 0.25, blue: 0.25))
                                .frame(width: 120, height: 120)
                                .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
                            
                            Image(systemName: "lock.fill")
                                .font(.system(size: 50, weight: .semibold))
                                .foregroundColor(Color(red: 0.90, green: 0.30, blue: 0.30))
                        } else {
                            Circle()
                                .fill(Color.white.opacity(showCelebration ? 0.4 : 0.2))
                                .frame(width: showCelebration ? 180 : 120, height: showCelebration ? 180 : 120)
                                .blur(radius: 30)
                            
                            Circle()
                                .fill(Color.white)
                                .frame(width: 120, height: 120)
                                .shadow(color: .black.opacity(0.2), radius: 20, y: 10)
                            
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 60, weight: .bold))
                                .foregroundColor(Color(red: 0.35, green: 0.66, blue: 0.33))
                                .rotationEffect(.degrees(showCelebration ? 720 : 0))
                                .scaleEffect(showCelebration ? 1.1 : 1.0)
                        }
                    }
                    .scaleEffect(showContent ? 1.0 : 0.5)
                    .opacity(showContent ? 1.0 : 0.0)
                    
                    VStack(spacing: 16) {
                        Text(blockManager.isBlocked ? "Dispositivo Bloqueado" : "Apps Desbloqueados!")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        if blockManager.isBlocked {
                            HStack(spacing: 8) {
                                Image(systemName: getDifficultyIcon())
                                    .font(.system(size: 14, weight: .semibold))
                                Text("Dificuldade: \(blockManager.currentDifficulty.displayName)")
                                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.15))
                            )
                        }
                        
                        Text(getMessage())
                            .font(.system(size: 17, weight: .regular, design: .rounded))
                            .foregroundColor(blockManager.isBlocked 
                                ? Color(red: 0.75, green: 0.75, blue: 0.75)
                                : Color.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .lineSpacing(4)
                        
                        if blockManager.isBlocked {
                            VStack(spacing: 12) {
                                GeometryReader { geometry in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white.opacity(0.2))
                                            .frame(height: 24)
                                        
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color(red: 0.40, green: 0.71, blue: 0.38), Color(red: 0.50, green: 0.81, blue: 0.48)],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .frame(width: progressBarWidth, height: 24)
                                            .shadow(color: Color(red: 0.40, green: 0.71, blue: 0.38).opacity(0.5), radius: 8, y: 4)
                                            .onAppear {
                                                withAnimation(.spring(response: 1.0, dampingFraction: 0.7).delay(0.3)) {
                                                    progressBarWidth = geometry.size.width * progressPercentage
                                                }
                                            }
                                    }
                                }
                                .frame(height: 24)
                                .padding(.horizontal, 40)
                                
                                let remaining = getRemainingGames().count
                                let total = getRequiredGames().count
                                let completed = total - remaining
                                
                                HStack(spacing: 12) {
                                    ForEach(0..<total, id: \.self) { index in
                                        Circle()
                                            .fill(index < completed 
                                                ? Color(red: 0.40, green: 0.71, blue: 0.38)
                                                : Color.white.opacity(0.3))
                                            .frame(width: 12, height: 12)
                                            .scaleEffect(index < completed ? 1.0 : 0.8)
                                            .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(Double(index) * 0.1), value: completed)
                                    }
                                }
                                .padding(.top, 4)
                                
                                Text("\(completed)/\(total) jogos completados")
                                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                                    .foregroundColor(Color(red: 0.70, green: 0.70, blue: 0.70))
                            }
                            .padding(.top, 8)
                        }
                    }
                    .opacity(showContent ? 1.0 : 0.0)
                    
                    VStack(spacing: 16) {
                        ForEach(getRequiredGames(), id: \.self) { gameType in
                            GameProgressCard(
                                gameType: gameType,
                                isCompleted: blockManager.dailyProgress.completedGames.contains(gameType),
                                isNext: gameType == getNextIncompleteGame()
                            )
                            .onTapGesture {
                                if !blockManager.dailyProgress.completedGames.contains(gameType) {
                                    let generator = UIImpactFeedbackGenerator(style: .medium)
                                    generator.impactOccurred()
                                    navigateToGame(gameType)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    .opacity(showContent ? 1.0 : 0.0)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    VStack(spacing: 16) {
                        if blockManager.isBlocked {
                            Button(action: {
                                let generator = UIImpactFeedbackGenerator(style: .heavy)
                                generator.impactOccurred()
                                
                                let nextGame = getNextIncompleteGame()
                                if let game = nextGame {
                                    navigateToGame(game)
                                }
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "gamecontroller.fill")
                                        .font(.system(size: 20, weight: .bold))
                                    Text("Jogar Agora")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color(red: 0.40, green: 0.71, blue: 0.38), Color(red: 0.50, green: 0.81, blue: 0.48)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .shadow(color: Color(red: 0.40, green: 0.71, blue: 0.38).opacity(0.4), radius: 16, y: 8)
                                )
                            }
                            .scaleEffect(pulseAnimation ? 1.02 : 1.0)
                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: pulseAnimation)
                            .accessibilityLabel("Jogar próximo desafio")
                            .accessibilityHint("Abre o próximo jogo que você precisa completar")
                        } else {
                            Button(action: {
                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.success)
                                coordinator.showMenu()
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 20, weight: .bold))
                                    Text("Ir para Menu")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                }
                                .foregroundColor(Color(red: 0.35, green: 0.66, blue: 0.33))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white)
                                        .shadow(color: .black.opacity(0.15), radius: 16, y: 8)
                                )
                            }
                            .accessibilityLabel("Ir para menu principal")
                        }
                        
                        Button(action: {
                            let generator = UIImpactFeedbackGenerator(style: .light)
                            generator.impactOccurred()
                            coordinator.showSettings()
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Configurações")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(blockManager.isBlocked 
                                ? Color(red: 0.75, green: 0.75, blue: 0.75)
                                : Color.white.opacity(0.85))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.white.opacity(0.1))
                            )
                        }
                        .accessibilityLabel("Abrir configurações")
                    }
                    .padding(.horizontal, 24)
                    .opacity(showContent ? 1.0 : 0.0)
                    
                    Spacer()
                        .frame(height: 40)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showContent = true
            }
            
            if blockManager.isBlocked {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    pulseAnimation = true
                }
            } else {
                withAnimation(.spring(response: 1.2, dampingFraction: 0.5)) {
                    showCelebration = true
                }
                
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let gen = UIImpactFeedbackGenerator(style: .medium)
                    gen.impactOccurred()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let gen = UIImpactFeedbackGenerator(style: .heavy)
                    gen.impactOccurred()
                }
            }
        }
        .onChange(of: blockManager.isBlocked) {
            if !blockManager.isBlocked {
                withAnimation(.spring(response: 1.2, dampingFraction: 0.5)) {
                    showCelebration = true
                }
                
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
        }
    }
    
    private func getDifficultyIcon() -> String {
        switch blockManager.currentDifficulty {
        case .easy:
            return "leaf.fill"
        case .medium:
            return "flame.fill"
        case .hard:
            return "bolt.fill"
        }
    }
    
    private func getMessage() -> String {
        let remaining = getRemainingGames()
        
        if remaining.isEmpty {
            return "Parabéns! Você completou todos os desafios de hoje!"
        } else if remaining.count == 1 {
            let nextGame = getNextIncompleteGame()
            let gameName = nextGame == .termo ? "Termo" : (nextGame == .dueto ? "Dueto" : "Quarteto")
            return "Falta apenas 1 jogo para desbloquear seus apps:\n\(gameName)"
        } else {
            return "Complete \(remaining.count) jogos para desbloquear seus apps"
        }
    }
    
    private func getRequiredGames() -> [GameType] {
        blockManager.currentDifficulty.gamesRequired
    }
    
    private func getRemainingGames() -> [GameType] {
        getRequiredGames().filter { !blockManager.dailyProgress.completedGames.contains($0) }
    }
    
    private func navigateToGame(_ gameType: GameType) {
        switch gameType {
        case .termo:
            coordinator.showTermo()
        case .dueto:
            coordinator.showDueto()
        case .quarteto:
            coordinator.showQuarteto()
        }
    }
    
    private func getNextIncompleteGame() -> GameType? {
        getRequiredGames().first { !blockManager.dailyProgress.completedGames.contains($0) }
    }
}

struct GameProgressCard: View {
    let gameType: GameType
    let isCompleted: Bool
    let isNext: Bool
    
    var title: String {
        switch gameType {
        case .termo:
            return "Termo"
        case .dueto:
            return "Dueto"
        case .quarteto:
            return "Quarteto"
        }
    }
    
    var subtitle: String {
        switch gameType {
        case .termo:
            return "1 palavra · 6 tentativas"
        case .dueto:
            return "2 palavras · 7 tentativas"
        case .quarteto:
            return "4 palavras · 9 tentativas"
        }
    }
    
    var icon: String {
        switch gameType {
        case .termo:
            return "a.square.fill"
        case .dueto:
            return "square.split.2x1.fill"
        case .quarteto:
            return "square.grid.2x2.fill"
        }
    }
    
    var color: Color {
        switch gameType {
        case .termo:
            return Color(red: 0.40, green: 0.71, blue: 0.38)
        case .dueto:
            return Color(red: 0.85, green: 0.73, blue: 0.20)
        case .quarteto:
            return Color(red: 0.35, green: 0.65, blue: 0.85)
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(isCompleted ? color : Color(red: 0.30, green: 0.30, blue: 0.30))
                    .frame(width: 52, height: 52)
                
                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                } else {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(red: 0.60, green: 0.60, blue: 0.60))
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    if isNext && !isCompleted {
                        Text("PRÓXIMO")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(color)
                            )
                    }
                }
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(Color(red: 0.70, green: 0.70, blue: 0.70))
            }
            
            Spacer()
            
            if !isCompleted {
                Image(systemName: isNext ? "arrow.right.circle.fill" : "lock.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(isNext ? color : Color(red: 0.50, green: 0.50, blue: 0.50))
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.20, green: 0.20, blue: 0.20))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            isCompleted 
                                ? color.opacity(0.6) 
                                : (isNext ? color.opacity(0.4) : Color.clear), 
                            lineWidth: 2
                        )
                )
                .shadow(
                    color: isCompleted ? color.opacity(0.3) : .clear, 
                    radius: 12, 
                    y: 6
                )
        )
        .scaleEffect(isNext && !isCompleted ? 1.02 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isNext)
        .accessibilityLabel("\(title): \(subtitle)")
        .accessibilityValue(isCompleted ? "Completado" : (isNext ? "Próximo desafio" : "Bloqueado"))
    }
}

#Preview {
    LockScreenView()
        .environmentObject(AppCoordinator())
}
