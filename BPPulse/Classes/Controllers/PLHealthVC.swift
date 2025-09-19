//
//  PLVisitionVC.swift
//  Pulse
//
//  Created by admin on 2025/9/16.
//

import UIKit

class PLHealthVC: PLBaseVC {
    
    lazy var collectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: ScreenUtil.window().width - 32, height: 280)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cellWithClass: PLHealthCell.self)
        return collectionView
    }()
    
    var datasource: [PLHealthModel] = PLHealthModel.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 创建一个按钮
        let leftItem = UIBarButtonItem(title: "Health", style: .plain, target: self, action: nil)
        
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

    override func setupUI() {
        super.setupUI()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(10 * scale)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
}

extension PLHealthVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        datasource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PLHealthCell.self, for: indexPath)
        cell.item = datasource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = datasource[indexPath.row]
        let vc = PLHealthDetailVC()
        vc.item = item
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}


class PLHealthCell: PLBaseCollectionCell {
    var item: PLHealthModel? = nil {
        didSet {
            guard let item = item else { return }
            icon.image = item.bgIcon
            titleLabel.text = item.value
            subtitleLabel.text = item.title
        }
    }
    lazy var icon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text_1
        label.font = .fontWithSize(size: 18, weigth: .medium)
        label.numberOfLines = 0
        return label
    }()
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text_2
        label.font = .fontWithSize(size: 14)
        label.numberOfLines = 0
        return label
    }()
    override func setupUI() {
        super.setupUI()
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
        }
        addSubview(icon)
        icon.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        let arrow = UIImageView(image: UIImage(named: "arrow"))
        addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-16)
        }
    }
}
