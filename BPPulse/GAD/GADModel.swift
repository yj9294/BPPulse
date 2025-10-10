//
//  GADModel.swift
//  OfflineMusic
//
//  Created by admin on 2025/3/26.
//

import UIKit

public enum GADPositionExt: String, CaseIterable, GADPosition {
    public var isNative: Bool {
        switch self {
        case .homeNative, .resultNative, .infoNative:
            return true
        default:
            return false
        }
    }
    
    public var isOpen: Bool {
        return false
    }
    
    public var isInterstital: Bool {
        switch self {
        case .loadingInter, .recordInter, .addInter:
            return true
        default:
            return false
        }
    }
    
    public var isPreload: Bool {
        return true
    }
    
    case loadingInter, recordInter, addInter, homeNative, resultNative, infoNative
}
