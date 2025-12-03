import Foundation

struct DailyProgress: Codable {
    var date: String
    var difficulty: Difficulty
    var completedGames: Set<GameType>
    
    var isUnlocked: Bool {
        let required = Set(difficulty.gamesRequired)
        return required.isSubset(of: completedGames)
    }
    
    init(date: String, difficulty: Difficulty) {
        self.date = date
        self.difficulty = difficulty
        self.completedGames = []
    }
    
    mutating func markCompleted(_ gameType: GameType) {
        completedGames.insert(gameType)
    }
    
    mutating func reset() {
        completedGames = []
    }
}
