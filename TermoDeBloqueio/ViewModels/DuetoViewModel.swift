import SwiftUI
import Combine

class DuetoViewModel: ObservableObject {
    @Published var game1: SingleGameState
    @Published var game2: SingleGameState
    @Published var currentGuess: String = ""
    @Published var errorMessage: String = ""
    @Published var keyboardStatus: [String: LetterStatus] = [:]
    @Published var overallGameState: OverallGameState = .playing
    
    let maxAttempts = 7
    let wordLength = 5
    
    init() {
        let words = WordData.shared.getDuetoWords()
        game1 = SingleGameState(targetWord: words.0, maxAttempts: 7)
        game2 = SingleGameState(targetWord: words.1, maxAttempts: 7)
    }
    
    func startNewGame() {
        let words = WordData.shared.getDuetoWords()
        game1 = SingleGameState(targetWord: words.0, maxAttempts: 7)
        game2 = SingleGameState(targetWord: words.1, maxAttempts: 7)
        currentGuess = ""
        errorMessage = ""
        keyboardStatus = [:]
        overallGameState = .playing
        
        print("Dueto - Palavra 1: \(words.0), Palavra 2: \(words.1)")
    }
    
    func addLetter(_ letter: String) {
        guard overallGameState == .playing else { return }
        guard currentGuess.count < wordLength else { return }
        
        currentGuess += letter.lowercased()
        errorMessage = ""
    }
    
    func deleteLetter() {
        guard overallGameState == .playing else { return }
        guard !currentGuess.isEmpty else { return }
        
        currentGuess.removeLast()
        errorMessage = ""
    }
    
    func submitGuess() {
        guard overallGameState == .playing else { return }
        guard currentGuess.count == wordLength else {
            errorMessage = "Palavra muito curta"
            return
        }
        
        guard WordData.shared.isValidWord(currentGuess) else {
            errorMessage = "Palavra não encontrada"
            return
        }
        
        game1.addGuess(currentGuess)
        game2.addGuess(currentGuess)
        
        updateKeyboardStatus()
        checkGameOver()
        
        currentGuess = ""
        errorMessage = ""
    }
    
    private func updateKeyboardStatus() {
        var newStatus: [String: LetterStatus] = [:]
        
        for guess in game1.guesses + game2.guesses {
            for letter in guess.letters {
                let key = letter.character.uppercased()
                
                if letter.status == .correct {
                    newStatus[key] = .correct
                } else if letter.status == .misplaced && newStatus[key] != .correct {
                    newStatus[key] = .misplaced
                } else if newStatus[key] == nil {
                    newStatus[key] = .wrong
                }
            }
        }
        
        keyboardStatus = newStatus
    }
    
    private func checkGameOver() {
        let won1 = game1.isWon
        let won2 = game2.isWon
        let maxAttemptsReached = game1.guesses.count >= maxAttempts
        
        if won1 && won2 {
            overallGameState = .won
        } else if maxAttemptsReached {
            overallGameState = .lost
        }
    }
}
