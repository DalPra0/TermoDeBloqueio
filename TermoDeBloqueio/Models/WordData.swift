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
            print("Não encontrou o arquivo JSON")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let wordList = try JSONDecoder().decode(WordList.self, from: data)
            
            allWords = wordList.palavras
                .map { removeAccents($0) }
                .filter { $0.count == 5 && $0.allSatisfy { $0.isLetter } }
            
            print("Carregou \(allWords.count) palavras")
        } catch {
            print("Erro ao carregar palavras: \(error)")
        }
    }
    
    private func removeAccents(_ string: String) -> String {
        return string
            .folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()
    }
    
    func getDailyWord() -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let referenceDate = calendar.date(from: DateComponents(year: 2024, month: 1, day: 1))!
        let daysSinceReference = calendar.dateComponents([.day], from: referenceDate, to: today).day ?? 0
        
        var randomGenerator = SeededRandomGenerator(seed: UInt64(daysSinceReference))
        
        var attempts = 0
        var candidateWord = ""
        var previousWord = ""
        
        repeat {
            let randomIndex = Int(randomGenerator.next() % UInt64(allWords.count))
            candidateWord = allWords[randomIndex]
            
            if attempts > 0 {
                let prevSeed = UInt64(daysSinceReference - 1)
                var prevGenerator = SeededRandomGenerator(seed: prevSeed)
                let prevIndex = Int(prevGenerator.next() % UInt64(allWords.count))
                previousWord = allWords[prevIndex]
            }
            
            attempts += 1
            
        } while attempts < 100 && !isWordSuitableForPlay(candidateWord, previousWord: previousWord)
        
        return candidateWord
    }
    
    private func isWordSuitableForPlay(_ word: String, previousWord: String) -> Bool {
        if word.count != 5 { return false }
        
        if !previousWord.isEmpty && areTooSimilar(word, previousWord) {
            return false
        }
        
        let uniqueLetters = Set(word).count
        if uniqueLetters < 3 {
            return false
        }
        
        return true
    }
    
    private func areTooSimilar(_ word1: String, _ word2: String) -> Bool {
        let chars1 = Array(word1)
        let chars2 = Array(word2)
        
        var matchingPositions = 0
        for i in 0..<min(chars1.count, chars2.count) {
            if chars1[i] == chars2[i] {
                matchingPositions += 1
            }
        }
        
        if matchingPositions >= 3 {
            return true
        }
        
        let set1 = Set(chars1)
        let set2 = Set(chars2)
        let commonLetters = set1.intersection(set2).count
        
        if commonLetters >= 4 {
            return true
        }
        
        return false
    }
    
    func isValidWord(_ word: String) -> Bool {
        return allWords.contains(word.lowercased())
    }
}

struct SeededRandomGenerator {
    private var state: UInt64
    
    init(seed: UInt64) {
        state = seed &+ 1
    }
    
    mutating func next() -> UInt64 {
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return state
    }
}
