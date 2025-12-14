import SwiftUI
import Combine

class AppCoordinator: ObservableObject {
    @Published var currentView: AppView
    @Published var showWelcome: Bool = false
    private let blockManager = BlockManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        let hasSeenWelcome = UserDefaults.standard.bool(forKey: "hasSeenWelcome")
        self.showWelcome = !hasSeenWelcome
        
        self.currentView = blockManager.isBlocked ? .lockScreen : .menu
        
        blockManager.$isBlocked
            .dropFirst()
            .sink { [weak self] isBlocked in
                guard let self = self else { return }
                if isBlocked && self.currentView == .menu {
                    DispatchQueue.main.async {
                        self.currentView = .lockScreen
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func dismissWelcome() {
        UserDefaults.standard.set(true, forKey: "hasSeenWelcome")
        showWelcome = false
    }
    
    enum AppView {
        case menu
        case palavrada
        case dueto
        case quarteto
        case settings
        case lockScreen
        case appSelection
    }
    
    func showMenu() {
        currentView = .menu
    }
    
    func showPalavrada() {
        currentView = .palavrada
    }
    
    func showDueto() {
        currentView = .dueto
    }
    
    func showQuarteto() {
        currentView = .quarteto
    }
    
    func showSettings() {
        currentView = .settings
    }
    
    func showLockScreen() {
        currentView = .lockScreen
    }
    
    func showAppSelection() {
        currentView = .appSelection
    }
}
