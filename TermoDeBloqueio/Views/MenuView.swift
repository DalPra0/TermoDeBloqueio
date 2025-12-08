import SwiftUI
import Combine

struct MenuView: View {
    @State private var showContent = false
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var blockManager = BlockManager.shared
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.96, green: 0.96, blue: 0.97), Color(red: 0.92, green: 0.92, blue: 0.94)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 36) {
                HStack(alignment: .center) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(blockManager.isBlocked ? Color.red : Color(red: 0.40, green: 0.71, blue: 0.38))
                            .frame(width: 10, height: 10)
                        
                        Text(blockManager.isBlocked ? "Bloqueado" : "Desbloqueado")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(red: 0.30, green: 0.30, blue: 0.30))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
                    )
                    
                    Spacer()
                    
                    Button(action: { 
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                        coordinator.showSettings() 
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(Color(red: 0.45, green: 0.45, blue: 0.45))
                            .frame(width: 44, height: 44)
                            .background(
                                Circle()
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
                            )
                    }
                    .accessibilityLabel("Configurações")
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .opacity(showContent ? 1.0 : 0.0)
                
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 0.40, green: 0.71, blue: 0.38), Color(red: 0.50, green: 0.81, blue: 0.48)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                            .shadow(color: Color(red: 0.40, green: 0.71, blue: 0.38).opacity(0.3), radius: 16, y: 8)
                        
                        Text("T")
                            .font(.system(size: 40, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .scaleEffect(showContent ? 1.0 : 0.5)
                    .rotation3DEffect(.degrees(showContent ? 0 : 180), axis: (x: 0, y: 1, z: 0))
                    
                    Text("TERMO")
                        .font(.system(size: 44, weight: .black, design: .rounded))
                        .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                        .scaleEffect(showContent ? 1.0 : 0.8)
                        .opacity(showContent ? 1.0 : 0.0)
                    
                    Text("DE BLOQUEIO")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                        .opacity(showContent ? 1.0 : 0.0)
                    
                    if blockManager.isBlocked {
                        let total = blockManager.currentDifficulty.gamesRequired.count
                        let completed = blockManager.dailyProgress.completedGames.count
                        
                        HStack(spacing: 6) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color(red: 0.85, green: 0.73, blue: 0.20))
                            
                            Text("\(completed)/\(total) jogos completos")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundColor(Color(red: 0.40, green: 0.40, blue: 0.40))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                        )
                        .padding(.top, 8)
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                
                VStack(spacing: 16) {
                    ForEach([GameType.termo, GameType.dueto, GameType.quarteto], id: \.self) { gameType in
                        let requiredGames = blockManager.currentDifficulty.gamesRequired
                        let isRequired = requiredGames.contains(gameType)
                        let isCompleted = blockManager.dailyProgress.completedGames.contains(gameType)
                        
                        Button(action: { 
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                            navigateToGame(gameType) 
                        }) {
                            MenuButton(
                                gameType: gameType,
                                isRequired: isRequired,
                                isCompleted: isCompleted,
                                delay: delayForGame(gameType)
                            )
                        }
                        .disabled(isCompleted)
                        .accessibilityLabel(accessibilityLabel(for: gameType, isRequired: isRequired, isCompleted: isCompleted))
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
            .onAppear {
                withAnimation(.spring(response: 0.7, dampingFraction: 0.75)) {
                    showContent = true
                }
            }
        }
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
    
    private func delayForGame(_ gameType: GameType) -> Double {
        switch gameType {
        case .termo: return 0.1
        case .dueto: return 0.2
        case .quarteto: return 0.3
        }
    }
    
    private func accessibilityLabel(for gameType: GameType, isRequired: Bool, isCompleted: Bool) -> String {
        let name = gameType == .termo ? "Termo" : (gameType == .dueto ? "Dueto" : "Quarteto")
        var label = name
        if isCompleted {
            label += " - Completado hoje"
        } else if isRequired {
            label += " - Obrigatório"
        } else {
            label += " - Opcional"
        }
        return label
    }
}

struct MenuButton: View {
    let gameType: GameType
    let isRequired: Bool
    let isCompleted: Bool
    let delay: Double
    
    @State private var isPressed = false
    @State private var showButton = false
    
    var title: String {
        switch gameType {
        case .termo:
            return "TERMO"
        case .dueto:
            return "DUETO"
        case .quarteto:
            return "QUARTETO"
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
    
    var badge: some View {
        Group {
            if isCompleted {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 14, weight: .bold))
                    Text("COMPLETO")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color(red: 0.40, green: 0.71, blue: 0.38))
                )
            } else if isRequired {
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 12, weight: .bold))
                    Text("OBRIGATÓRIO")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                }
                .foregroundColor(color)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(color.opacity(0.15))
                        .overlay(
                            Capsule()
                                .stroke(color.opacity(0.3), lineWidth: 1)
                        )
                )
            } else {
                HStack(spacing: 4) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 11, weight: .semibold))
                    Text("OPCIONAL")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                }
                .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(Color(red: 0.90, green: 0.90, blue: 0.90))
                )
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
                
                badge
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    isCompleted 
                        ? Color(red: 0.30, green: 0.30, blue: 0.30)
                        : color
                )
                .shadow(
                    color: isCompleted ? .clear : color.opacity(0.3), 
                    radius: isPressed ? 4 : 12, 
                    y: isPressed ? 2 : 6
                )
        )
        .opacity(isCompleted ? 0.6 : 1.0)
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .offset(y: showButton ? 0 : 20)
        .opacity(showButton ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75).delay(delay)) {
                showButton = true
            }
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isCompleted {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            isPressed = true
                        }
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                }
        )
    }
}

#Preview {
    MenuView()
        .environmentObject(AppCoordinator())
}
