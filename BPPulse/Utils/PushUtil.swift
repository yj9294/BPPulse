//
//  PushUtil.swift
//  BPPulse
//
//  Created by admin on 2025/9/17.
//

import UIKit

import UIKit
import UserNotifications

class PushUtil: NSObject {

    static let shared = PushUtil()

    var fcmToken: String?

    override init() {
        super.init()
    }

    func registerRemoteNotification(completion: (()->Void)? = nil) {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (_, error) in
            if let error = error {
                print(error)
            } else {
                completion?()
            }
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
}


// MARK: observer
extension PushUtil {
    private func delayCheckToken() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 6) {
            print("-------- notify: delay check token")
        }
    }
}


extension PushUtil: UNUserNotificationCenterDelegate {
    
    /// 前台接收 push（仅针对邀请成功消息）
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        guard let aps = notification.request.content.userInfo["aps"] as? Dictionary<String, Any> else {
            return
        }
        if let deepLink = aps["deep_link"] as? String {
            guard let components = NSURLComponents(string: deepLink) else {
                print("error: deepLink url 无效")
                return
            }
            guard let path = components.path else { return }
            if path != "/invite" { return }
            if components.queryItems?.filter({$0.name == "page"}).first?.value != "congratulationsPage" { return }
            
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let delegate = scene.delegate as? SceneDelegate {
//                delegate.openAppLink(with: deepLink)
            }
        }
        
    }

    /// 后台点击 push noti
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard let aps = response.notification.request.content.userInfo["aps"] as? Dictionary<String, Any> else {
            completionHandler()
            return
        }
        // 打开深链接
        if let deepLink = aps["deep_link"] as? String {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let delegate = scene.delegate as? SceneDelegate {
//                delegate.openAppLink(with: deepLink)
            }
        }

        completionHandler()
    }
}

private extension Data {

    var deviceTokenString: String {
        var token = ""
        let bytes = [UInt8](self)
        for item in bytes {
            token += String(format: "%02x", item & 0x000000FF)
        }
        return token
    }
}

private extension String {
    var systemLanguageString: String {
        switch self {
        case let languageString where languageString.hasPrefix("en"):
            return "en"
        case let languageString where languageString.hasPrefix("de"):
            return "de"
        case let languageString where languageString.hasPrefix("ja"):
            return "ja"
        case let languageString where languageString.hasPrefix("es"):
            return "es"
        case let languageString where languageString.hasPrefix("pt"):
            return "pt"
        case let languageString where languageString.hasPrefix("zh"):
            return "zh-TW"
        default:
            return "en"
        }
    }
}
