import ManagedSettings
import UIKit

class ShieldActionExtension: ShieldActionDelegate {
    
    private func openApp() {
        guard let url = URL(string: "termodebloqueio://resolve") else { return }
        
        var responder: UIResponder? = nil
        let selector = NSSelectorFromString("sharedApplication")
        
        if UIApplication.responds(to: selector) {
            responder = UIApplication.perform(selector).takeUnretainedValue() as? UIResponder
        }
        
        let openSelector = NSSelectorFromString("openURL:")
        if let responder = responder, responder.responds(to: openSelector) {
            responder.perform(openSelector, with: url)
        }
    }
    
    override func handle(action: ShieldAction, for application: ApplicationToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        switch action {
        case .primaryButtonPressed:
            openApp()
            completionHandler(.close)
            
        case .secondaryButtonPressed:
            completionHandler(.close)
            
        @unknown default:
            completionHandler(.close)
        }
    }
    
    override func handle(action: ShieldAction, for webDomain: WebDomainToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        if action == .primaryButtonPressed {
            openApp()
        }
        completionHandler(.close)
    }
    
    override func handle(action: ShieldAction, for category: ActivityCategoryToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        if action == .primaryButtonPressed {
            openApp()
        }
        completionHandler(.close)
    }
}
