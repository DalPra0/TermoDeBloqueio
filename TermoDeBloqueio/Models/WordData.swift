//
//  WordData.swift
//  TermoDeBloqueio
//
//  Created by Lucas Dal Pra Brascher on 01/12/25.
//

import Foundation

struct WordList: Codable {
    let metadados: Metadados
    let palavras: [String]
    
    struct Metadados: Codable {
        let total: Int
        let fonte: String
    }
}

class WordData {
    static let shared = WordData()
    
    private var allWords: [String] = []
    
    private init() {
        loadWords()
    }
    
    private func loadWords() {
        guard let url = Bundle.main.url(forResource: "palavras_termo_completo", withExtension: "json") else {
            print("❌ Não encontrou o arquivo JSON")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let wordList = try JSONDecoder().decode(WordList.self, from: data)
            
            // Remove acentos e caracteres especiais, mantém apenas letras normais
            allWords = wordList.palavras
                .map { removeAccents($0) }
                .filter { $0.count == 5 && $0.allSatisfy { $0.isLetter } }
            
            print("✅ Carregou \(allWords.count) palavras")
        } catch {
            print("❌ Erro ao carregar palavras: \(error)")
        }
    }
    
    private func removeAccents(_ string: String) -> String {
        return string
            .folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()
    }
    
    // Palavra do dia baseada na data
    func getDailyWord() -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let referenceDate = calendar.date(from: DateComponents(year: 2024, month: 1, day: 1))!
        let daysSinceReference = calendar.dateComponents([.day], from: referenceDate, to: today).day ?? 0
        
        let index = abs(daysSinceReference) % allWords.count
        return allWords[index]
    }
    
    // Valida se a palavra existe na lista
    func isValidWord(_ word: String) -> Bool {
        return allWords.contains(word.lowercased())
    }
}
