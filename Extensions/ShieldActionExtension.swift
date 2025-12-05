import ManagedSettings

class ShieldActionExtension: ShieldActionDelegate {
    override func handle(
        action: ShieldAction,
        for application: ApplicationToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void
    ) {
        switch action {
        case .primaryButtonPressed:
            if let url = URL(string: "termodebloqueio://resolve") {
                UIApplication.shared.open(url)
            }
            completionHandler(.close)
            
        case .secondaryButtonPressed:
            completionHandler(.close)
            
        @unknown default:
            completionHandler(.close)
        }
    }
    
    override func handle(
        action: ShieldAction,
        for webDomain: WebDomainToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void
    ) {
        if action == .primaryButtonPressed {
            if let url = URL(string: "termodebloqueio://resolve") {
                UIApplication.shared.open(url)
            }
        }
        completionHandler(.close)
    }
    
    override func handle(
        action: ShieldAction,
        for category: ActivityCategoryToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void
    ) {
        if action == .primaryButtonPressed {
            if let url = URL(string: "termodebloqueio://resolve") {
                UIApplication.shared.open(url)
            }
        }
        completionHandler(.close)
    }
}
