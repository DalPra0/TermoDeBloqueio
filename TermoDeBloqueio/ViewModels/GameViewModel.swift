//
//  GameViewModel.swift
//  TermoDeBloqueio
//
//  Created by Lucas Dal Pra Brascher on 01/12/25.
//

import SwiftUI
import Combine

enum LetterStatus {
    case none      // Cinza - letra não existe
    case wrong     // Cinza - letra não existe
    case misplaced // Amarelo - letra existe mas posição errada
    case correct   // Verde - letra correta na posição certa
}

struct Letter: Identifiable {
    let id = UUID()
    var character: String
    var status: LetterStatus
}

struct Guess: Identifiable {
    let id = UUID()
    var letters: [Letter]
}

class GameViewModel: ObservableObject {
    @Published var guesses: [Guess] = []
    @Published var currentGuess: String = ""
    @Published var gameState: GameState = .playing
    @Published var errorMessage: String = ""
    @Published var keyboardStatus: [String: LetterStatus] = [:]
    
    let maxAttempts = 6
    let wordLength = 5
    private var targetWord: String = ""
    
    enum GameState {
        case playing
        case won
        case lost
    }
    
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
        
        print("🎯 Palavra do dia: \(targetWord)")
    }
    
    func addLetter(_ letter: String) {
        guard gameState == .playing else { return }
        guard currentGuess.count < wordLength else { return }
        
        currentGuess += letter.lowercased()
        errorMessage = ""
        print("📝 Letra adicionada: \(letter), currentGuess agora: '\(currentGuess)'")
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
        
        // Valida se a palavra existe
        guard WordData.shared.isValidWord(currentGuess) else {
            errorMessage = "Palavra não encontrada"
            return
        }
        
        // Cria o guess com status de cada letra
        let letters = evaluateGuess(currentGuess)
        let guess = Guess(letters: letters)
        guesses.append(guess)
        
        // Atualiza status do teclado
        updateKeyboardStatus(letters)
        
        // Verifica se ganhou
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
        
        // Primeira passada: marca letras corretas (verdes)
        for i in 0..<wordLength {
            if guessChars[i] == targetChars[i] {
                letters.append(Letter(character: String(guessChars[i]), status: .correct))
                targetChars[i] = "_" // Marca como usada
                guessChars[i] = "*" // Marca como processada
            } else {
                letters.append(Letter(character: String(guessChars[i]), status: .none))
            }
        }
        
        // Segunda passada: marca letras existentes mas mal posicionadas (amarelas)
        for i in 0..<wordLength {
            if guessChars[i] != "*" { // Se não foi processada ainda
                if let index = targetChars.firstIndex(of: guessChars[i]) {
                    letters[i].status = .misplaced
                    targetChars[index] = "_" // Marca como usada
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
            
            // Prioridade: correct > misplaced > wrong
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
