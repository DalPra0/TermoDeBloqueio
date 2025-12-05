//
//  ShieldConfigurationExtension.swift
//  TermoDeBloqueioShieldConfiguration
//
//  Created by Lucas Dal Pra Brascher on 05/12/25.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        ShieldConfiguration(
            backgroundBlurStyle: .systemThickMaterial,
            backgroundColor: UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0),
            icon: UIImage(systemName: "lock.fill"),
            title: ShieldConfiguration.Label(
                text: "App Bloqueado",
                color: .white
            ),
            subtitle: ShieldConfiguration.Label(
                text: "Complete o Termo para desbloquear",
                color: UIColor(white: 0.7, alpha: 1.0)
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "Resolver Termo",
                color: .white
            ),
            primaryButtonBackgroundColor: UIColor(red: 0.40, green: 0.71, blue: 0.38, alpha: 1.0),
            secondaryButtonLabel: ShieldConfiguration.Label(
                text: "Cancelar",
                color: UIColor(white: 0.7, alpha: 1.0)
            )
        )
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        return configuration(shielding: application)
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        ShieldConfiguration(
            backgroundBlurStyle: .systemThickMaterial,
            backgroundColor: UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0),
            icon: UIImage(systemName: "lock.fill"),
            title: ShieldConfiguration.Label(
                text: "Site Bloqueado",
                color: .white
            ),
            subtitle: ShieldConfiguration.Label(
                text: "Complete o Termo para desbloquear",
                color: UIColor(white: 0.7, alpha: 1.0)
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "Resolver Termo",
                color: .white
            ),
            primaryButtonBackgroundColor: UIColor(red: 0.40, green: 0.71, blue: 0.38, alpha: 1.0)
        )
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        return configuration(shielding: webDomain)
    }
}
