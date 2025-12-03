import SwiftUI

struct TinyLetterBoxView: View {
    let letter: String
    let status: LetterStatus
    var size: CGFloat = 24
    
    private var fontSize: CGFloat {
        size * 0.5
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(borderColor, lineWidth: 1)
                )
            
            if !letter.isEmpty {
                Text(letter.uppercased())
                    .font(.system(size: fontSize, weight: .bold))
                    .foregroundColor(textColor)
            }
        }
        .frame(width: size, height: size)
    }
    
    private var backgroundColor: Color {
        switch status {
        case .none:
            return Color.white
        case .wrong:
            return Color(red: 0.47, green: 0.47, blue: 0.47)
        case .misplaced:
            return Color(red: 0.79, green: 0.67, blue: 0.18)
        case .correct:
            return Color(red: 0.42, green: 0.68, blue: 0.39)
        }
    }
    
    private var borderColor: Color {
        switch status {
        case .none:
            return letter.isEmpty ? Color.gray.opacity(0.3) : Color.gray.opacity(0.7)
        default:
            return Color.clear
        }
    }
    
    private var textColor: Color {
        switch status {
        case .none:
            return .black
        default:
            return .white
        }
    }
}

struct QuartetoGuessRowView: View {
    let letters: [Letter]
    let currentGuess: String
    let boxSize: CGFloat
    
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<5, id: \.self) { index in
                TinyLetterBoxView(
                    letter: getLetter(at: index),
                    status: getStatus(at: index),
                    size: boxSize
                )
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

struct QuartetoGameGridView: View {
    @ObservedObject var gameState: SingleGameState
    let currentGuess: String
    let maxAttempts: Int
    let availableWidth: CGFloat
    
    private var boxSize: CGFloat {
        let totalSpacing: CGFloat = 4 * 3
        let available = availableWidth - totalSpacing
        return min(available / 5, 28)
    }
    
    var body: some View {
        VStack(spacing: 3) {
            ForEach(0..<maxAttempts, id: \.self) { index in
                QuartetoGuessRowView(
                    letters: getLetters(for: index),
                    currentGuess: index == gameState.guesses.count ? currentGuess : "",
                    boxSize: boxSize
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

struct QuartetoView: View {
    @StateObject private var viewModel = QuartetoViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    Text("QUARTETO")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                        .padding(.top, 8)
                    
                    ScrollView {
                        VStack(spacing: 8) {
                            HStack(spacing: 8) {
                                QuartetoGameGridView(
                                    gameState: viewModel.game1,
                                    currentGuess: viewModel.currentGuess,
                                    maxAttempts: viewModel.maxAttempts,
                                    availableWidth: (geometry.size.width - 8 - 16) / 2
                                )
                                
                                QuartetoGameGridView(
                                    gameState: viewModel.game2,
                                    currentGuess: viewModel.currentGuess,
                                    maxAttempts: viewModel.maxAttempts,
                                    availableWidth: (geometry.size.width - 8 - 16) / 2
                                )
                            }
                            
                            HStack(spacing: 8) {
                                QuartetoGameGridView(
                                    gameState: viewModel.game3,
                                    currentGuess: viewModel.currentGuess,
                                    maxAttempts: viewModel.maxAttempts,
                                    availableWidth: (geometry.size.width - 8 - 16) / 2
                                )
                                
                                QuartetoGameGridView(
                                    gameState: viewModel.game4,
                                    currentGuess: viewModel.currentGuess,
                                    maxAttempts: viewModel.maxAttempts,
                                    availableWidth: (geometry.size.width - 8 - 16) / 2
                                )
                            }
                        }
                        .padding(.horizontal, 8)
                        .padding(.top, 4)
                    }
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.vertical, 4)
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
    }
    
    private var headerView: some View {
        VStack(spacing: 4) {
            Text("QUARTETO")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
            
            Divider()
        }
        .padding(.top, 8)
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
