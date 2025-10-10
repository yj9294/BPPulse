//
//  PLHomeVC.swift
//  Pulse
//
//  Created by admin on 2025/9/16.
//

import UIKit

class PLHomeVC: PLBaseVC {
    
    private var willAppear = false
    private var impressDate = Date().addingTimeInterval(-11)
    private lazy var adView: GADNativeView = {
        let adView = GADNativeView(.big)
        adView.layer.cornerRadius = 8
        adView.layer.masksToBounds = true
        return adView
    }()
    
    lazy var recentTitleLabel = {
        let recentTitleLabel = UILabel()
        recentTitleLabel.text = "Recent Trends"
        recentTitleLabel.textColor = .black
        recentTitleLabel.font = .fontWithSize(size: 18  , weigth: .medium)
        return recentTitleLabel
    }()
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(nativeADLoad), name: .nativeUpdate, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        
        refreshItem(segementView.item)
        willAppear = true
        GADUtil.share.load(GADPositionExt.homeNative)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        willAppear = false
        GADUtil.share.disappear(GADPositionExt.homeNative)
    }
    
    func setupNavigationBar() {
        // 创建一个按钮
        let leftItem = UIBarButtonItem(title: "PressureTrack", style: .plain, target: self, action: nil)

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
        
        // 1. 新增 scrollView 和 contentViewContainer
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        let contentViewContainer = UIView()
        scrollView.addSubview(contentViewContainer)
        contentViewContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        // 2. 将其他子视图添加到 contentViewContainer
        contentViewContainer.addSubview(segementView)
        segementView.snp.makeConstraints { make in
            make.top.equalTo(contentViewContainer.snp.top)
            make.left.right.equalToSuperview().inset(16)
        }
        
        contentViewContainer.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(segementView.snp.bottom).offset(16 * scale)
            make.left.right.equalToSuperview().inset(16)
        }

        contentViewContainer.addSubview(recentTitleLabel)
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
        contentViewContainer.addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(recentTitleLabel)
            make.right.equalToSuperview().offset(-16)
        }
        
        view.addSubview(adView)
        adView.snp.remakeConstraints { make in
            make.top.equalTo(recentTitleLabel.snp.bottom).offset(16 * scale)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(0)
        }
        
        contentViewContainer.addSubview(statusView)
        statusView.snp.makeConstraints { make in
            make.top.equalTo(adView.snp.bottom).offset(24 * scale)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        // 3. addButton 仍然直接加到 view
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
                            PushUtil.shared.registerRemoteNotification { ret in
                                DispatchQueue.main.async {
                                    self.navigationItem.rightBarButtonItem?.tintColor = ret ? .primary_1 : .text_4
                                    if ret {
                                        self.addNotification()
                                    }
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
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized:
                    let ok = AEAction(title: "OK") {}
                    AEAlertControl.alert(
                        title: "Notifications Enabled",
                        content: "You will receive reminders at 8 AM and 8 PM to measure your blood pressure.",
                        actions: [ok]
                    )
                default:
                    let cancel = AEAction(title: "Cancel") {}
                    let openSettings = AEAction(buttonColor: .primary_1, title: "Open Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString),
                           UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                    AEAlertControl.alert(
                        title: "Enable Notifications?",
                        content: "Notifications are currently off. Turn them on in Settings to receive reminders.",
                        actions: [cancel, openSettings]
                    )
                }
            }
        }
    }
    
    @objc func addNotification() {
        let center = UNUserNotificationCenter.current()

        // Morning notification at 8:00 AM
        var morningDate = DateComponents()
        morningDate.hour = 8
        morningDate.minute = 0
        let morningContent = UNMutableNotificationContent()
        morningContent.title = "Morning Reminder"
        morningContent.body = "Time to record your morning pulse!"
        morningContent.sound = .default
        let morningTrigger = UNCalendarNotificationTrigger(dateMatching: morningDate, repeats: true)
        let morningRequest = UNNotificationRequest(identifier: "morning_8am", content: morningContent, trigger: morningTrigger)

        // Evening notification at 8:00 PM
        var eveningDate = DateComponents()
        eveningDate.hour = 20
        eveningDate.minute = 0
        let eveningContent = UNMutableNotificationContent()
        eveningContent.title = "Evening Reminder"
        eveningContent.body = "Don't forget to record your evening pulse!"
        eveningContent.sound = .default
        let eveningTrigger = UNCalendarNotificationTrigger(dateMatching: eveningDate, repeats: true)
        let eveningRequest = UNNotificationRequest(identifier: "evening_8pm", content: eveningContent, trigger: eveningTrigger)

        center.add(morningRequest, withCompletionHandler: nil)
        center.add(eveningRequest, withCompletionHandler: nil)
    }

    func moreAction() {
        let vc = PLHistoryVC()
        vc.title = "History"
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc)
    }
    
    func addAction() {
        GADUtil.share.load(GADPositionExt.addInter)
        GADUtil.share.show(GADPositionExt.addInter) { _ in
            let vc = PLAddVC()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc)
        }
    }
    
    func refreshItem(_ filter: PLHomeFilterModel) {
        guard let item = CacheUtil.shared.getHomePulse(filter) else { return }
        statusView.status = item.status
        contentView.item = item
    }
    
    @objc func nativeADLoad(noti: Notification) {
        if let position = noti.userInfo?["position"] as? GADPosition, position.rawValue == GADPositionExt.homeNative.rawValue {
            if let ad = noti.object as? GADNativeModel {
                if willAppear {
                    if  Date().timeIntervalSince1970 - impressDate.timeIntervalSince1970 > 10 {
                        adView.nativeAd = ad.nativeAd
                        impressDate = Date()
                        if adView.superview != nil {
                            adView.snp.remakeConstraints { make in
                                make.top.equalTo(recentTitleLabel.snp.bottom).offset(16 * scale)
                                make.left.right.equalToSuperview().inset(16)
                                make.height.equalTo(180).priority(.high)
                            }
                        }
                        return
                    } else {
                        NSLog("[ad] (\(position)) 10显示间隔 ")
                    }
                }
            }
            adView.nativeAd = nil
            view.addSubview(adView)
            adView.snp.remakeConstraints { make in
                make.top.equalTo(recentTitleLabel.snp.bottom).offset(16 * scale)
                make.left.right.equalToSuperview().inset(16)
                make.height.equalTo(0).priority(.high)
            }
        }
    }
}
