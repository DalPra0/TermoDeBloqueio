import SwiftUI
import Combine

class AppCoordinator: ObservableObject {
    @Published var currentView: AppView
    private let blockManager = BlockManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.currentView = blockManager.isBlocked ? .lockScreen : .menu
        
        blockManager.$isBlocked
            .sink { [weak self] isBlocked in
                guard let self = self else { return }
                if isBlocked && self.currentView != .settings && self.currentView != .lockScreen {
                    self.currentView = .lockScreen
                } else if !isBlocked && self.currentView == .lockScreen {
                    self.currentView = .menu
                }
            }
            .store(in: &cancellables)
    }
    
    enum AppView {
        case menu
        case termo
        case dueto
        case quarteto
        case settings
        case lockScreen
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
}
