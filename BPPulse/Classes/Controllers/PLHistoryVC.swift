//
//  PLHistoryVC.swift
//  Pulse
//
//  Created by admin on 2025/9/16.
//

import UIKit

class PLHistoryVC: PLBaseVC, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 8.0
        flowLayout.minimumInteritemSpacing = 12
        flowLayout.itemSize = CGSize(width: ScreenUtil.window().width - 32, height: 134 * scale)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(cellWithClass: PLHistoryCell.self)
        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withClass: PLHistoryHeaderCell.self)
        return collectionView
    }()
    
    lazy var emptryView = {
        let view = PLEmptyView()
        view.isHidden = true
        view.goHandle = { [weak self] in
            self?.addAction()
        }
        return view
    }()
    
    var datasource: [[PLPulseModel]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        let models = CacheUtil.shared.getPulseList()
        datasource = models.reduce(into: [[PLPulseModel]]()) { result, model in
            let dateStr = model.createDate.dateString(ofStyle: .medium)
            if var lastGroup = result.last, let lastDate = lastGroup.first?.createDate.dateString(ofStyle: .medium), lastDate == dateStr {
                lastGroup.append(model)
                result[result.count - 1] = lastGroup
            } else {
                result.append([model])
            }
        }
        collectionView.reloadData()
        if self.datasource.isEmpty {
            self.emptryView.isHidden = false
        } else {
            self.emptryView.isHidden = true
        }
    }
    
    func setupNavigationBar() {
        // 创建一个按钮
        let leftItem = UIBarButtonItem(title: "BP Pulse", style: .plain, target: self, action: nil)
        
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
            make.top.equalTo(view.snp.topMargin).offset(10)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        let addButton = UIButton()
        addButton.setImage(UIImage(named: "home_add"), for: .normal)
        addButton.addAction { [weak self] in
            self?.addAction()
        }
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-8)
        }
        
        view.addSubview(emptryView)
        emptryView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        datasource[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PLHistoryCell.self, for: indexPath)
        cell.item = datasource[indexPath.section][indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: ScreenUtil.window().width - 32, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withClass: PLHistoryHeaderCell.self, for: indexPath)
        cell.title = datasource[indexPath.section].first?.createDate.dateString(ofStyle: .medium)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = datasource[indexPath.section][indexPath.row]
        let vc = PLAddVC()
        vc.item = item
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc)
    }
    
    func addAction() {
        let vc = PLAddVC()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc)
    }
}

class PLHistoryHeaderCell: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel = {
        let label = UILabel()
        label.textColor = .text_3
        label.font = .fontWithSize(size: 14)
        return label
    }()
    
    func setupUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
    }
    
    var title: String? = nil {
        didSet {
            titleLabel.text = title
        }
    }
}

class PLHistoryCell: PLBaseCollectionCell {
    
    var item: PLPulseModel? = nil {
        didSet {
            guard let item = item else { return }
            sysdiaLabel.text = "\(item.systolic)/\(item.diastolic)"
            stateView.status = item.status
            pulseLabel.text = "Pulse:  \(item.pulse)"
            sceneView.scene = item.scene
            timeLabel.text = item.createDate.timeString(ofStyle: .short)
        }
    }
    
    private let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 12
        v.layer.masksToBounds = false
        
        // 阴影
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.1
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        v.layer.shadowRadius = 4
        return v
    }()
    
    lazy var sysdiaLabel = {
        let label = UILabel()
        label.textColor = .text_1
        label.font = .fontWithSize(size: 24, weigth: .medium)
        return label
    }()
    
    lazy var stateView = {
        let stateView = PLStatusView()
        stateView.layerCornerRadius = 8
        return stateView
    }()
    
    lazy var sceneView = {
        let sceneView = PLSceneView()
        sceneView.layerCornerRadius = 8
        return sceneView
    }()
    
    lazy var pulseLabel = {
        let label = UILabel()
        label.textColor = .text_3
        label.font = .fontWithSize(size: 14, weigth: .regular)
        label.text = "Pulse: ??"
        return label
    }()
    
    lazy var pulseUnitLabel = {
        let label = UILabel()
        label.textColor = .text_3
        label.font = .fontWithSize(size: 11, weigth: .regular)
        label.text = "bpm"
        return label
    }()
    
    lazy var timeLabel = {
        let label = UILabel()
        label.textColor = .text_3
        label.font = .fontWithSize(size: 12, weigth: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6 * scale)
            make.left.right.equalToSuperview().inset(16)
        }
        
        addSubview(sysdiaLabel)
        sysdiaLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(16 * scale)
            make.left.equalTo(containerView).offset(16)
            make.height.equalTo(32 * scale)
        }
        
        let unitLabel = UILabel()
        unitLabel.text = "mmHg"
        unitLabel.textColor = .text_3
        unitLabel.font = .fontWithSize(size: 14, weigth: .regular)
        addSubview(unitLabel)
        unitLabel.snp.makeConstraints { make in
            make.left.equalTo(sysdiaLabel.snp.right).offset(8)
            make.bottom.equalTo(sysdiaLabel).offset(-3 * scale)
            make.height.equalTo(20 * scale)
        }
        
        addSubview(stateView)
        stateView.snp.makeConstraints { make in
            make.top.equalTo(sysdiaLabel.snp.bottom).offset(8 * scale)
            make.left.equalTo(containerView).offset(16)
        }
        
        addSubview(pulseLabel)
        pulseLabel.snp.makeConstraints { make in
            make.centerY.equalTo(stateView)
            make.left.equalTo(stateView.snp.right).offset(16)
        }
        
        addSubview(pulseUnitLabel)
        pulseUnitLabel.snp.makeConstraints { make in
            make.bottom.equalTo(pulseLabel)
            make.left.equalTo(pulseLabel.snp.right).offset(4)
        }
        
        addSubview(sceneView)
        sceneView.snp.makeConstraints { make in
            make.left.equalTo(stateView)
            make.top.equalTo(stateView.snp.bottom).offset(12 * scale)
        }
        
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(sceneView)
            make.left.equalTo(sceneView.snp.right).offset(8)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
