//
//  PLNavigationController.swift
//  Pulse
//
//  Created by admin on 2025/9/16.
//

import UIKit

class PLNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
    }
    
    func configNavigationBar() {
        let titleTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.text_1,
                                                                  .font: UIFont.fontWithSize(size: 18, weigth: .semibold)]
        if #available(iOS 15.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.backgroundColor = UIColor.clear
            navBarAppearance.backgroundEffect = nil
            navBarAppearance.shadowColor = nil
            navBarAppearance.titleTextAttributes = titleTextAttributes
            navigationBar.scrollEdgeAppearance = navBarAppearance
            navigationBar.standardAppearance = navBarAppearance
        } else {
            navigationBar.titleTextAttributes = titleTextAttributes
            navigationBar.barTintColor = .clear
            navigationBar.isTranslucent = true
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
        }
    }

}
