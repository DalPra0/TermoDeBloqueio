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
                case .termo:
                    TermoGameView()
                        .environmentObject(coordinator)
                case .dueto:
                    DuetoView()
                        .environmentObject(coordinator)
                case .quarteto:
                    QuartetoView()
                        .environmentObject(coordinator)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
