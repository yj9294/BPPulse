//
//  PLBaseView.swift
//  Pulse
//
//  Created by admin on 2025/9/16.
//

import UIKit

class PLBaseView: UIView {
    var debouncer: Debouncer = Debouncer(interval: 0.2)
    
    let scale = ScreenUtil.scale()

    init() {
        super.init(frame: .zero)
        setupUI()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        debugPrint("\(self.classForCoder) deinit 💦💦💦")
    }
}

extension PLBaseView {
    @objc func setupUI() {
        
    }
    
    @objc func commonInit() {
        
    }
}
