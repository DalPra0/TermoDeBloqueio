import Foundation
import Combine

class BlockManager: ObservableObject {
    static let shared = BlockManager()
    
    @Published var isBlocked: Bool = true
    @Published var currentDifficulty: Difficulty = .easy
    @Published var dailyProgress: DailyProgress
    
    private let userDefaults = UserDefaults.standard
    private let difficultyKey = "selectedDifficulty"
    private let progressKey = "dailyProgress"
    private let debugBlockKey = "debugBlock"
    private let appBlockingManager = AppBlockingManager.shared
    
    private init() {
        let today = Self.getTodayString()
        
        let savedDifficulty: Difficulty
        if let savedDifficultyString = userDefaults.string(forKey: difficultyKey),
           let difficulty = Difficulty(rawValue: savedDifficultyString) {
            savedDifficulty = difficulty
        } else {
            savedDifficulty = .easy
        }
        
        self.currentDifficulty = savedDifficulty
        
        if let data = userDefaults.data(forKey: progressKey),
           let progress = try? JSONDecoder().decode(DailyProgress.self, from: data),
           progress.date == today {
            self.dailyProgress = progress
        } else {
            self.dailyProgress = DailyProgress(date: today, difficulty: savedDifficulty)
        }
        
        updateBlockState()
    }
    
    func setDifficulty(_ difficulty: Difficulty) {
        currentDifficulty = difficulty
        userDefaults.set(difficulty.rawValue, forKey: difficultyKey)
        
        dailyProgress.difficulty = difficulty
        saveProgress()
        updateBlockState()
    }
    
    func markGameCompleted(_ gameType: GameType) {
        checkAndResetIfNewDay()
        
        dailyProgress.markCompleted(gameType)
        saveProgress()
        updateBlockState()
    }
    
    func resetProgress() {
        dailyProgress.reset()
        saveProgress()
        updateBlockState()
    }
    
    private func updateBlockState() {
        let debugBlock = userDefaults.bool(forKey: debugBlockKey)
        isBlocked = debugBlock ? true : !dailyProgress.isUnlocked
        
        if isBlocked {
            appBlockingManager.blockApps()
        } else {
            appBlockingManager.unblockApps()
        }
    }
    
    private func saveProgress() {
        if let data = try? JSONEncoder().encode(dailyProgress) {
            userDefaults.set(data, forKey: progressKey)
        }
    }
    
    private func checkAndResetIfNewDay() {
        let today = Self.getTodayString()
        if dailyProgress.date != today {
            dailyProgress = DailyProgress(date: today, difficulty: currentDifficulty)
            saveProgress()
        }
    }
    
    func toggleDebugBlock() {
        let currentState = userDefaults.bool(forKey: debugBlockKey)
        userDefaults.set(!currentState, forKey: debugBlockKey)
        updateBlockState()
    }
    
    var isDebugBlocked: Bool {
        userDefaults.bool(forKey: debugBlockKey)
    }
    
    private static func getTodayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
