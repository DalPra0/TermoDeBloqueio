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
                .id("\(index)-\(viewModel.currentGuess)")
            }
        }
        .padding(.horizontal)
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
                LetterBoxView(
                    letter: getLetter(at: index),
                    status: getStatus(at: index)
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
