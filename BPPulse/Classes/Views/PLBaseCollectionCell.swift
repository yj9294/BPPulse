//
//  PLBaseCollectionCell.swift
//  BPPulse
//
//  Created by admin on 2025/9/17.
//

import UIKit

class PLBaseCollectionCell: UICollectionViewCell {
    let scale = ScreenUtil.scale()
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func setupUI() {}
    
    @objc func commonInit() { }
}
