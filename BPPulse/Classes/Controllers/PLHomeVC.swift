//
//  PLHomeVC.swift
//  Pulse
//
//  Created by admin on 2025/9/16.
//

import UIKit

class PLHomeVC: PLBaseVC {
    
    lazy var segementView = {
        let view = PLHomeSegementView()
        view.didSelectHandle = { [weak self] filter  in
            self?.refreshItem(filter)
        }
        return view
    }()
    
    lazy var statusView = {
        let view = PLHomeStatusView()
        view.status = .normal
        return view
    }()

    lazy var contentView = {
        let view = PLHomeContentView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        
        refreshItem(segementView.item)
    }
    
    func setupNavigationBar() {
        // 创建一个按钮
        let leftItem = UIBarButtonItem(title: "BP Pulse", style: .plain, target: self, action: nil)

        // 设置字体和颜色
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .black),
            .foregroundColor: UIColor.primary_1
        ]
        leftItem.setTitleTextAttributes(attributes, for: .normal)
        leftItem.setTitleTextAttributes(attributes, for: .highlighted)

        // 设置到 navigationItem
        navigationItem.leftBarButtonItem = leftItem

        let rightItem = UIBarButtonItem(image: UIImage(named: "home_noti")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(notiAction))
        navigationItem.rightBarButtonItem = rightItem
        requestNotification()
    }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubview(segementView)
        segementView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.right.equalToSuperview().inset(16)
        }
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(segementView.snp.bottom).offset(16 * scale)
            make.left.right.equalToSuperview().inset(16)
        }

        let recentTitleLabel = UILabel()
        recentTitleLabel.text = "Recent Trends"
        recentTitleLabel.textColor = .black
        recentTitleLabel.font = .fontWithSize(size: 18  , weigth: .medium)
        view.addSubview(recentTitleLabel)
        recentTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(24 * scale)
            make.left.equalToSuperview().offset(16)
        }
        
        let moreButton = UIButton()
        moreButton.setTitle("More", for: .normal)
        moreButton.titleLabel?.font = .fontWithSize(size: 14)
        moreButton.setTitleColor(.primary_1, for: .normal)
        moreButton.addAction { [weak self] in
            self?.moreAction()
        }
        view.addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(recentTitleLabel)
            make.right.equalToSuperview().offset(-16)
        }
        
        let centerView = UIImageView(image: UIImage(named: "home_center"))
        centerView.contentMode = .scaleAspectFill
        centerView.layerCornerRadius = 16
        view.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.top.equalTo(moreButton.snp.bottom).offset(16 * scale)
            make.left.right.equalToSuperview().inset(16)
        }
        
        view.addSubview(statusView)
        statusView.snp.makeConstraints { make in
            make.top.equalTo(centerView.snp.bottom).offset(24 * scale)
            make.left.right.equalToSuperview().inset(16)
        }
        
        let addButton = UIButton()
        addButton.setImage(UIImage(named: "home_add"), for: .normal)
        addButton.addAction { [weak self] in
            self?.addAction()
        }
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-8)
        }
    }
    
    override func commonInit() {
        super.commonInit()
    }
    
    func requestNotification() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                DispatchQueue.main.async {
                    self.navigationItem.rightBarButtonItem?.tintColor = .primary_1
                }
            default:
                DispatchQueue.main.async {
                    self.navigationItem.rightBarButtonItem?.tintColor = .text_4
                    let cancel = AEAction(title: "NO") {
                    }
                    let login = AEAction(buttonColor: .primary_1, title: "YES") {
                        if settings.authorizationStatus == .notDetermined {
                            PushUtil.shared.registerRemoteNotification {
                                DispatchQueue.main.async {
                                    self.navigationItem.rightBarButtonItem?.tintColor = .primary_1
                                }
                            }
                        } else {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                if UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            }
                        }
                    }
                    AEAlertControl.alert(title: "Enable Notifications?", content: "Turn on local notifications to remind you to record?", actions: [cancel, login])
                }
            }
        }
    }
    
    @objc func notiAction() {
        
    }

    func moreAction() {
        let vc = PLHistoryVC()
        vc.title = "History"
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc)
    }
    
    func addAction() {
        let vc = PLAddVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc)
    }
    
    func refreshItem(_ filter: PLHomeFilterModel) {
        guard let item = CacheUtil.shared.getHomePulse(filter) else { return }
        statusView.status = item.status
        contentView.item = item
    }
}
