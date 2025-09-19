//
//  ScreenUtil.swift
//  Pulse
//
//  Created by admin on 2025/9/16.
//

import UIKit

class ScreenUtil: NSObject {
   
    static var navigationBarHeight = 44.0
    static var tabbarHeight = 56.0
    
    static var sceneDelegate: SceneDelegate? = nil
    
    static func scale() -> CGFloat {
        let h = ScreenUtil.window().safeAreaInsets.top + ScreenUtil.window().safeAreaInsets.bottom + ScreenUtil.navigationBarHeight
        return  (ScreenUtil.window().height - h) / (812.0 -  (88.0 + 34))
    }
    
    /// 当前的window
    static func window() -> UIWindow {
        if !Thread.current.isMainThread {
            debugPrint("------------")
        }
        return sceneDelegate?.window ?? .init()
    }
    
    static func textViewDefaultHeight() -> CGFloat {
        let textView = UITextView()
        let height = textView.sizeThatFits(CGSize(width: .max, height: .max)).height
        return height
    }

   /// 获取顶部控制器 无要求
   static func topViewController() -> UIViewController? {
       var window = (UIApplication.shared.connectedScenes.filter({$0 is UIWindowScene}).first as? UIWindowScene)?.windows.first
       // 是否为当前显示的window
       if ((window?.windowLevel.rawValue) != 0) {
           let windows = (UIApplication.shared.connectedScenes.filter({$0 is UIWindowScene}).first as? UIWindowScene)?.windows ?? []
           for  windowTemp in windows {
               if windowTemp.windowLevel.rawValue == 0{
                   window = windowTemp
                   break
               }
           }
       }

       let vc = window?.rootViewController
       return getTopVC(withCurrentVC: vc)
   }
   
   private static func getTopVC(withCurrentVC VC:UIViewController?) -> UIViewController? {
       if VC == nil {
           return nil
       }
       if let presentVC = VC?.presentedViewController {
           //modal出来的 控制器
           return getTopVC(withCurrentVC: presentVC)
       }else if let tabVC = VC as? UITabBarController {
           // tabBar 的跟控制器
           if let selectVC = tabVC.selectedViewController {
               return getTopVC(withCurrentVC: selectVC)
           }
           return nil
       } else if let naiVC = VC as? UINavigationController {
           // 控制器是 nav
           return getTopVC(withCurrentVC:naiVC.visibleViewController)
       } else {
           // 返回顶控制器
           return VC
       }
   }

}
