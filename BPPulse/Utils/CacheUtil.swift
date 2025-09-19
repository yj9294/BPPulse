//
//  CacheUtil.swift
//  Pulse
//
//  Created by admin on 2025/9/16.
//

import UIKit

class CacheUtil: NSObject {
    static let shared = CacheUtil()
    
    @CodableUserDefaults(key: .cachePulseListKey, defaultValue: [])
    private var _pulseList: [PLPulseModel]
    func getPulseList() -> [PLPulseModel] {
        _pulseList
    }
    func getHomePulse(_ filter: PLHomeFilterModel) -> PLPulseModel? {
        if _pulseList.isEmpty {
            return nil
        }
        switch filter {
        case .newest:
            return _pulseList.first
        case .average:
            let sys = _pulseList.map({$0.systolic}).reduce(0, +) / _pulseList.count
            let dia = _pulseList.map({$0.diastolic}).reduce(0, +) / _pulseList.count
            let pul = _pulseList.map({$0.pulse}).reduce(0, +) / _pulseList.count
            return .init(systolic: sys, diastolic: dia, pulse: pul)
        case .twodays:
            guard let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: Date()) else {
                return nil
            }
            let list = _pulseList.filter { $0.createDate >= twoDaysAgo }
            if list.isEmpty {
                return nil
            }
            let sys = list.map({$0.systolic}).reduce(0, +) / list.count
            let dia = list.map({$0.diastolic}).reduce(0, +) / list.count
            let pul = list.map({$0.pulse}).reduce(0, +) / list.count
            return .init(systolic: sys, diastolic: dia, pulse: pul)
        }
    }
    
    func  cachePulse(_ pulse: PLPulseModel) {
        if let firstIndex = _pulseList.firstIndex(where: {$0.id == pulse.id}) {
            _pulseList[firstIndex] = pulse
        } else {
            _pulseList.insert(pulse, at: 0)
        }
    }
}


extension String {
    static let cachePulseListKey = "com.pulse.list"
}
