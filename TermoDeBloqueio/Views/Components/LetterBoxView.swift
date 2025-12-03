import SwiftUI
import Foundation

struct LetterBoxView: View {
    let letter: String
    let status: LetterStatus
    var size: CGFloat = 62
    
    @State private var scale: CGFloat = 1.0
    @State private var hasAnimated = false
    
    private var fontSize: CGFloat {
        size * 0.52
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .strokeBorder(borderColor, lineWidth: 2)
                )
            
            if !letter.isEmpty {
                Text(letter.uppercased())
                    .font(.system(size: fontSize, weight: .bold))
                    .foregroundColor(textColor)
            }
        }
        .frame(width: size, height: size)
        .scaleEffect(scale)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: scale)
        .onChange(of: letter) { oldValue, newValue in
            if !newValue.isEmpty && oldValue.isEmpty {
                scale = 1.1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    scale = 1.0
                }
            }
        }
        .onChange(of: status) { oldValue, newValue in
            if newValue != .none && !hasAnimated {
                hasAnimated = true
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    scale = 1.05
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        scale = 1.0
                    }
                }
            }
        }
    }
    
    private var backgroundColor: Color {
        switch status {
        case .none:
            return Color.white
        case .wrong:
            return Color(red: 0.45, green: 0.45, blue: 0.45)
        case .misplaced:
            return Color(red: 0.85, green: 0.73, blue: 0.20)
        case .correct:
            return Color(red: 0.40, green: 0.71, blue: 0.38)
        }
    }
    
    private var borderColor: Color {
        switch status {
        case .none:
            return letter.isEmpty ? Color.gray.opacity(0.25) : Color(red: 0.53, green: 0.53, blue: 0.53)
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
