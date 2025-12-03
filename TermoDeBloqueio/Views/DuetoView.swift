import SwiftUI

struct DuetoView: View {
    @StateObject private var viewModel = DuetoViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    headerView
                    
                    ScrollView {
                        HStack(spacing: 12) {
                            SingleGameGridView(
                                gameState: viewModel.game1,
                                currentGuess: viewModel.currentGuess,
                                maxAttempts: viewModel.maxAttempts,
                                availableWidth: (geometry.size.width - 12 - 16) / 2
                            )
                            
                            SingleGameGridView(
                                gameState: viewModel.game2,
                                currentGuess: viewModel.currentGuess,
                                maxAttempts: viewModel.maxAttempts,
                                availableWidth: (geometry.size.width - 12 - 16) / 2
                            )
                        }
                        .padding(.horizontal, 8)
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
    let availableWidth: CGFloat
    
    private var boxSize: CGFloat {
        let totalSpacing: CGFloat = 4 * 4
        let available = availableWidth - totalSpacing
        return min(available / 5, 40)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<maxAttempts, id: \.self) { index in
                SingleGuessRowView(
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

struct SingleGuessRowView: View {
    let letters: [Letter]
    let currentGuess: String
    let boxSize: CGFloat
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<5, id: \.self) { index in
                SmallLetterBoxView(
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

struct SmallLetterBoxView: View {
    let letter: String
    let status: LetterStatus
    var size: CGFloat = 34
    
    private var fontSize: CGFloat {
        size * 0.53
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(borderColor, lineWidth: 1.5)
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
