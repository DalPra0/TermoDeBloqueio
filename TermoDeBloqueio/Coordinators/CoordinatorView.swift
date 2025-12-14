import SwiftUI

struct CoordinatorView: View {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some View {
        NavigationView {
            ZStack {
                switch coordinator.currentView {
                case .menu:
                    MenuView()
                        .environmentObject(coordinator)
                case .palavrada:
                    PalavradaGameView()
                        .environmentObject(coordinator)
                case .dueto:
                    DuetoView()
                        .environmentObject(coordinator)
                case .quarteto:
                    QuartetoView()
                        .environmentObject(coordinator)
                case .settings:
                    SettingsView()
                        .environmentObject(coordinator)
                case .lockScreen:
                    LockScreenView()
                        .environmentObject(coordinator)
                case .appSelection:
                    AppSelectionView()
                        .environmentObject(coordinator)
                }
                
                if coordinator.showWelcome {
                    WelcomeView()
                        .environmentObject(coordinator)
                        .transition(.opacity)
                        .zIndex(999)
                }
            }
            .navigationBarHidden(true)
            .animation(.easeInOut(duration: 0.3), value: coordinator.showWelcome)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
