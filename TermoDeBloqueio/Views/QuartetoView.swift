import SwiftUI

struct TinyLetterBoxView: View {
    let letter: String
    let status: LetterStatus
    var size: CGFloat = 22
    
    private var fontSize: CGFloat {
        size * 0.48
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
        HStack(spacing: 2) {
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
        let totalSpacing: CGFloat = 4 * 2
        let available = availableWidth - totalSpacing
        return min(available / 5, 22)
    }
    
    var body: some View {
        VStack(spacing: 2) {
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
                Color(red: 0.97, green: 0.97, blue: 0.97)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Text("QUARTETO")
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                        .padding(.vertical, 2)
                    
                    ScrollView {
                        VStack(spacing: 14) {
                            HStack(spacing: 14) {
                                QuartetoGameGridView(
                                    gameState: viewModel.game1,
                                    currentGuess: viewModel.currentGuess,
                                    maxAttempts: viewModel.maxAttempts,
                                    availableWidth: (geometry.size.width - 14 - 12) / 2
                                )
                                
                                QuartetoGameGridView(
                                    gameState: viewModel.game2,
                                    currentGuess: viewModel.currentGuess,
                                    maxAttempts: viewModel.maxAttempts,
                                    availableWidth: (geometry.size.width - 14 - 12) / 2
                                )
                            }
                            
                            HStack(spacing: 14) {
                                QuartetoGameGridView(
                                    gameState: viewModel.game3,
                                    currentGuess: viewModel.currentGuess,
                                    maxAttempts: viewModel.maxAttempts,
                                    availableWidth: (geometry.size.width - 14 - 12) / 2
                                )
                                
                                QuartetoGameGridView(
                                    gameState: viewModel.game4,
                                    currentGuess: viewModel.currentGuess,
                                    maxAttempts: viewModel.maxAttempts,
                                    availableWidth: (geometry.size.width - 14 - 12) / 2
                                )
                            }
                        }
                        .padding(.horizontal, 6)
                        .padding(.bottom, 4)
                    }
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .font(.caption2)
                            .foregroundColor(.red)
                            .padding(.vertical, 2)
                    }
                    
                    KeyboardView(
                        currentGuess: viewModel.currentGuess,
                        keyboardStatus: viewModel.keyboardStatus,
                        onLetterTap: { viewModel.addLetter($0) },
                        onDeleteTap: { viewModel.deleteLetter() },
                        onEnterTap: { viewModel.submitGuess() }
                    )
                }
                
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
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .transition(.opacity)
            
            VStack(spacing: 16) {
                if viewModel.overallGameState == .won {
                    Text("✓")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(Color(red: 0.45, green: 0.45, blue: 0.45))
                    
                    Text("Parabéns!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                    
                    Text("Você acertou as 4 palavras!")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                } else {
                    Text("×")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(Color(red: 0.85, green: 0.35, blue: 0.35))
                    
                    Text("Que pena!")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                    
                    Text("As palavras eram:")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                    
                    VStack(spacing: 8) {
                        HStack(spacing: 10) {
                            Text(viewModel.game1.targetWord.uppercased())
                                .font(.system(size: 18, weight: .bold))
                            Text("·")
                                .font(.system(size: 18))
                                .foregroundColor(Color(red: 0.70, green: 0.70, blue: 0.70))
                            Text(viewModel.game2.targetWord.uppercased())
                                .font(.system(size: 18, weight: .bold))
                        }
                        HStack(spacing: 10) {
                            Text(viewModel.game3.targetWord.uppercased())
                                .font(.system(size: 18, weight: .bold))
                            Text("·")
                                .font(.system(size: 18))
                                .foregroundColor(Color(red: 0.70, green: 0.70, blue: 0.70))
                            Text(viewModel.game4.targetWord.uppercased())
                                .font(.system(size: 18, weight: .bold))
                        }
                    }
                    .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                }
                
                Button(action: {
                    withAnimation {
                        viewModel.startNewGame()
                    }
                }) {
                    Text("Jogar Novamente")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 0.45, green: 0.45, blue: 0.45))
                        )
                }
                .padding(.top, 8)
            }
            .padding(28)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 20, y: 10)
            )
            .padding(.horizontal, 24)
            .transition(.scale.combined(with: .opacity))
        }
    }
}
