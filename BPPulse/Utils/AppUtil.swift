//
//  AppUtil.swift
//  Pulse
//
//  Created by admin on 2025/9/16.
//

import UIKit
import SwifterSwift

class AppUtil: NSObject {
    
    static let shared = AppUtil()

    /// 当前模式
    var isDark: Bool {
        UITraitCollection.current.userInterfaceStyle == .dark
    }
    
    /// 刘海系列
    var isIPhoneX: Bool {
        ScreenUtil.window().frame.size.height > 667.0
    }
    
    
    /// 包名
    var appBundleID: String = Bundle.main.bundleIdentifier ?? "ai.ease"
    /// 应用名称
    var appName: String = (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String) ?? "AIEASE"
    /// 应用版本
    var appVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0.0"
    /// 应用小版本
    var appBuild: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "1"

    /// 触控反馈
    static func feedbackGenerator(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: style)
        feedbackGenerator.prepare() // 预加载震动资源，响应更快
        feedbackGenerator.impactOccurred() // 触发震动
    }
}

extension String {
    func textHeightFromTextString(textWidth: CGFloat, font: UIFont) -> CGFloat {
        var dict: NSDictionary = NSDictionary()
        dict = NSDictionary(object: font,forKey: NSAttributedString.Key.font as NSCopying)
        let rect: CGRect = (self as NSString).boundingRect(with: CGSize(width: textWidth,height: CGFloat(MAXFLOAT)), options: [NSStringDrawingOptions.truncatesLastVisibleLine, NSStringDrawingOptions.usesFontLeading,NSStringDrawingOptions.usesLineFragmentOrigin],attributes: dict as? [NSAttributedString.Key : Any] ,context: nil)
        return rect.size.height
    }
    
    func textwidthFromTextString(textHeight: CGFloat, font: UIFont) -> CGFloat {
        var dict: NSDictionary = NSDictionary()
        dict = NSDictionary(object: font,forKey: NSAttributedString.Key.font as NSCopying)
        let rect: CGRect = (self as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: textHeight), options: [NSStringDrawingOptions.truncatesLastVisibleLine, NSStringDrawingOptions.usesFontLeading,NSStringDrawingOptions.usesLineFragmentOrigin],attributes: dict as? [NSAttributedString.Key : Any] ,context: nil)
        return rect.size.width
    }
}

// UIButton 的扩展
extension UIButton {
    
    // 定义一个闭包类型
    typealias ButtonAction = () -> Void
    
    // 存储闭包
    private var actionClosure: ButtonAction? {
        get {
            return objc_getAssociatedObject(self, AssociatedKeys.actionKey) as? ButtonAction
        }
        set {
            objc_setAssociatedObject(self, AssociatedKeys.actionKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    // 创建一个方便调用的函数来设置按钮点击事件的闭包
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, action: @escaping ButtonAction) {
        self.actionClosure = action
        self.addTarget(self, action: #selector(buttonTapped), for: controlEvents)
    }
    
    // 按钮点击时的回调方法
    @objc private func buttonTapped() {
        actionClosure?()
    }
}

struct AssociatedKeys {
    static let actionKey = UnsafeRawPointer(bitPattern: "actionKey".hashValue)!
}

extension String {
    func dateFromDateTimeString(ofStyle style: DateFormatter.Style) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = style
        formatter.timeStyle = style
        return formatter.date(from: self)
    }
}
