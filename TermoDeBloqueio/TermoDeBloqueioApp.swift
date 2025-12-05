//
//  TermoDeBloqueioApp.swift
//  TermoDeBloqueio
//
//  Created by Lucas Dal Pra Brascher on 01/12/25.
//

import SwiftUI

@main
struct TermoDeBloqueioApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView()
                .environmentObject(coordinator)
                .onOpenURL { url in
                    if url.scheme == "termodebloqueio" && url.host == "resolve" {
                        coordinator.showLockScreen()
                    }
                }
        }
    }
}
