import Foundation
import FamilyControls
import ManagedSettings
import DeviceActivity
import Combine

class AppBlockingManager: ObservableObject {
    static let shared = AppBlockingManager()
    
    // CRÍTICO: Store nomeado para persistência
    private let store = ManagedSettingsStore(named: ManagedSettingsStore.Name("TermoDeBloqueio"))
    private let center = AuthorizationCenter.shared
    
    @Published var isAuthorized = false
    @Published var selection = FamilyActivitySelection()
    
    private init() {
        checkAuthorization()
    }
    
    func requestAuthorization() async {
        do {
            try await center.requestAuthorization(for: .individual)
            await MainActor.run {
                isAuthorized = true
            }
            print("✅ Autorização concedida!")
        } catch {
            print("❌ Erro ao solicitar autorização: \(error)")
            await MainActor.run {
                isAuthorized = false
            }
        }
    }
    
    private func checkAuthorization() {
        Task {
            switch center.authorizationStatus {
            case .approved:
                await MainActor.run {
                    isAuthorized = true
                }
                print("✅ Status: Autorizado")
            default:
                await MainActor.run {
                    isAuthorized = false
                }
                print("⚠️ Status: Não autorizado")
            }
        }
    }
    
    func blockApps() {
        guard !selection.applicationTokens.isEmpty else {
            print("⚠️ Nenhum app selecionado para bloquear")
            return
        }
        
        // CORRIGIDO: Bloqueia APENAS os apps selecionados
        let tokens = selection.applicationTokens
        store.shield.applications = tokens
        
        // REMOVIDO: Linha perigosa que bloqueava TODAS categorias
        // store.shield.applicationCategories = .all(except: Set())
        // ☝️ Isso bloqueava apps do sistema!
        
        print("🔒 BLOQUEIO ATIVADO")
        print("📱 Apps bloqueados: \(tokens.count)")
        if tokens.count <= 5 {
            print("🎯 Tokens: \(tokens)")
        }
    }
    
    func unblockApps() {
        store.shield.applications = nil
        // CORRIGIDO: Remove apenas o bloqueio de apps, não categorias
        // (já não bloqueamos categorias mais)
        
        print("🔓 BLOQUEIO DESATIVADO")
        print("✅ Todos os apps desbloqueados")
    }
    
    func isBlocking() -> Bool {
        let blocking = store.shield.applications != nil
        print("❓ isBlocking = \(blocking)")
        return blocking
    }
}
