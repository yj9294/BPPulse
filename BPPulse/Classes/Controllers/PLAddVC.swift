//
//  PLAddVC.swift
//  BPPulse
//
//  Created by admin on 2025/9/17.
//

import UIKit
import IQKeyboardManagerSwift

class PLAddVC: PLBaseVC {

    var item: PLPulseModel = .init() {
        didSet {
            self.title = "Update"
            self.nextButton.setTitle("Update", for: .normal)
            self.reloadData()
        }
    }
    
    var datasource: [BPScene] = BPScene.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    lazy var sysInputView = {
        let inputView = PLInputView(style: .input)
        inputView.title = item.systolic.string
        inputView.goChangeHandle = { [weak self] sys in
            self?.item.systolic = sys
            self?.reloadData()
        }
        return inputView
    }()
    
    lazy var diaInputView = {
        let inputView = PLInputView(style: .input)
        inputView.title = item.diastolic.string
        inputView.goChangeHandle = { [weak self] dia in
            self?.item.diastolic = dia
            self?.reloadData()
        }
        return inputView
    }()
    
    lazy var pulseInputView = {
        let inputView = PLInputView(style: .input)
        inputView.title = item.pulse.string
        inputView.goChangeHandle = { [weak self] pul in
            self?.item.pulse = pul
            self?.reloadData()
        }
        return inputView
    }()
    
    lazy var dateInputView = {
        let inputView = PLInputView(style: .datePicker)
        inputView.title = item.createDate.dateTimeString(ofStyle: .short)
        inputView.goDatePickerHandle = { [weak self] date in
            self?.item.createDate = date
            self?.reloadData()
        }
        return inputView
    }()
    
