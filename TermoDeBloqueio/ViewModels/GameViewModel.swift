import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published var guesses: [Guess] = []
    @Published var currentGuess: String = ""
    @Published var gameState: GameState = .playing
    @Published var errorMessage: String = ""
    @Published var keyboardStatus: [String: LetterStatus] = [:]
    
    let maxAttempts = 6
    let wordLength = 5
    private var targetWord: String = ""
    
    init() {
        startNewGame()
    }
    
    func startNewGame() {
        targetWord = WordData.shared.getDailyWord()
        guesses = []
        currentGuess = ""
        gameState = .playing
        errorMessage = ""
        keyboardStatus = [:]
        
        print("Palavra do dia: \(targetWord)")
    }
    
    func addLetter(_ letter: String) {
        guard gameState == .playing else { return }
        guard currentGuess.count < wordLength else { return }
        
        currentGuess += letter.lowercased()
        errorMessage = ""
    }
    
    func deleteLetter() {
        guard gameState == .playing else { return }
        guard !currentGuess.isEmpty else { return }
        
        currentGuess.removeLast()
        errorMessage = ""
    }
    
    func submitGuess() {
        guard gameState == .playing else { return }
        guard currentGuess.count == wordLength else {
            errorMessage = "Palavra muito curta"
            return
        }
        
        guard WordData.shared.isValidWord(currentGuess) else {
            errorMessage = "Palavra não encontrada"
            return
        }
        
        let letters = evaluateGuess(currentGuess)
        let guess = Guess(letters: letters)
        guesses.append(guess)
        
        updateKeyboardStatus(letters)
        
        if currentGuess == targetWord {
            gameState = .won
        } else if guesses.count >= maxAttempts {
            gameState = .lost
        }
        
        currentGuess = ""
        errorMessage = ""
    }
    
    private func evaluateGuess(_ guess: String) -> [Letter] {
        var letters: [Letter] = []
        var targetChars = Array(targetWord)
        var guessChars = Array(guess)
        
        for i in 0..<wordLength {
            if guessChars[i] == targetChars[i] {
                letters.append(Letter(character: String(guessChars[i]), status: .correct))
                targetChars[i] = "_"
                guessChars[i] = "*"
            } else {
                letters.append(Letter(character: String(guessChars[i]), status: .none))
            }
        }
        
        for i in 0..<wordLength {
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
    
    private func updateKeyboardStatus(_ letters: [Letter]) {
        for letter in letters {
            let key = letter.character.uppercased()
            
            if letter.status == .correct {
                keyboardStatus[key] = .correct
            } else if letter.status == .misplaced && keyboardStatus[key] != .correct {
                keyboardStatus[key] = .misplaced
            } else if keyboardStatus[key] == nil {
                keyboardStatus[key] = .wrong
            }
        }
    }
}
