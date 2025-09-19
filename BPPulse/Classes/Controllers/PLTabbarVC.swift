//
//  PLTabbarVC.swift
//  Pulse
//
//  Created by admin on 2025/9/16.
//

import UIKit

class PLTabbarVC: UITabBarController {

    var datasource: [PLTabbarModel] = [.home, .history, .health, .settings]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = datasource.map({ getChildVC($0) })
        
        tabBar.tintColor = .primary_1
        tabBar.unselectedItemTintColor = .text_4
    }

    func getChildVC(_ item: PLTabbarModel) -> PLNavigationController {
        let vc = item.vc
        vc.tabBarItem = UITabBarItem(title: item.title, image: item.icon, selectedImage: item.icon)
        let navigationController = PLNavigationController(rootViewController: vc)
        return navigationController
    }
}
