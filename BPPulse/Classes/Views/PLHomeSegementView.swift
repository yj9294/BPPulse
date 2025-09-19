//
//  PLHomeSegementView.swift
//  BPPulse
//
//  Created by admin on 2025/9/17.
//

import UIKit

class PLHomeSegementView: PLBaseView, UICollectionViewDataSource, UICollectionViewDelegate {

    var datasource: [PLHomeFilterModel] = [.newest, .average, .twodays]
    var item: PLHomeFilterModel = .newest
    var didSelectHandle: ((PLHomeFilterModel)->Void)? = nil
    
    lazy var collectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 80 * scale, height: 26.5 * scale)
        flowLayout.minimumLineSpacing = 16.0
        flowLayout.minimumInteritemSpacing = 16.0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(cellWithClass: PLHomeSegementCell.self)
        return collectionView
    }()
    
    lazy var lineView = {
        let view = UIView()
        view.backgroundColor = .primary_1
        view.layerCornerRadius = 1
        return view
    }()
    
    override func setupUI() {
        super.setupUI()
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(26.5 * scale)
        }
        addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.height.equalTo(2)
            make.width.equalTo(80 * scale)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PLHomeSegementCell.self, for: indexPath)
        cell.item = datasource[indexPath.row]
        cell.isSelect = datasource[indexPath.row] == item
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = datasource[indexPath.row]
        self.item = item
        didSelectHandle?(item)
        self.lineView.snp.remakeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
            make.width.equalTo(80 * scale)
            make.left.equalToSuperview().offset( Double(indexPath.row) * ( 16 + 80.0 * scale))
        }
        UIView.animate(withDuration: 0.25) { [self] in
            self.layoutIfNeeded()
        } completion: { _ in
            collectionView.reloadData()
        }
    }
}

class PLHomeSegementCell: PLBaseCollectionCell {
    
    lazy var titleLabel = {
        let label = UILabel()
        label.font = .fontWithSize(size: 11.0, weigth: .medium)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    override func setupUI() {
        super.setupUI()
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    var item: PLHomeFilterModel? = nil {
        didSet {
            titleLabel.text = item?.rawValue
        }
    }
    
    var isSelect: Bool  = false {
        didSet {
            titleLabel.textColor = isSelect ? .primary_1 : .text_4
        }
    }
}
