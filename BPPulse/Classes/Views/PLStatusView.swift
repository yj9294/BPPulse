//
//  PLStatusView.swift
//  BPPulse
//
//  Created by admin on 2025/9/18.
//

import UIKit

class PLStatusView: PLBaseView {
    
    private lazy var stateLabel = {
        let label = UILabel()
        label.textColor = .normal
        label.text = BPStatus.normal.title
        label.textAlignment = .center
        label.font = .fontWithSize(size: 14, weigth: .regular)
        return label
    }()
    
    private lazy var icon = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    var font: UIFont = .fontWithSize(size: 14.0) {
        didSet {
            stateLabel.font = font
        }
    }
    
    var status: BPStatus = .normal {
        didSet {
            stateLabel.textColor = status.color
            self.backgroundColor = status.bgColor
            stateLabel.text = status.title
            icon.image = status.icon
        }
    }
    
    
    override func setupUI() {
        super.setupUI()
        
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
        
        view.addSubview(stateLabel)
        stateLabel.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(4)
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    override func commonInit() {
        super.commonInit()
        self.status = .normal
    }
    
}
