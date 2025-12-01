//
//  GuessGridView.swift
//  TermoDeBloqueio
//
//  Created by Lucas Dal Pra Brascher on 01/12/25.
//

import SwiftUI

struct GuessGridView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<viewModel.maxAttempts, id: \.self) { index in
                GuessRowView(
                    letters: getLetters(for: index),
                    currentGuess: index == viewModel.guesses.count ? viewModel.currentGuess : ""
                )
            }
        }
        .padding()
    }
    
    private func getLetters(for index: Int) -> [Letter] {
        if index < viewModel.guesses.count {
            return viewModel.guesses[index].letters
        } else {
            return []
        }
    }
}

struct GuessRowView: View {
    let letters: [Letter]
    let currentGuess: String
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<5, id: \.self) { index in
                if !letters.isEmpty {
                    // Letra já submetida
                    LetterBoxView(
                        letter: letters[index].character,
                        status: letters[index].status
                    )
                } else if index < currentGuess.count {
                    // Letra sendo digitada
                    LetterBoxView(
                        letter: String(currentGuess[currentGuess.index(currentGuess.startIndex, offsetBy: index)]),
                        status: .none
                    )
                } else {
                    // Caixa vazia
                    LetterBoxView(letter: "", status: .none)
                }
            }
        }
    }
}
