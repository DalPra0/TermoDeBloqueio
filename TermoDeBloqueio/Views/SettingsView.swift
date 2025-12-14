import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var blockManager = BlockManager.shared
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.97, blue: 0.97)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: { coordinator.showMenu() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                            .frame(width: 44, height: 44)
                    }
                    
                    Spacer()
                    
                    Text("CONFIGURAÇÕES")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                    
                    Spacer()
                    
                    Color.clear
                        .frame(width: 44, height: 44)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .opacity(showContent ? 1.0 : 0.0)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Dificuldade do Bloqueio")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color(red: 0.30, green: 0.30, blue: 0.30))
                                
                                Spacer()
                                
                                if !blockManager.canChangeDifficulty {
                                    HStack(spacing: 4) {
                                        Image(systemName: "lock.fill")
                                            .font(.system(size: 11, weight: .semibold))
                                        Text("Bloqueado")
                                            .font(.system(size: 12, weight: .semibold))
                                    }
                                    .foregroundColor(Color(red: 0.90, green: 0.30, blue: 0.30))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(
                                        Capsule()
                                            .fill(Color(red: 0.90, green: 0.30, blue: 0.30).opacity(0.15))
                                    )
                                }
                            }
                            
                            if !blockManager.canChangeDifficulty {
                                Text("Você já começou a jogar hoje. A dificuldade não pode ser alterada.")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(Color(red: 0.60, green: 0.60, blue: 0.60))
                                    .lineLimit(2)
                            }
                            
                            VStack(spacing: 12) {
                                ForEach(Difficulty.allCases, id: \.self) { difficulty in
                                    DifficultyButton(
                                        difficulty: difficulty,
                                        isSelected: blockManager.currentDifficulty == difficulty,
                                        action: {
                                            guard blockManager.canChangeDifficulty else {
                                                let generator = UIImpactFeedbackGenerator(style: .rigid)
                                                generator.impactOccurred()
                                                return
                                            }
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                blockManager.setDifficulty(difficulty)
                                            }
                                        }
                                    )
                                    .opacity(blockManager.canChangeDifficulty ? 1.0 : 0.6)
                                }
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
                        )
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Apps Bloqueados")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(red: 0.30, green: 0.30, blue: 0.30))
                            
                            Button(action: {
                                coordinator.showAppSelection()
                            }) {
                                HStack {
                                    Image(systemName: "app.badge.fill")
                                        .font(.system(size: 18, weight: .semibold))
                                    
                                    Text("Selecionar Apps")
                                        .font(.system(size: 15, weight: .semibold))
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(Color(red: 0.70, green: 0.70, blue: 0.70))
                                }
                                .foregroundColor(.white)
                                .padding(.vertical, 16)
                                .padding(.horizontal, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(red: 0.40, green: 0.71, blue: 0.38))
                                )
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
                        )
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Progresso Hoje")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(red: 0.30, green: 0.30, blue: 0.30))
                            
                            VStack(spacing: 12) {
                                ProgressRow(title: "Palavrada", isCompleted: blockManager.dailyProgress.completedGames.contains(.palavrada))
                                
                                if blockManager.currentDifficulty == .medium || blockManager.currentDifficulty == .hard {
                                    ProgressRow(title: "Dueto", isCompleted: blockManager.dailyProgress.completedGames.contains(.dueto))
                                }
                                
                                if blockManager.currentDifficulty == .hard {
                                    ProgressRow(title: "Quarteto", isCompleted: blockManager.dailyProgress.completedGames.contains(.quarteto))
                                }
                            }
                            
                            Divider()
                                .padding(.vertical, 4)
                            
                            HStack {
                                Text("Status")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color(red: 0.40, green: 0.40, blue: 0.40))
                                
                                Spacer()
                                
                                Text(blockManager.isBlocked ? "Bloqueado" : "Desbloqueado")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(blockManager.isBlocked ? Color(red: 0.90, green: 0.30, blue: 0.30) : Color(red: 0.40, green: 0.71, blue: 0.38))
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
                        )
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Debug")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(red: 0.30, green: 0.30, blue: 0.30))
                            
                            Button(action: {
                                blockManager.toggleDebugBlock()
                            }) {
                                HStack {
                                    Image(systemName: blockManager.isDebugBlocked ? "lock.fill" : "lock.open.fill")
                                        .font(.system(size: 18, weight: .semibold))
                                    
                                    Text(blockManager.isDebugBlocked ? "Desbloquear Apps (Debug)" : "Bloquear Apps (Debug)")
                                        .font(.system(size: 15, weight: .semibold))
                                    
                                    Spacer()
                                }
                                .foregroundColor(.white)
                                .padding(.vertical, 16)
                                .padding(.horizontal, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(blockManager.isDebugBlocked ? Color(red: 0.90, green: 0.30, blue: 0.30) : Color(red: 0.40, green: 0.71, blue: 0.38))
                                )
                            }
                            
                            Button(action: {
                                blockManager.resetProgress()
                            }) {
                                HStack {
                                    Image(systemName: "arrow.counterclockwise")
                                        .font(.system(size: 18, weight: .semibold))
                                    
                                    Text("Resetar Progresso do Dia")
                                        .font(.system(size: 15, weight: .semibold))
                                    
                                    Spacer()
                                }
                                .foregroundColor(.white)
                                .padding(.vertical, 16)
                                .padding(.horizontal, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(red: 0.45, green: 0.45, blue: 0.45))
                                )
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
                        )
                    }
                    .padding(24)
                }
                .opacity(showContent ? 1.0 : 0.0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                showContent = true
            }
        }
    }
}

