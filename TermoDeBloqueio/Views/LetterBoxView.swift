import SwiftUI

struct LetterBoxView: View {
    let letter: String
    let status: LetterStatus
    var size: CGFloat = 62
    
    private var fontSize: CGFloat {
        size * 0.52
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(borderColor, lineWidth: 2)
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
