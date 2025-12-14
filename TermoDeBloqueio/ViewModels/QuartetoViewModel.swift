import SwiftUI
import Combine
import UIKit

class QuartetoViewModel: ObservableObject {
    @Published var game1: SingleGameState
    @Published var game2: SingleGameState
    @Published var game3: SingleGameState
    @Published var game4: SingleGameState
    @Published var currentGuess: String = ""
    @Published var errorMessage: String = ""
    @Published var keyboardStatus: [String: LetterStatus] = [:]
    @Published var overallGameState: OverallGameState = .playing
    
    private let blockManager = BlockManager.shared
    
    let maxAttempts = 9
    let wordLength = 5
    
    init() {
        let words = WordData.shared.getQuartetoWords()
        game1 = SingleGameState(targetWord: words.0, maxAttempts: 9)
        game2 = SingleGameState(targetWord: words.1, maxAttempts: 9)
        game3 = SingleGameState(targetWord: words.2, maxAttempts: 9)
        game4 = SingleGameState(targetWord: words.3, maxAttempts: 9)
    }
    
    func startNewGame() {
        let words = WordData.shared.getQuartetoWords()
        game1 = SingleGameState(targetWord: words.0, maxAttempts: 9)
        game2 = SingleGameState(targetWord: words.1, maxAttempts: 9)
        game3 = SingleGameState(targetWord: words.2, maxAttempts: 9)
        game4 = SingleGameState(targetWord: words.3, maxAttempts: 9)
        currentGuess = ""
        errorMessage = ""
        keyboardStatus = [:]
        overallGameState = .playing
        
        print("Quarteto - Palavras: \(words.0), \(words.1), \(words.2), \(words.3)")
    }
    
    func addLetter(_ letter: String) {
        guard overallGameState == .playing else { return }
        guard currentGuess.count < wordLength else { return }
        
        currentGuess += letter.lowercased()
        errorMessage = ""
        triggerHaptic(.light)
    }
    
    func deleteLetter() {
        guard overallGameState == .playing else { return }
        guard !currentGuess.isEmpty else { return }
        
        currentGuess.removeLast()
        errorMessage = ""
        triggerHaptic(.light)
    }
    
    func submitGuess() {
        guard overallGameState == .playing else { return }
        guard currentGuess.count == wordLength else {
            errorMessage = "Palavra muito curta"
            triggerHaptic(.error)
            return
        }
        
        guard WordData.shared.isValidWord(currentGuess) else {
            errorMessage = "Palavra não encontrada"
            triggerHaptic(.error)
            return
        }
        
        game1.addGuess(currentGuess)
        game2.addGuess(currentGuess)
        game3.addGuess(currentGuess)
        game4.addGuess(currentGuess)
        
        updateKeyboardStatus()
        checkGameOver()
        
        currentGuess = ""
        errorMessage = ""
    }
    
    private func updateKeyboardStatus() {
        var newStatus: [String: LetterStatus] = [:]
        
        for guess in game1.guesses + game2.guesses + game3.guesses + game4.guesses {
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
        let allWon = game1.isWon && game2.isWon && game3.isWon && game4.isWon
        let maxAttemptsReached = game1.guesses.count >= maxAttempts
        
        if allWon {
            overallGameState = .won
            blockManager.markGameCompleted(.quarteto)
            triggerHaptic(.success)
            print("✅ QUARTETO COMPLETADO!")
            print("   Progresso: \(blockManager.dailyProgress.completedGames.count)/\(blockManager.currentDifficulty.gamesRequired.count)")
        } else if maxAttemptsReached {
            overallGameState = .lost
            triggerHaptic(.error)
            print("Quarteto falhou")
        } else {
            triggerHaptic(.medium)
        }
    }
    
    private func triggerHaptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    private func triggerHaptic(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}
