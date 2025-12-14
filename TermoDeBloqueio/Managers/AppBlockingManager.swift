import Foundation
import FamilyControls
import ManagedSettings
import DeviceActivity
import Combine

class AppBlockingManager: ObservableObject {
    static let shared = AppBlockingManager()
    
    private let store = ManagedSettingsStore(named: ManagedSettingsStore.Name("TermoDeBloqueio"))
    private let center = AuthorizationCenter.shared
    private let userDefaults = UserDefaults.standard
    private let selectionKey = "appSelectionData"
    
    @Published var isAuthorized = false
    @Published var selection = FamilyActivitySelection() {
        didSet {
            saveSelection()
        }
    }
    
    private init() {
        loadSelection()
        checkAuthorization()
    }
    
    private func saveSelection() {
        let data = ["tokenCount": selection.applicationTokens.count]
        if let encoded = try? JSONEncoder().encode(data) {
            userDefaults.set(encoded, forKey: selectionKey)
        }
    }
    
    private func loadSelection() {
        if let data = userDefaults.data(forKey: selectionKey),
           let decoded = try? JSONDecoder().decode([String: Int].self, from: data) {
            print("📱 Seleção anterior encontrada: \(decoded["tokenCount"] ?? 0) apps")
        }
    }
    
    func requestAuthorization() async {
        do {
            try await center.requestAuthorization(for: .individual)
            await MainActor.run {
                isAuthorized = true
            }
            print("Autorização concedida")
        } catch {
            print("Erro ao solicitar autorização: \(error)")
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
                print("Status: Autorizado")
            default:
                await MainActor.run {
                    isAuthorized = false
                }
                print("Status: Não autorizado")
            }
        }
    }
    
    func blockApps() {
        guard !selection.applicationTokens.isEmpty else {
            print("Nenhum app selecionado para bloquear")
            return
        }
        
        let tokens = selection.applicationTokens
        store.shield.applications = tokens
        
        print("BLOQUEIO ATIVADO")
        print("Apps bloqueados: \(tokens.count)")
        if tokens.count <= 5 {
            print("Tokens: \(tokens)")
        }
    }
    
    func unblockApps() {
        store.shield.applications = nil
        
        print("BLOQUEIO DESATIVADO")
        print("Todos os apps desbloqueados")
    }
    
    func isBlocking() -> Bool {
        let blocking = store.shield.applications != nil
        print("isBlocking = \(blocking)")
        return blocking
    }
}
