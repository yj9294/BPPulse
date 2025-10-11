//
//  GADNativeView.swift
//  WaterPop
//
//  Created by Super on 2024/3/18.
//

import Foundation
import GoogleMobileAds

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

class GADNativeView: NativeAdView {
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = UIColor.init(hex: 0x525050)
        return label
    }()
    
    lazy var subTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.textColor = UIColor.init(hex: 0x858585)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.layer.cornerRadius = 4
        icon.backgroundColor = .lightGray
        icon.contentMode = .scaleAspectFill
        return icon
    }()
    
    lazy var adTag: UILabel = {
        let imageView = UILabel()
        imageView.text = "AD"
        imageView.textAlignment = .center
        imageView.font = .fontWithSize(size: 9)
        imageView.backgroundColor = .primary_1
        imageView.textColor = .white
        imageView.isHidden = true
        imageView.layerCornerRadius = 2
        return imageView
    }()
    
    lazy var install: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.init(hex: 0x15AA00)
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        button.titleLabel?.font = .fontWithSize(size: 11.0)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    lazy var big: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        return image
    }()
    
    lazy var playView: MediaView = {
        let view = MediaView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    enum Style {
        case small, big
    }
    
    init(_ style: Style) {
        super.init(frame: .zero)
        self.style = style
        setupUI()
    }
    
    private var style: Style = .small
    
    override var nativeAd: NativeAd? {
        didSet {
            super.nativeAd = nativeAd
            title.text = nativeAd?.headline
            subTitle.text = nativeAd?.body
            icon.image = nativeAd?.icon?.image
            install.setTitle(nativeAd?.callToAction, for: .normal)
            big.image = nativeAd?.images?.first?.image
            playView.mediaContent = nativeAd?.mediaContent
            if playView.mediaContent != nil {
                big.isHidden = true
            } else {
                big.isHidden = false
            }
            self.adTag.isHidden = nativeAd == nil
            self.isHidden = nativeAd == nil
            updateConstraint()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(icon)
        addSubview(title)
        addSubview(subTitle)
        addSubview(install)
        addSubview(adTag)
        addSubview(big)
        addSubview(playView)
        iconView = icon
        headlineView = title
        bodyView = subTitle
        callToActionView = install
        advertiserView = adTag
        imageView = big
        mediaView = playView
    }
    
     func updateConstraint() {
        if style == .small {
            self.backgroundColor = .white
            icon.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(14)
                make.left.equalToSuperview().offset(16)
                make.width.height.equalTo(44)
            }
            title.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(14)
                make.left.equalTo(icon.snp.right).offset(13)
                make.right.equalToSuperview().offset(-30)
            }
            adTag.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalToSuperview().offset(8)
                make.width.equalTo(20)
                make.height.equalTo(15)
            }
            subTitle.numberOfLines = 1
            subTitle.snp.makeConstraints { make in
                make.top.equalTo(title.snp.bottom).offset(7)
                make.right.equalToSuperview().offset(-22)
                make.left.equalTo(title)
            }
            install.snp.makeConstraints { make in
                make.top.equalTo(icon.snp.bottom).offset(8)
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
                make.height.equalTo(36)
            }
        } else {
            big.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(14)
                make.left.equalToSuperview().offset(22)
                make.right.equalToSuperview().offset(-127)
                make.height.equalTo(120)
            }
            playView.snp.makeConstraints { make in
                make.top.left.right.bottom.equalTo(big)
            }
            
            icon.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(14)
                make.right.equalToSuperview().offset(-50)
                make.width.height.equalTo(36)
            }
            title.snp.makeConstraints { make in
                make.top.equalTo(icon.snp.bottom).offset(8)
                make.left.equalTo(big.snp.right).offset(12)
                make.right.equalToSuperview().offset(-30)
            }
            adTag.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalToSuperview().offset(8)
                make.width.equalTo(20)
                make.height.equalTo(15)
            }
            
            install.snp.makeConstraints { make in
                make.top.equalTo(title.snp.bottom).offset(12)
                make.left.equalTo(title)
                make.right.equalToSuperview().offset(-12)
                make.height.equalTo(36)
            }
            
            subTitle.numberOfLines = 2
            subTitle.snp.makeConstraints { make in
                make.top.equalTo(big.snp.bottom).offset(8)
                make.left.equalTo(big)
                make.right.equalToSuperview().offset(-22)
            }
        }
    }
}
