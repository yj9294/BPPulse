//
//  PLSettingsVC.swift
//  Pulse
//
//  Created by admin on 2025/9/16.
//

import UIKit

class PLSettingsVC: PLBaseVC, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    private let settings = PLSettingsModel.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(10 * scale)
            make.left.right.bottom.equalToSuperview()
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .border_1
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let leftItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: nil)

        // 设置字体和颜色
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .black),
            .foregroundColor: UIColor.primary_1
        ]
        leftItem.setTitleTextAttributes(attributes, for: .normal)
        leftItem.setTitleTextAttributes(attributes, for: .highlighted)

        // 设置到 navigationItem
        navigationItem.leftBarButtonItem = leftItem
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let model = settings[indexPath.row]
        cell.textLabel?.text = model.title
        cell.imageView?.image = model.icon
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.textLabel?.font = .fontWithSize(size: 16)
        cell.textLabel?.textColor = .text_1
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = settings[indexPath.row]
        switch item {
        case .about:
            let vc = PLAboutUsVC()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc)
        case .privacy:
            let vc = PLPrivacyVC()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc)
        case .feedback:
            let vc = PLFeedbackVC()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        72.0
    }
    
}
