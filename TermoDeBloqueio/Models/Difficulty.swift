import Foundation

enum Difficulty: String, Codable, CaseIterable {
    case easy = "Fácil"
    case medium = "Médio"
    case hard = "Difícil"
    
    var description: String {
        switch self {
        case .easy:
            return "Termo (1 palavra)"
        case .medium:
            return "Termo + Dueto (3 palavras)"
        case .hard:
            return "Termo + Dueto + Quarteto (7 palavras)"
        }
    }
    
    var gamesRequired: [GameType] {
        switch self {
        case .easy:
            return [.termo]
        case .medium:
            return [.termo, .dueto]
        case .hard:
            return [.termo, .dueto, .quarteto]
        }
    }
}

enum GameType: String, Codable {
    case termo
    case dueto
    case quarteto
}
