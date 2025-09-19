//
//  PLTabbarModel.swift
//  Pulse
//
//  Created by admin on 2025/9/16.
//

import UIKit

enum PLTabbarModel: Codable {
    case home, history, health, settings
    var title: String{
        switch self {
        case .home:
            return "Home"
        case .history:
            return "History"
        case .health:
            return "Health"
        case .settings:
            return "Settings"
        }
    }
    var icon: UIImage? {
        switch self {
        case .home:
            UIImage(named: "tab_home")
        case .history:
            UIImage(named: "tab_history")
        case .health:
            UIImage(named: "tab_health")
        case .settings:
            UIImage(named: "tab_settings")
        }
    }
    
    var vc: PLBaseVC {
        switch self {
        case .home:
            PLHomeVC()
        case .history:
            PLHistoryVC()
        case .health:
            PLHealthVC()
        case .settings:
            PLSettingsVC()
        }
    }
}