struct DifficultyButton: View {
    let difficulty: Difficulty
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var color: Color {
        switch difficulty {
        case .easy:
            return Color(red: 0.40, green: 0.71, blue: 0.38)
        case .medium:
            return Color(red: 0.85, green: 0.73, blue: 0.20)
        case .hard:
            return Color(red: 0.90, green: 0.30, blue: 0.30)
        }
    }
    
    var icon: String {
        switch difficulty {
        case .easy:
            return "leaf.fill"
        case .medium:
            return "flame.fill"
        case .hard:
            return "bolt.fill"
        }
    }
    
    var detailedDescription: String {
        switch difficulty {
        case .easy:
            return "Apenas 1 Palavrada por dia"
        case .medium:
            return "Palavrada + Dueto (3 palavras total)"
        case .hard:
            return "Palavrada + Dueto + Quarteto (7 palavras!)"
        }
    }
    
    var body: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            action()
        }) {
            VStack(spacing: 12) {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(isSelected ? color : Color(red: 0.92, green: 0.92, blue: 0.92))
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: icon)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(isSelected ? .white : Color(red: 0.60, green: 0.60, blue: 0.60))
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            Text(difficulty.rawValue)
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                            
                            if isSelected {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(color)
                            }
                        }
                        
                        Text(detailedDescription)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                        
                        Text(difficulty.description)
                            .font(.system(size: 13, weight: .regular, design: .rounded))
                            .foregroundColor(Color(red: 0.60, green: 0.60, blue: 0.60))
                    }
                    
                    Spacer()
                }
                
                HStack(spacing: 8) {
                    ForEach(difficulty.gamesRequired, id: \.self) { game in
                        HStack(spacing: 4) {
                            Image(systemName: gameIcon(for: game))
                                .font(.system(size: 11, weight: .semibold))
                            Text(gameName(for: game))
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                        }
                        .foregroundColor(isSelected ? color : Color(red: 0.60, green: 0.60, blue: 0.60))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(isSelected ? color.opacity(0.15) : Color(red: 0.95, green: 0.95, blue: 0.95))
                        )
                    }
                }
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? color.opacity(0.08) : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(isSelected ? color.opacity(0.5) : Color(red: 0.92, green: 0.92, blue: 0.92), lineWidth: 2)
                    )
                    .shadow(color: isSelected ? color.opacity(0.2) : .clear, radius: 8, y: 4)
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                }
        )
        .accessibilityLabel("\(difficulty.rawValue) - \(detailedDescription)")
        .accessibilityValue(isSelected ? "Selecionado" : "Não selecionado")
    }
    
    private func gameIcon(for gameType: GameType) -> String {
        switch gameType {
        case .palavrada:
            return "a.square.fill"
        case .dueto:
            return "square.split.2x1.fill"
        case .quarteto:
            return "square.grid.2x2.fill"
        }
    }
    
    private func gameName(for gameType: GameType) -> String {
        switch gameType {
        case .palavrada:
            return "Palavrada"
        case .dueto:
            return "Dueto"
        case .quarteto:
            return "Quarteto"
        }
    }
}

struct ProgressRow: View {
    let title: String
    let isCompleted: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 20))
                .foregroundColor(isCompleted ? Color(red: 0.40, green: 0.71, blue: 0.38) : Color(red: 0.85, green: 0.85, blue: 0.85))
            
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color(red: 0.40, green: 0.40, blue: 0.40))
            
            Spacer()
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppCoordinator())
}
