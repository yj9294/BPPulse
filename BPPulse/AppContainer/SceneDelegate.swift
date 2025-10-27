//
//  SceneDelegate.swift
//  Pulse
//
//  Created by admin on 2025/9/16.
//

import UIKit
import Firebase
import MobileCoreServices
import AppTrackingTransparency
import Network
import FacebookCore
import GoogleMobileAds
import AppLovinSDK
import PAGAdSDK
import PangleAdapter
import MTGSDK
import FBAEMKit
import FirebaseAnalytics

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    @CodableUserDefaults(key: "ad.price", defaultValue: 0)
    var price: Double
    
    var window: UIWindow?
    var tabbarVC: PLTabbarVC = PLTabbarVC()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        Settings.shared.isAdvertiserIDCollectionEnabled = true
        
        // applovin
        ALPrivacySettings.setHasUserConsent(true)
        ALPrivacySettings.setDoNotSell(true)

        // pangle
        GADMediationAdapterPangle.setGDPRConsent(PAGGDPRConsentType.consent.rawValue)
        
        /// MTG
        MTGSDK.sharedInstance().consentStatus = true
        MTGSDK.sharedInstance().doNotTrackStatus = false

        /// 设置全局代理 用于查找vc
        ScreenUtil.sceneDelegate = self
        
        AppEvents.shared.activateApp()
        
        MobileAds.shared.requestConfiguration.testDeviceIdentifiers = [ "d547a03032c9508d3f926616d93cfa5b", "bda4937be36282e4dcfd7f6bcfefbdb8" ]
        GADUtil.initializePositions(GADPositionExt.allCases)
        requestConfig()
        if AppUtil.shared.getIsRelease() {
            self.requestGADConfig()
        }
        checkNetwork()
        Analytics.logEvent("myFirstOpen", parameters: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(paidCallback(noti:)), name: .adPaid, object: nil)
        guard let url = connectionOptions.urlContexts.first?.url else {
            return
        }
        
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        goLaunchVC()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    
    func goTabbarVC() {
        window?.rootViewController = tabbarVC
    }
    
    func goLaunchVC() {
        window?.rootViewController = PLLaunchVC()
    }

    func checkNetwork() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied, !CacheUtil.shared.getNetworkEnable() {
                    if AppUtil.shared.getIsRelease() {
                        self.requestGADConfig()
                    }
                    self.requestConfig()
                    self.requestTrackingAuthorization()
                } else {
                    debugPrint("网络已断开")
                }
            }
        }

        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    func requestGADConfig() {
        GADUtil.share.requestConfig(false)
        GADPositionExt.allCases.forEach({
            GADUtil.share.load($0)
        })
    }
    
    func requestConfig() {
        Request<ConfigModel>.getConfigs { ret in
            if ret.bundleID == "com.bp.pulse" {
                if let config = ret.configs?.first(where: {$0.configKey == "isRelease"}) {
                    if config.configValue == "true" {
                        AppUtil.shared.setIsRelease(isRelease: true)
                    } else {
                        AppUtil.shared.setIsRelease(isRelease: false)
                    }
                    if AppUtil.shared.getIsRelease() {
                        self.requestGADConfig()
                    }
                }
            }
        } err: { obj, code in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.requestConfig()
            }
        }
    }
    
    func requestTrackingAuthorization() {
        let status = ATTrackingManager.trackingAuthorizationStatus
        switch status {
        case .notDetermined:
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                ATTrackingManager.requestTrackingAuthorization { results in
                    switch results {
                    case .authorized:
                        Settings.shared.isAdvertiserIDCollectionEnabled = true
                        Settings.shared.isAutoLogAppEventsEnabled = true
                    default:
                        break
                    }
                }
            }
        case .authorized:
            Settings.shared.isAdvertiserIDCollectionEnabled = true
            Settings.shared.isAutoLogAppEventsEnabled = true
        default:
            Settings.shared.isAdvertiserIDCollectionEnabled = false
        }
    }
    
    @objc func paidCallback(noti: Notification) {
        if let obj = noti.object as? GADBaseModel {
            self.price += obj.price
            if self.price > 0.01 {
                AppEvents.shared.logPurchase(amount: self.price, currency: obj.currency)
                self.price = 0
            }
        }
    }
}

