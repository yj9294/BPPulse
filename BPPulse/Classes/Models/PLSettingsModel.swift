//
//  PLSettingsModel.swift
//  BPPulse
//
//  Created by admin on 2025/9/19.
//

import UIKit

enum PLSettingsModel: Codable, CaseIterable {
    case about
    case privacy
    case feedback
    
    var title: String {
        switch self {
        case .about:
            return "About us"
        case .privacy:
            return "Privacy Policy"
        case .feedback:
            return "Feedback"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .about:
            return UIImage(named: "settings_about")
        case .privacy:
            return UIImage(named: "settings_privacy")
        case .feedback:
            return UIImage(named: "settings_feedback")
        }
    }
}
