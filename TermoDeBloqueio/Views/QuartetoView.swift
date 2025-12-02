import SwiftUI

struct QuartetoView: View {
    @StateObject private var viewModel = QuartetoViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 4) {
                        HStack(spacing: 4) {
                            SingleGameGridView(
                                gameState: viewModel.game1,
                                currentGuess: viewModel.currentGuess,
                                maxAttempts: viewModel.maxAttempts
                            )
                            
                            SingleGameGridView(
                                gameState: viewModel.game2,
                                currentGuess: viewModel.currentGuess,
                                maxAttempts: viewModel.maxAttempts
                            )
                        }
                        
                        HStack(spacing: 4) {
                            SingleGameGridView(
                                gameState: viewModel.game3,
                                currentGuess: viewModel.currentGuess,
                                maxAttempts: viewModel.maxAttempts
                            )
                            
                            SingleGameGridView(
                                gameState: viewModel.game4,
                                currentGuess: viewModel.currentGuess,
                                maxAttempts: viewModel.maxAttempts
                            )
                        }
                    }
                    .padding(.horizontal, 4)
                    .padding(.top, 8)
                }
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .padding(.vertical, 8)
                }
                
                KeyboardView(
                    currentGuess: viewModel.currentGuess,
                    keyboardStatus: viewModel.keyboardStatus,
                    onLetterTap: { viewModel.addLetter($0) },
                    onDeleteTap: { viewModel.deleteLetter() },
                    onEnterTap: { viewModel.submitGuess() }
                )
            }
            .background(Color.white)
            
            if viewModel.overallGameState != .playing {
                gameOverView
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 4) {
            Text("QUARTETO")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.primary)
            
            Divider()
        }
        .padding(.top)
    }
    
    private var gameOverView: some View {
        VStack(spacing: 12) {
            if viewModel.overallGameState == .won {
                Text("Parabéns!")
                    .font(.title)
                    .bold()
                Text("Você acertou as 4 palavras!")
                    .font(.title3)
            } else {
                Text("Que pena!")
                    .font(.title)
                    .bold()
                VStack(spacing: 4) {
                    Text("As palavras eram:")
                        .font(.title3)
                    Text("\(viewModel.game1.targetWord.uppercased()), \(viewModel.game2.targetWord.uppercased())")
                        .font(.subheadline)
                    Text("\(viewModel.game3.targetWord.uppercased()), \(viewModel.game4.targetWord.uppercased())")
                        .font(.subheadline)
                }
                .multilineTextAlignment(.center)
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
