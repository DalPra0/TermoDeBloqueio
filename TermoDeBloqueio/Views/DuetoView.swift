import SwiftUI

struct DuetoView: View {
    @StateObject private var viewModel = DuetoViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    HStack(spacing: 12) {
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
                    .padding()
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
            Text("DUETO")
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
                Text("Você acertou as 2 palavras!")
                    .font(.title3)
            } else {
                Text("Que pena!")
                    .font(.title)
                    .bold()
                Text("As palavras eram: \(viewModel.game1.targetWord.uppercased()) e \(viewModel.game2.targetWord.uppercased())")
                    .font(.title3)
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

struct SingleGameGridView: View {
    @ObservedObject var gameState: SingleGameState
    let currentGuess: String
    let maxAttempts: Int
    
    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<maxAttempts, id: \.self) { index in
                SingleGuessRowView(
                    letters: getLetters(for: index),
                    currentGuess: index == gameState.guesses.count ? currentGuess : ""
                )
            }
        }
    }
    
    private func getLetters(for index: Int) -> [Letter] {
        if index < gameState.guesses.count {
            return gameState.guesses[index].letters
        } else {
            return []
        }
    }
}

struct SingleGuessRowView: View {
    let letters: [Letter]
    let currentGuess: String
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<5, id: \.self) { index in
                LetterBoxView(
                    letter: getLetter(at: index),
                    status: getStatus(at: index)
                )
                .frame(width: 40, height: 40)
            }
        }
    }
    
    private func getLetter(at index: Int) -> String {
        if !letters.isEmpty {
            return letters[index].character
        } else if index < currentGuess.count {
            let stringIndex = currentGuess.index(currentGuess.startIndex, offsetBy: index)
            return String(currentGuess[stringIndex])
        } else {
            return ""
        }
    }
    
    private func getStatus(at index: Int) -> LetterStatus {
        if !letters.isEmpty {
            return letters[index].status
        } else {
            return .none
        }
    }
}
