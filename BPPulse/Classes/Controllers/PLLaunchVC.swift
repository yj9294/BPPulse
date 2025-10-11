//
//  PLLaunchVC.swift
//  Pulse
//
//  Created by admin on 2025/9/16.
//

import UIKit

class PLLaunchVC: PLBaseVC {
    
    var timer: Timer? = nil
    var duration = 3.0
    var progress: Double = 0.0 {
        didSet {
            progressView.progress = Float(progress)
        }
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }

    lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.backgroundColor = .text_5
        view.tintColor = .primary_1
        return view
    }()
    
    override func setupUI() {
        super.setupUI()
        
        let imageView = UIImageView(image: UIImage(named: "launch_bg"))
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let icon = UIImageView(image: UIImage(named: "launch_icon"))
        view.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(70)
            make.right.equalToSuperview().offset(-70)
            make.height.equalTo(4)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    override func commonInit() {
        startLoading()
    }
    
    func startLoading() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        progress = 0.0
        duration = 14.25
        GADUtil.share.load(GADPositionExt.loadingInter)
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(loading), userInfo: nil, repeats: true)
    }
    
    @objc func loading() {
        progress += 0.01 / duration
        if progress >= 1.0 {
            progress = 1.0
            timer?.invalidate()
            GADUtil.share.show(GADPositionExt.loadingInter) { [weak self] _ in
                guard let self = self else { return }
                if self.progress == 1.0 {
                    ScreenUtil.sceneDelegate?.goTabbarVC()
                }
            }
        }
        if self.progress > 0.15, GADUtil.share.isLoaded(GADPositionExt.loadingInter) {
            self.duration = 0.5
        }
    }
}
