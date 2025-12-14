import Foundation

enum Difficulty: String, Codable, CaseIterable {
    case easy = "Fácil"
    case medium = "Médio"
    case hard = "Difícil"
    
    var displayName: String {
        return self.rawValue
    }
    
    var description: String {
        switch self {
        case .easy:
            return "Palavrada (1 palavra)"
        case .medium:
            return "Palavrada + Dueto (3 palavras)"
        case .hard:
            return "Palavrada + Dueto + Quarteto (7 palavras)"
        }
    }
    
    var gamesRequired: [GameType] {
        switch self {
        case .easy:
            return [.palavrada]
        case .medium:
            return [.palavrada, .dueto]
        case .hard:
            return [.palavrada, .dueto, .quarteto]
        }
    }
}

enum GameType: String, Codable, Equatable {
    case palavrada
    case dueto
    case quarteto
}
