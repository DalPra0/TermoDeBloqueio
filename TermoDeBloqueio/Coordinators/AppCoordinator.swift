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
        
        // CORRIGIDO: Navegação inteligente que não trava o usuário durante jogos
        blockManager.$isBlocked
            .dropFirst() // Ignora o valor inicial para evitar race condition
            .sink { [weak self] isBlocked in
                guard let self = self else { return }
                
                print("🔄 Estado de bloqueio mudou: \(isBlocked ? "BLOQUEADO" : "DESBLOQUEADO")")
                print("   View atual: \(self.currentView)")
                
                // Se bloqueou E está no menu (não em jogo/settings)
                if isBlocked && self.currentView == .menu {
                    print("   → Redirecionando para LockScreen")
                    DispatchQueue.main.async {
                        self.currentView = .lockScreen
                    }
                }
                // Se desbloqueou de qualquer lugar (exceto se já está no menu)
                else if !isBlocked && self.currentView != .menu {
                    print("   → Usuário pode navegar livremente")
                    // NÃO força menu, deixa o usuário decidir
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
