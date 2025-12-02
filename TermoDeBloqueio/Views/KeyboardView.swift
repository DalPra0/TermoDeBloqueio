import SwiftUI

struct KeyboardView: View {
    let currentGuess: String
    let keyboardStatus: [String: LetterStatus]
    let onLetterTap: (String) -> Void
    let onDeleteTap: () -> Void
    let onEnterTap: () -> Void
    
    let rows = [
        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
        ["ENTER", "Z", "X", "C", "V", "B", "N", "M", "⌫"]
    ]
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 6) {
                    ForEach(row, id: \.self) { key in
                        KeyButton(
                            key: key,
                            status: keyboardStatus[key] ?? .none,
                            action: {
                                handleKeyPress(key)
                            }
                        )
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    private func handleKeyPress(_ key: String) {
        switch key {
        case "ENTER":
            onEnterTap()
        case "⌫":
            onDeleteTap()
        default:
            onLetterTap(key)
        }
    }
}

extension KeyboardView {
    init(viewModel: GameViewModel) {
        self.currentGuess = viewModel.currentGuess
        self.keyboardStatus = viewModel.keyboardStatus
        self.onLetterTap = { viewModel.addLetter($0) }
        self.onDeleteTap = { viewModel.deleteLetter() }
        self.onEnterTap = { viewModel.submitGuess() }
    }
}

struct KeyButton: View {
    let key: String
    let status: LetterStatus
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(key)
                .font(.system(size: isSpecialKey ? 14 : 20, weight: .semibold))
                .foregroundColor(textColor)
                .frame(maxWidth: isSpecialKey ? 60 : .infinity)
                .frame(height: 58)
                .background(backgroundColor)
                .cornerRadius(4)
        }
    }
    
    private var isSpecialKey: Bool {
        key == "ENTER" || key == "⌫"
    }
    
    private var backgroundColor: Color {
        switch status {
        case .none:
            return Color(red: 0.82, green: 0.82, blue: 0.82)
        case .wrong:
            return Color(red: 0.47, green: 0.47, blue: 0.47)
        case .misplaced:
            return Color(red: 0.79, green: 0.67, blue: 0.18)
        case .correct:
            return Color(red: 0.42, green: 0.68, blue: 0.39)
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