    lazy var sceneCollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 12.0
        flowLayout.minimumInteritemSpacing = 12.0
        let width = (ScreenUtil.window().width - 16 * 2 - 12 * 2) / 3.0
        flowLayout.itemSize = CGSizeMake(width, 48 * ScreenUtil.scale())
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cellWithClass: PLSceneCell.self)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    lazy var nextButton = {
        let nextButton = UIButton()
        nextButton.setTitle("Save", for: .normal)
        nextButton.titleLabel?.font = .fontWithSize(size: 14, weigth: .medium)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.setBackgroundColor(color: .primary_1, forState: .normal)
        nextButton.layerCornerRadius = 4
        nextButton.addAction { [weak self] in
            self?.nextAction()
        }
        return nextButton
    }()
    
    lazy var homeStatusView = {
        let view = PLHomeStatusView()
        view.status = .normal
        return view
    }()
    
    func reloadData() {
        self.sysInputView.title = self.item.systolic.string
        self.diaInputView.title = self.item.diastolic.string
        self.pulseInputView.title = self.item.pulse.string
        self.dateInputView.title = self.item.createDate.dateString(ofStyle: .short)
        self.sceneCollectionView.reloadData()
        self.homeStatusView.status = self.item.status
    }
    
    
    override func setupUI() {
        super.setupUI()
        self.view.subviews.forEach({$0.removeFromSuperview()})
        
        let spacing = 16.0
        
        let width = (ScreenUtil.window().width - 16 * 2 - spacing) / 2.0
        let sysTitleLabel = UILabel()
        sysTitleLabel.text = "Systolic"
        sysTitleLabel.textColor =  .text_2
        sysTitleLabel.font = .fontWithSize(size: 14)
        view.addSubview(sysTitleLabel)
        sysTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(10)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(width)
        }
        
        let diaTitleLabel = UILabel()
        diaTitleLabel.textColor =  .text_2
        diaTitleLabel.text = "Diastolic"
        diaTitleLabel.font = .fontWithSize(size: 14)
        view.addSubview(diaTitleLabel)
        diaTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin).offset(10)
            make.left.equalTo(sysTitleLabel.snp.right).offset(spacing)
            make.width.equalTo(width)
        }
        
        view.addSubview(sysInputView)
        sysInputView.snp.makeConstraints { make in
            make.left.right.equalTo(sysTitleLabel)
            make.top.equalTo(sysTitleLabel.snp.bottom).offset(8 * scale)
            make.height.equalTo(48 * scale)
        }
        
        view.addSubview(diaInputView)
        diaInputView.snp.makeConstraints { make in
            make.left.right.equalTo(diaTitleLabel)
            make.centerY.equalTo(sysInputView)
            make.height.equalTo(48 * scale)
        }
        
        let pulseTitleLabel = UILabel()
        pulseTitleLabel.textColor =  .text_2
        pulseTitleLabel.text = "Pulse"
        pulseTitleLabel.font = .fontWithSize(size: 14)
        view.addSubview(pulseTitleLabel)
        pulseTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(sysInputView.snp.bottom).offset(24 * scale)
            make.left.right.equalToSuperview().inset(16)
        }
        
        view.addSubview(pulseInputView)
        pulseInputView.snp.makeConstraints { make in
            make.top.equalTo(pulseTitleLabel.snp.bottom).offset(8 * scale)
            make.left.right.equalTo(pulseTitleLabel)
            make.height.equalTo(48 * scale)
        }
        
        let logTitleLabel = UILabel()
        logTitleLabel.textColor =  .text_2
        logTitleLabel.text = "Record Time"
        logTitleLabel.font = .fontWithSize(size: 14)
        view.addSubview(logTitleLabel)
        logTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(pulseInputView.snp.bottom).offset(24 * scale)
            make.left.right.equalToSuperview().inset(16)
        }
        
        view.addSubview(dateInputView)
        dateInputView.snp.makeConstraints { make in
            make.left.right.equalTo(logTitleLabel)
            make.top.equalTo(logTitleLabel.snp.bottom).offset(8 * scale)
            make.height.equalTo(48 * scale)
        }
        
        let sceneTitleLabel = UILabel()
        sceneTitleLabel.textColor =  .text_2
        sceneTitleLabel.text = "Record Scene"
        sceneTitleLabel.font = .fontWithSize(size: 14)
        view.addSubview(sceneTitleLabel)
        sceneTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateInputView.snp.bottom).offset(24 * scale)
            make.left.right.equalToSuperview().inset(16)
        }
        
        view.addSubview(sceneCollectionView)
        sceneCollectionView.snp.makeConstraints { make in
            make.left.right.equalTo(sceneTitleLabel)
            make.top.equalTo(sceneTitleLabel.snp.bottom).offset(8 * scale)
            make.height.equalTo(48 * scale * 2 + 12)
        }
        
        view.addSubview(homeStatusView)
        homeStatusView.snp.makeConstraints { make in
            make.top.equalTo(sceneCollectionView.snp.bottom).offset(24 * scale)
            make.left.right.equalToSuperview().inset(16)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(48 * scale)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-10)
        }
        
    }
    
    func nextAction() {
        CacheUtil.shared.cachePulse(self.item)
        if self.title ==  "Update" {
            self.back()
            return
        }
        let vc = PLResultVC()
        vc.item = item
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension PLAddVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PLSceneCell.self, for: indexPath)
        cell.scene = datasource[indexPath.row]
        cell.isSelect = datasource[indexPath.row] == item.scene
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = datasource[indexPath.row]
        self.item.scene = item
        self.reloadData()
    }
}

class PLSceneCell: PLBaseCollectionCell {
    private lazy var icon = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    private lazy var titleLabel = {
        let label = UILabel()
        label.textColor = .text_1
        label.font = .fontWithSize(size: 12)
        return label
    }()
    override func setupUI() {
        super.setupUI()
        let view = UIView()
        addSubview(view)
        view.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        view.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.left.equalTo(icon.snp.right).offset(5)
            make.top.bottom.equalToSuperview()
        }
    }
    
    var scene: BPScene = .standard {
        didSet {
            icon.image = scene.icon?.withRenderingMode(.alwaysTemplate)
            titleLabel.text = scene.title
        }
    }
    
    var isSelect: Bool = false {
        didSet {
            self.layerCornerRadius = 4
            self.backgroundColor = isSelect ? .warnning_1_bg : .white
            self.layerBorderColor = isSelect ? .primary_1 : .border_1
            self.layerBorderWidth = 1
            icon.tintColor = isSelect ? .primary_1 : .text_1
            titleLabel.textColor = isSelect ? .primary_1 : .text_1
        }
    }
}
