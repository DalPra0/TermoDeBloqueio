import SwiftUI
import Combine

class AppCoordinator: ObservableObject {
    @Published var currentView: AppView
    @Published var showWelcome: Bool = false
    private let blockManager = BlockManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Verificar se é primeira vez
        let hasSeenWelcome = UserDefaults.standard.bool(forKey: "hasSeenWelcome")
        self.showWelcome = !hasSeenWelcome
        
        self.currentView = blockManager.isBlocked ? .lockScreen : .menu
        
        // Melhorar sincronização de navegação com estado de bloqueio
        blockManager.$isBlocked
            .sink { [weak self] isBlocked in
                guard let self = self else { return }
                
                let gameViews: [AppView] = [.termo, .dueto, .quarteto]
                
                // Se bloqueou E não está jogando, vai para lockscreen
                if isBlocked && !gameViews.contains(self.currentView) {
                    self.currentView = .lockScreen
                }
                // Se desbloqueou de qualquer lugar, vai pro menu
                else if !isBlocked {
                    self.currentView = .menu
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
        case termo
        case dueto
        case quarteto
        case settings
        case lockScreen
        case appSelection
    }
    
    func showMenu() {
        currentView = .menu
    }
    
    func showTermo() {
        currentView = .termo
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
