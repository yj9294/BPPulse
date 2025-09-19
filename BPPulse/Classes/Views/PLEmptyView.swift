//
//  PLEmptyView.swift
//  BPPulse
//
//  Created by admin on 2025/9/18.
//

import UIKit

class PLEmptyView: PLBaseView {

    var goHandle: (()->Void)? = nil

    override func setupUI() {
        self.backgroundColor = .white
        let view = UIView()
        addSubview(view)
        view.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-100)
            make.left.right.equalToSuperview()
        }
        let imageView = UIImageView(image: UIImage(named: "common_empty"))
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "No records found. Create your first record."
        titleLabel.font = .fontWithSize(size: 14, weigth: .regular)
        titleLabel.textColor = .text_3
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(24 * scale)
            make.left.right.equalToSuperview().inset(50)
        }
        
        let button = UIButton()
        button.addAction { [weak self] in
            self?.goHandle?()
        }
        button.layerCornerRadius = 22.5 * scale
        button.backgroundColor = .primary_1
        button.setImage(UIImage(named: "common_add"), for: .normal)
        button.setTitle("Generate Record", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .fontWithSize(size: 14)
        button.centerTextAndImage(spacing: 7)
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(36 * scale)
            make.left.right.equalToSuperview().inset(90)
            make.height.equalTo(45 * scale)
            make.bottom.equalToSuperview()
        }
    }
}
