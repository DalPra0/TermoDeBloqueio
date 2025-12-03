import SwiftUI

struct LockScreenView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var blockManager = BlockManager.shared
    @State private var showContent = false
    @State private var pulseAnimation = false
    
    var body: some View {
        ZStack {
            Color(red: 0.15, green: 0.15, blue: 0.15)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color(red: 0.90, green: 0.30, blue: 0.30).opacity(0.2))
                        .frame(width: pulseAnimation ? 140 : 120, height: pulseAnimation ? 140 : 120)
                        .blur(radius: 20)
                    
                    Circle()
                        .fill(Color(red: 0.25, green: 0.25, blue: 0.25))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "lock.fill")
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundColor(Color(red: 0.90, green: 0.30, blue: 0.30))
                }
                .scaleEffect(showContent ? 1.0 : 0.8)
                .opacity(showContent ? 1.0 : 0.0)
                
                VStack(spacing: 12) {
                    Text("Dispositivo Bloqueado")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(getMessage())
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color(red: 0.70, green: 0.70, blue: 0.70))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .opacity(showContent ? 1.0 : 0.0)
                
                VStack(spacing: 16) {
                    ForEach(getRequiredGames(), id: \.self) { gameType in
                        GameProgressCard(
                            gameType: gameType,
                            isCompleted: blockManager.dailyProgress.completedGames.contains(gameType)
                        )
                    }
                }
                .padding(.horizontal, 32)
                .opacity(showContent ? 1.0 : 0.0)
                
                VStack(spacing: 16) {
                    ForEach(getRequiredGames(), id: \.self) { gameType in
                        GameProgressCard(
                            gameType: gameType,
                            isCompleted: blockManager.dailyProgress.completedGames.contains(gameType)
                        )
                    }
                }
                .padding(.horizontal, 32)
                .opacity(showContent ? 1.0 : 0.0)
                
                Spacer()
                
                Button(action: {
                    let nextGame = getNextIncompleteGame()
                    if let game = nextGame {
                        navigateToGame(game)
                    }
                }) {
                    Text("Resolver Desafio")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(red: 0.40, green: 0.71, blue: 0.38))
                                .shadow(color: Color(red: 0.40, green: 0.71, blue: 0.38).opacity(0.4), radius: 12, y: 6)
                        )
                }
                .padding(.horizontal, 32)
                
                Button(action: {
                    coordinator.showSettings()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Configurações")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(Color(red: 0.70, green: 0.70, blue: 0.70))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
                .opacity(showContent ? 1.0 : 0.0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showContent = true
            }
            
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                pulseAnimation = true
            }
        }
    }
    
    private func getMessage() -> String {
        let remaining = getRemainingGames()
        if remaining.isEmpty {
            return "Você já completou todos os desafios!"
        } else if remaining.count == 1 {
            return "Complete o desafio para desbloquear"
        } else {
            return "Complete os desafios para desbloquear"
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
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 24))
                .foregroundColor(isCompleted ? Color(red: 0.40, green: 0.71, blue: 0.38) : Color(red: 0.50, green: 0.50, blue: 0.50))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(Color(red: 0.60, green: 0.60, blue: 0.60))
            }
            
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 0.22, green: 0.22, blue: 0.22))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isCompleted ? Color(red: 0.40, green: 0.71, blue: 0.38).opacity(0.3) : Color.clear, lineWidth: 1.5)
                )
        )
    }
}

#Preview {
    LockScreenView()
        .environmentObject(AppCoordinator())
}
