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
                            Text("Dificuldade do Bloqueio")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(red: 0.30, green: 0.30, blue: 0.30))
                            
                            VStack(spacing: 12) {
                                ForEach(Difficulty.allCases, id: \.self) { difficulty in
                                    DifficultyButton(
                                        difficulty: difficulty,
                                        isSelected: blockManager.currentDifficulty == difficulty,
                                        action: {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                blockManager.setDifficulty(difficulty)
                                            }
                                        }
                                    )
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
                            Text("Progresso Hoje")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(red: 0.30, green: 0.30, blue: 0.30))
                            
                            VStack(spacing: 12) {
                                ProgressRow(title: "Termo", isCompleted: blockManager.dailyProgress.completedGames.contains(.termo))
                                
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
                                
                                Text(blockManager.isBlocked ? "🔒 Bloqueado" : "✅ Desbloqueado")
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
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(isSelected ? color : Color(red: 0.85, green: 0.85, blue: 0.85), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(color)
                            .frame(width: 14, height: 14)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(difficulty.rawValue)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                    
                    Text(difficulty.description)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                }
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? color.opacity(0.1) : Color(red: 0.98, green: 0.98, blue: 0.98))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? color.opacity(0.3) : Color.clear, lineWidth: 1.5)
                    )
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
