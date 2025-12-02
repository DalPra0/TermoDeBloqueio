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
    
    func getDuetoWords() -> (String, String) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let referenceDate = calendar.date(from: DateComponents(year: 2024, month: 1, day: 1))!
        let daysSinceReference = calendar.dateComponents([.day], from: referenceDate, to: today).day ?? 0
        
        var word1 = ""
        var word2 = ""
        var randomGenerator = SeededRandomGenerator(seed: UInt64(daysSinceReference * 2))
        
        for _ in 0..<100 {
            let index = Int(randomGenerator.next() % UInt64(allWords.count))
            let candidate = allWords[index]
            
            if word1.isEmpty {
                if isWordSuitableForPlay(candidate, previousWord: "") {
                    word1 = candidate
                }
            } else if !areTooSimilar(candidate, word1) && isWordSuitableForPlay(candidate, previousWord: "") {
                word2 = candidate
                break
            }
        }
        
        if word2.isEmpty {
            word2 = allWords[Int.random(in: 0..<allWords.count)]
        }
        
        return (word1, word2)
    }
    
    func getQuartetoWords() -> (String, String, String, String) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let referenceDate = calendar.date(from: DateComponents(year: 2024, month: 1, day: 1))!
        let daysSinceReference = calendar.dateComponents([.day], from: referenceDate, to: today).day ?? 0
        
        var words: [String] = []
        var randomGenerator = SeededRandomGenerator(seed: UInt64(daysSinceReference * 4))
        
        var attempts = 0
        while words.count < 4 && attempts < 200 {
            let index = Int(randomGenerator.next() % UInt64(allWords.count))
            let candidate = allWords[index]
            
            var isValid = isWordSuitableForPlay(candidate, previousWord: "")
            
            for existingWord in words {
                if areTooSimilar(candidate, existingWord) {
                    isValid = false
                    break
                }
            }
            
            if isValid {
                words.append(candidate)
            }
            
            attempts += 1
        }
        
        while words.count < 4 {
            words.append(allWords[Int.random(in: 0..<allWords.count)])
        }
        
        return (words[0], words[1], words[2], words[3])
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
