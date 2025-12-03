import SwiftUI
import Combine

class SingleGameState: ObservableObject {
    @Published var guesses: [Guess] = []
    let targetWord: String
    let maxAttempts: Int
    var isWon: Bool = false
    
    init(targetWord: String, maxAttempts: Int) {
        self.targetWord = targetWord
        self.maxAttempts = maxAttempts
    }
    
    func addGuess(_ guess: String) {
        let letters = evaluateGuess(guess)
        let newGuess = Guess(letters: letters)
        guesses.append(newGuess)
        
        if guess == targetWord {
            isWon = true
        }
    }
    
    private func evaluateGuess(_ guess: String) -> [Letter] {
        var letters: [Letter] = []
        var targetChars = Array(targetWord)
        var guessChars = Array(guess)
        
        for i in 0..<5 {
            if guessChars[i] == targetChars[i] {
                letters.append(Letter(character: String(guessChars[i]), status: .correct))
                targetChars[i] = "_"
                guessChars[i] = "*"
            } else {
                letters.append(Letter(character: String(guessChars[i]), status: .none))
            }
        }
        
        for i in 0..<5 {
            if guessChars[i] != "*" {
                if let index = targetChars.firstIndex(of: guessChars[i]) {
                    letters[i].status = .misplaced
                    targetChars[index] = "_"
                } else {
                    letters[i].status = .wrong
                }
            }
        }
        
        return letters
    }
}
