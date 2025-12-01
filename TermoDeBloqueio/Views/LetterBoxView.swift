//
//  LetterBoxView.swift
//  TermoDeBloqueio
//
//  Created by Lucas Dal Pra Brascher on 01/12/25.
//

import SwiftUI

struct LetterBoxView: View {
    let letter: String
    let status: LetterStatus
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(borderColor, lineWidth: 2)
                )
            
            Text(letter.uppercased())
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(textColor)
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    private var backgroundColor: Color {
        switch status {
        case .none:
            return Color.clear
        case .wrong:
            return Color(red: 0.47, green: 0.47, blue: 0.47) // Cinza
        case .misplaced:
            return Color(red: 0.79, green: 0.67, blue: 0.18) // Amarelo
        case .correct:
            return Color(red: 0.42, green: 0.68, blue: 0.39) // Verde
        }
    }
    
    private var borderColor: Color {
        switch status {
        case .none:
            return letter.isEmpty ? Color.gray.opacity(0.3) : Color.gray
        default:
            return Color.clear
        }
    }
    
    private var textColor: Color {
        switch status {
        case .none:
            return .primary
        default:
            return .white
        }
    }
}
