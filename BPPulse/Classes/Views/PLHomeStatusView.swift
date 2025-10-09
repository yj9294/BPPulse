//
//  PLHomeStatusView.swift
//  BPPulse
//
//  Created by admin on 2025/9/17.
//

import UIKit

class PLHomeStatusView: PLBaseView {
    
    var status: BPStatus = .normal {
        didSet {
            self.backgroundColor = status.bgColor
            self.layerCornerRadius = 12
            titleLabel.text = status.title
            rangeLabel.text = status.reason
            detailLabel.text = status.description
            questionView.tintColor = status.color
        }
    }
    
    lazy var titleLabel = {
        let label = UILabel()
        label.textColor = .text_1
        label.font = .fontWithSize(size: 14, weigth: .medium)
        return label
    }()
    
    lazy var questionView = {
        let view = UIImageView(image: UIImage(named: "status_q")?.withRenderingMode(.alwaysTemplate))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goIntroduce)))
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var rangeLabel = {
        let label = UILabel()
        label.textColor = .text_2
        label.font = .fontWithSize(size: 14)
        return label
    }()
    
    lazy var detailLabel = {
        let label = UILabel()
        label.textColor = .text_2
        label.font = .fontWithSize(size: 11)
        label.numberOfLines = 0
        return label
    }()
    
    override func setupUI() {
        super.setupUI()
        self.backgroundColor = status.bgColor
        self.layerCornerRadius = 12
        
        let icon = UIImageView(image: UIImage(named: "home_icon"))
        addSubview(icon)
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(80 * scale)
            make.top.equalToSuperview().offset(16 * scale)
            make.left.equalToSuperview().offset(16)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16 * scale)
            make.left.equalTo(icon.snp.right).offset(16)
        }
        
        addSubview(questionView)
        questionView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right).offset(4)
            make.width.height.equalTo(16)
        }
        
        addSubview(rangeLabel)
        rangeLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4 * scale)
            make.left.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-16)
        }
        
        addSubview(detailLabel)
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(rangeLabel.snp.bottom).offset(8 * scale)
            make.left.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-16)
        }
        
        self.snp.makeConstraints { make in
            make.bottom.greaterThanOrEqualTo(icon.snp.bottom).offset(16 * scale)
            make.bottom.greaterThanOrEqualTo(detailLabel.snp.bottom).offset(8)
        }
        
    }

    
    @objc func goIntroduce() {
        if let url = URL(string: AppUtil.shared.introduceURL) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
