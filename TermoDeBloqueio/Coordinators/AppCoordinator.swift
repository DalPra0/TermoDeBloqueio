import SwiftUI
import Combine

class AppCoordinator: ObservableObject {
    @Published var currentView: AppView = .menu
    
    enum AppView {
        case menu
        case termo
        case dueto
        case quarteto
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
}
