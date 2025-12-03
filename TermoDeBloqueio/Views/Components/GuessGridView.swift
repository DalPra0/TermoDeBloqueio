import SwiftUI
import Foundation

struct GuessGridView: View {
    @ObservedObject var viewModel: GameViewModel
    let availableWidth: CGFloat
    
    private var boxSize: CGFloat {
        let totalSpacing: CGFloat = 4 * 8
        let horizontalPadding: CGFloat = 32
        let available = availableWidth - totalSpacing - horizontalPadding
        return min(available / 5, 62)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<viewModel.maxAttempts, id: \.self) { index in
                GuessRowView(
                    letters: getLetters(for: index),
                    currentGuess: index == viewModel.guesses.count ? viewModel.currentGuess : "",
                    boxSize: boxSize
                )
                .id("\(index)-\(viewModel.currentGuess)")
            }
        }
        .padding(.horizontal, 16)
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
    let boxSize: CGFloat
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<5, id: \.self) { index in
                LetterBoxView(
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
