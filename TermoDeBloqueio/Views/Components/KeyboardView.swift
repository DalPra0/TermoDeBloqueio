import SwiftUI
import Foundation

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
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
            action()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }) {
            Text(key)
                .font(.system(size: isSpecialKey ? 15 : 22, weight: .bold, design: .rounded))
                .foregroundColor(textColor)
                .frame(maxWidth: isSpecialKey ? 70 : .infinity)
                .frame(height: 56)
                .background(backgroundColor)
                .cornerRadius(8)
                .shadow(color: backgroundColor.opacity(0.3), radius: isPressed ? 1 : 4, y: isPressed ? 0 : 2)
        }
        .scaleEffect(isPressed ? 0.94 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(isSpecialKey ? "Botão especial" : "Letra \(key)")
    }
    
    private var isSpecialKey: Bool {
        key == "ENTER" || key == "⌫"
    }
    
    private var accessibilityLabel: String {
        if key == "ENTER" {
            return "Enviar palavra"
        } else if key == "⌫" {
            return "Apagar letra"
        } else {
            return key
        }
    }
    
    private var backgroundColor: Color {
        switch status {
        case .none:
            return Color(red: 0.85, green: 0.85, blue: 0.85)
        case .wrong:
            return Color(red: 0.45, green: 0.45, blue: 0.45)
        case .misplaced:
            return Color(red: 0.85, green: 0.73, blue: 0.20)
        case .correct:
            return Color(red: 0.40, green: 0.71, blue: 0.38)
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
