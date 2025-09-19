//
//  PLSceneView.swift
//  BPPulse
//
//  Created by admin on 2025/9/18.
//

import UIKit

class PLSceneView: PLBaseView {

    lazy var icon = {
        let view = UIImageView()
        return view
    }()
    
    lazy var titleLabel = {
        let label = UILabel()
        label.textColor = .text_2
        label.font = .fontWithSize(size: 12)
        label.text = BPScene.standard.title
        return label
    }()
    
    override func setupUI() {
        super.setupUI()
        self.layerCornerRadius = 8
        self.backgroundColor = .bg_5
        self.layerBorderColor = .white
        self.layerBorderWidth = 1
        
        let view = UIView()
        addSubview(view)
        view.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview().inset(4 * scale)
        }
        
        view.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(4)
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    override func commonInit() {
        super.commonInit()
        scene = .standard
    }
    
    var scene: BPScene = .standard {
        didSet {
            icon.image = scene.icon
            titleLabel.text = scene.title
        }
    }
    
    var font: UIFont = .fontWithSize(size: 12.0) {
        didSet {
            titleLabel.font = font
        }
    }

}
