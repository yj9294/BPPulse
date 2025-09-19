//
//  PLDebouncer.swift
//  Pulse
//
//  Created by admin on 2025/9/16.
//

import UIKit

class Debouncer {
    private var lastFireTime: DispatchTime = .now()
    private var interval: TimeInterval

    init(interval: TimeInterval) {
        self.interval = interval
    }

    func call(_ action: @escaping () -> Void) {
        let now = DispatchTime.now()
        let delta = now.uptimeNanoseconds - lastFireTime.uptimeNanoseconds
        if delta >= UInt64(interval * 1_000_000_000) {
            lastFireTime = now
            action()
        }
    }
}
