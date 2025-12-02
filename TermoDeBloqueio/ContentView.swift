import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerView
                
                Spacer()
                
                GuessGridView(viewModel: viewModel)
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .padding(.vertical, 8)
                }
                
                Spacer()
                
                KeyboardView(viewModel: viewModel)
            }
            .background(Color.white)
            
            if viewModel.gameState != .playing {
                gameOverView
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 4) {
            Text("TERMO")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.primary)
            
            Divider()
        }
        .padding(.top)
    }
    
    private var gameOverView: some View {
        VStack(spacing: 12) {
            if viewModel.gameState == .won {
                Text("Parabéns!")
                    .font(.title)
                    .bold()
                Text("Você acertou!")
                    .font(.title3)
            } else {
                Text("Que pena!")
                    .font(.title)
                    .bold()
                Text("A palavra era: \(WordData.shared.getDailyWord().uppercased())")
                    .font(.title3)
            }
            
            Button(action: {
                viewModel.startNewGame()
            }) {
                Text("Jogar Novamente")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemBackground))
                .shadow(radius: 10)
        )
        .padding()
    }
}

#Preview {
    ContentView()
}
