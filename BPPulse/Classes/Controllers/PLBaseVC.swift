//
//  PLBaseVC.swift
//  Pulse
//
//  Created by admin on 2025/9/16.
//

import UIKit
import SnapKit
import IQKeyboardManagerSwift

class PLBaseVC: UIViewController {
    lazy var debouncer = Debouncer(interval: 1)
    ///
    let scale = ScreenUtil.scale()
    
    lazy var backItem = {
        let button = UIBarButtonItem(image: UIImage(named: "common_back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(back))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.setupUI()
        self.commonInit()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        debugPrint("\(self.classForCoder) deinit 🔥🔥🔥")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appearce = UINavigationBarAppearance()
        appearce.backgroundColor = .white
        appearce.shadowColor = .white
        
        navigationItem.compactAppearance = appearce
        navigationItem.standardAppearance = appearce
        navigationItem.scrollEdgeAppearance = appearce
        
        if (navigationController?.viewControllers.count ?? 0) > 1 {
            navigationItem.leftBarButtonItem = backItem
        }
    }

}

extension PLBaseVC {
    @objc func back() {
        if (self.navigationController?.viewControllers.count ?? 0) > 1 {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true)
        }
    }
    
    @objc func setupUI() {
    }
    
    @objc func commonInit() {
    }
}
