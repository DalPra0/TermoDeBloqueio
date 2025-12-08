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
        GameOverModal(
            isWin: viewModel.gameState == .won,
            gameType: .termo,
            onContinue: {
                if viewModel.gameState == .won {
                    coordinator.showLockScreen()
                } else {
                    coordinator.showMenu()
                }
            },
            onRetry: {
                withAnimation {
                    viewModel.startNewGame()
                }
            }
        )
        .transition(.scale.combined(with: .opacity))
    }
}
