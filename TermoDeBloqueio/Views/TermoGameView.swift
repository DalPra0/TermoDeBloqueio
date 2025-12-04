import SwiftUI

struct TermoGameView: View {
    @StateObject private var viewModel = GameViewModel()
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var headerScale: CGFloat = 0.8
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(red: 0.97, green: 0.97, blue: 0.97)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    Spacer()
                    
                    GuessGridView(viewModel: viewModel, availableWidth: geometry.size.width)
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .padding(.vertical, 8)
                    }
                    
                    Spacer()
                    
                    KeyboardView(viewModel: viewModel)
                }
                
                if viewModel.gameState != .playing {
                    gameOverView
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 4) {
            HStack {
                Button(action: {
                    coordinator.showLockScreen()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Voltar")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(Color(red: 0.40, green: 0.71, blue: 0.38))
                }
                .padding(.leading, 20)
                
                Spacer()
                
                Text("TERMO")
                    .font(.system(size: 28, weight: .black))
                    .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                    .scaleEffect(headerScale)
                
                Spacer()
                
                Color.clear
                    .frame(width: 80)
            }
            .padding(.vertical, 12)
            
            Divider()
                .background(Color.gray.opacity(0.3))
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                headerScale = 1.0
            }
        }
    }
    
    private var gameOverView: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .transition(.opacity)
            
            VStack(spacing: 16) {
                if viewModel.gameState == .won {
                    Text("✓")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(Color(red: 0.40, green: 0.71, blue: 0.38))
                    
                    Text("Parabéns!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                    
                    Text("Você acertou!")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                } else {
                    Text("×")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(Color(red: 0.85, green: 0.35, blue: 0.35))
                    
                    Text("Que pena!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                    
                    Text("A palavra era:")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                    
                    Text(WordData.shared.getDailyWord().uppercased())
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                }
                
                Button(action: {
                    if viewModel.gameState == .won {
                        coordinator.showLockScreen()
                    } else {
                        withAnimation {
                            viewModel.startNewGame()
                        }
                    }
                }) {
                    Text(viewModel.gameState == .won ? "Continuar" : "Tentar Novamente")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 0.40, green: 0.71, blue: 0.38))
                        )
                }
                .padding(.top, 8)
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 20, y: 10)
            )
            .padding(.horizontal, 32)
            .transition(.scale.combined(with: .opacity))
        }
    }
}
