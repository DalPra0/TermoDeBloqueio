import SwiftUI

struct DuetoView: View {
    @StateObject private var viewModel = DuetoViewModel()
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var headerScale: CGFloat = 0.8
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(red: 0.97, green: 0.97, blue: 0.97)
                    .ignoresSafeArea()
                
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
                
                if viewModel.overallGameState != .playing {
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
                    .foregroundColor(Color(red: 0.85, green: 0.73, blue: 0.20))
                }
                .padding(.leading, 20)
                
                Spacer()
                
                Text("DUETO")
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
                if viewModel.overallGameState == .won {
                    Text("✓")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(Color(red: 0.85, green: 0.73, blue: 0.20))
                    
                    Text("Parabéns!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                    
                    Text("Você acertou as 2 palavras!")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                } else {
                    Text("×")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(Color(red: 0.85, green: 0.35, blue: 0.35))
                    
                    Text("Que pena!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                    
                    Text("As palavras eram:")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                    
                    HStack(spacing: 12) {
                        Text(viewModel.game1.targetWord.uppercased())
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                        
                        Text("·")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color(red: 0.70, green: 0.70, blue: 0.70))
                        
                        Text(viewModel.game2.targetWord.uppercased())
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                    }
                }
                
                Button(action: {
                    if viewModel.overallGameState == .won {
                        coordinator.showLockScreen()
                    } else {
                        withAnimation {
                            viewModel.startNewGame()
                        }
                    }
                }) {
                    Text(viewModel.overallGameState == .won ? "Continuar" : "Tentar Novamente")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 0.85, green: 0.73, blue: 0.20))
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
