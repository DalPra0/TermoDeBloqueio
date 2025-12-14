import Foundation
import Combine
import FamilyControls

class BlockManager: ObservableObject {
    static let shared = BlockManager()
    
    @Published var isBlocked: Bool = true
    @Published var currentDifficulty: Difficulty = .easy
    @Published var dailyProgress: DailyProgress
    
    private let userDefaults = UserDefaults.standard
    private let difficultyKey = "selectedDifficulty"
    private let progressKey = "dailyProgress"
    private let debugBlockKey = "debugBlock"
    private let lastCheckDateKey = "lastCheckDate"
    private let appBlockingManager = AppBlockingManager.shared
    private var midnightCheckTimer: Timer?
    
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
        setupMidnightCheck()
    }
    
    private func setupMidnightCheck() {
        midnightCheckTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.checkIfNewDay()
        }
    }
    
    private func checkIfNewDay() {
        let today = Self.getTodayString()
        let lastCheck = userDefaults.string(forKey: lastCheckDateKey) ?? ""
        
        if today != lastCheck {
            print("Novo dia detectado! Resetando progresso...")
            userDefaults.set(today, forKey: lastCheckDateKey)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.dailyProgress = DailyProgress(date: today, difficulty: self.currentDifficulty)
                self.saveProgress()
                self.updateBlockState()
            }
        }
    }
    
    func setDifficulty(_ difficulty: Difficulty) {
        if !dailyProgress.completedGames.isEmpty {
            print("⚠️ Não é possível mudar dificuldade após começar a jogar")
            return
        }
        
        currentDifficulty = difficulty
        userDefaults.set(difficulty.rawValue, forKey: difficultyKey)
        
        dailyProgress.difficulty = difficulty
        saveProgress()
        updateBlockState()
        
        print("🎯 Dificuldade alterada para: \(difficulty.displayName)")
    }
    
    func markGameCompleted(_ gameType: GameType) {
        let today = Self.getTodayString()
        
        guard dailyProgress.date == today else {
            print("Dia mudou durante o jogo - resetando progresso sem marcar como completo")
            dailyProgress = DailyProgress(date: today, difficulty: currentDifficulty)
            saveProgress()
            updateBlockState()
            return
        }
        
        dailyProgress.markCompleted(gameType)
        saveProgress()
        updateBlockState()
        
        print("Jogo \(gameType) marcado como completo")
        print("   Progresso: \(dailyProgress.completedGames.count)/\(currentDifficulty.gamesRequired.count)")
    }
    
    func resetProgress() {
        dailyProgress.reset()
        saveProgress()
        updateBlockState()
    }
    
    private func updateBlockState() {
        let debugBlock = userDefaults.bool(forKey: debugBlockKey)
        let shouldBlock = debugBlock ? true : !dailyProgress.isUnlocked
        
        let hasAppsSelected = !appBlockingManager.selection.applicationTokens.isEmpty
        
        if isBlocked != shouldBlock {
            isBlocked = shouldBlock
            print("🔄 Estado mudou para: \(isBlocked ? "BLOQUEADO" : "DESBLOQUEADO")")
        }
        
        if isBlocked && hasAppsSelected {
            appBlockingManager.blockApps()
        } else if !isBlocked {
            appBlockingManager.unblockApps()
        } else if isBlocked && !hasAppsSelected {
            print("⚠️ Nenhum app selecionado para bloquear. Vá em Configurações > Selecionar Apps")
        }
    }
    
    private func saveProgress() {
        if let data = try? JSONEncoder().encode(dailyProgress) {
            userDefaults.set(data, forKey: progressKey)
            userDefaults.synchronize()
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
    
    var canChangeDifficulty: Bool {
        dailyProgress.completedGames.isEmpty
    }
    
    private static func getTodayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}
