//
//  PLResultVC.swift
//  BPPulse
//
//  Created by admin on 2025/9/18.
//

import UIKit

class PLResultVC: PLBaseVC {
    
    private var willAppear = false
    private var impressDate = Date().addingTimeInterval(-11)
    private lazy var adView: GADNativeView = {
        let adView = GADNativeView(.big)
        adView.layer.cornerRadius = 8
        adView.layer.masksToBounds = true
        return adView
    }()
    
    var item: PLPulseModel = .init() {
        didSet {
            cardView.item = item
        }
    }

    var datasource: [PLHealthModel] = [.heart, .eat, .exercise, .protect]
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(nativeADLoad), name: .nativeUpdate, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        willAppear = true
        GADUtil.share.load(GADPositionExt.resultNative)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        willAppear = false
        GADUtil.share.disappear(GADPositionExt.resultNative)
    }

    override func back() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    lazy var cardView = {
        let view = PLResultCardView()
        return view
    }()
    
    lazy var healthCollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 16.0
        flowLayout.minimumInteritemSpacing = 12.0
        let width = (ScreenUtil.window().width - 16 * 2 - 12 ) / 2.0
        flowLayout.itemSize = CGSizeMake(width, 55 * ScreenUtil.scale())
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cellWithClass: PLResultHealthCell.self)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
//    lazy var nextButton = {
//        let nextButton = UIButton()
//        nextButton.setTitle("Done", for: .normal)
//        nextButton.titleLabel?.font = .fontWithSize(size: 14, weigth: .medium)
//        nextButton.setTitleColor(.white, for: .normal)
//        nextButton.addAction { [weak self] in
//            self?.back()
//        }
//        nextButton.isHidden = true
//        nextButton.setBackgroundColor(color: .primary_1, forState: .normal)
//        nextButton.layerCornerRadius = 4
//        return nextButton
//    }()
    
    override func setupUI() {
        super.setupUI()

        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16 * scale
        stackView.alignment = .fill
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }

        let icon = UIImageView(image: UIImage(named: "result_icon"))
        icon.contentMode = .scaleAspectFit
        stackView.addArrangedSubview(icon)
        icon.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(1) // Ensures icon is visible
            make.top.equalToSuperview().offset(10 * scale)
            make.centerX.equalToSuperview()
        }

        let titleLabel = UILabel()
        titleLabel.text = "Record added successfully"
        titleLabel.font = .fontWithSize(size: 18)
        titleLabel.textColor = .text_1
        titleLabel.textAlignment = .center
        stackView.addArrangedSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(1)
            make.centerX.equalToSuperview()
        }

        stackView.setCustomSpacing(26 * scale, after: titleLabel)

        stackView.addArrangedSubview(cardView)

        let forYouLabel = UILabel()
        forYouLabel.text = "For you"
        forYouLabel.textColor = .text_1
        forYouLabel.font = .fontWithSize(size: 18, weigth: .medium)
        stackView.addArrangedSubview(forYouLabel)
        forYouLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
        }

        stackView.setCustomSpacing(16 * scale, after: forYouLabel)

        stackView.addArrangedSubview(healthCollectionView)
        healthCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(55 * scale * 2 + 16)
        }

        stackView.addArrangedSubview(adView)
        adView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(0).priority(.high)
        }

        // Spacer to push content up if not enough content
//        let spacer = UIView()
//        spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
//        stackView.addArrangedSubview(spacer)

        // Add nextButton to stackView as last arranged subview
//        stackView.addArrangedSubview(nextButton)
//        nextButton.snp.makeConstraints { make in
//            make.left.right.equalToSuperview().inset(16)
//            make.height.equalTo(48 * scale)
//        }
    }

}

extension PLResultVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: PLResultHealthCell.self, for: indexPath)
        cell.item = datasource[indexPath.row]
        cell.layerCornerRadius = 12
        cell.layerBorderColor = .border_1
        cell.layerBorderWidth = 1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = datasource[indexPath.row]
        let vc = PLHealthDetailVC()
        vc.item = item
        navigationController?.pushViewController(vc)
    }
}

class PLResultHealthCell: PLBaseCollectionCell {
    
    private lazy var icon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var titleLabel = {
        let label = UILabel()
        label.font = .fontWithSize(size: 14)
        label.textColor = .text_1
        return label
    }()
    var item: PLHealthModel? = nil {
        didSet {
            guard let item = item else { return }
            icon.image = item.icon
            titleLabel.text = item.value
        }
    }
    override func setupUI() {
        super.setupUI()
        addSubview(icon)
        icon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(icon.snp.right).offset(8)
        }
    }
}

extension PLResultVC {
    @objc func nativeADLoad(noti: Notification) {
        if let position = noti.userInfo?["position"] as? GADPosition, position.rawValue == GADPositionExt.resultNative.rawValue {
            if let ad = noti.object as? GADNativeModel {
                if willAppear {
                    if  Date().timeIntervalSince1970 - impressDate.timeIntervalSince1970 > 10 {
                        adView.nativeAd = ad.nativeAd
                        impressDate = Date()
                        if adView.superview != nil {
                            adView.snp.remakeConstraints { make in
                                make.top.equalTo(healthCollectionView.snp.bottom).offset(16 * scale)
                                make.left.right.equalToSuperview().inset(16)
                                make.height.equalTo(180).priority(.high)
                            }
                            view.layoutIfNeeded()
                        }
                        return
                    } else {
                        NSLog("[ad] (\(position)) 10显示间隔 ")
                    }
                }
            }
            adView.nativeAd = nil
            view.addSubview(adView)
            adView.snp.remakeConstraints { make in
                make.top.equalTo(healthCollectionView.snp.bottom).offset(16 * scale)
                make.left.right.equalToSuperview().inset(16)
                make.height.equalTo(0).priority(.high)
            }
        }
    }
}

class PLResultCardView: PLBaseView {
    var item: PLPulseModel? = nil {
        didSet {
            guard let item = item else { return }
            sysdiaLabel.text = "\(item.systolic)/\(item.diastolic)"
            pulseLabel.text = item.pulse.string
            timeLabel.text = item.createDate.timeString(ofStyle: .short)
            dateLabel.text = item.createDate.dateString(ofStyle: .medium)
            sceneIcon.image = item.scene.icon
            sceneLabel.text = item.scene.title
            statusView.backgroundColor = item.status.bgColor
            statusLabel.text = item.status.title
            statusLabel.textColor = item.status.color
            questionView.tintColor = item.status.color
        }
    }
    private let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 12
        v.layer.masksToBounds = false
        v.layerBorderColor = .border_1
        v.layerBorderWidth = 1
        
        // 阴影
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.1
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        v.layer.shadowRadius = 4
        return v
    }()
    
    private lazy var sysdiaLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text_1
        label.font = .fontWithSize(size: 24, weigth: .medium)
        return label
    }()
    
    private lazy var pulseLabel = {
        let label = UILabel()
        label.textColor = .text_2
        label.font = .fontWithSize(size: 14)
        return label
    }()
    
    private lazy var timeLabel = {
        let label = UILabel()
        label.textColor = .text_2
        label.font = .fontWithSize(size: 14)
        return label
    }()
    
    private lazy var dateLabel = {
        let label = UILabel()
        label.textColor = .text_2
        label.font = .fontWithSize(size: 14)
        return label
    }()
    
    private lazy var sceneIcon = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var sceneLabel = {
        let label = UILabel()
        label.textColor = .text_2
        label.font = .fontWithSize(size: 14)
        return label
    }()
    
    private lazy var statusView = {
        let view = UIView()
        view.layerCornerRadius = 8
        return view
    }()
    
    private lazy var  statusLabel = {
        let label = UILabel()
        label.font = .fontWithSize(size: 12)
        return label
    }()
    
    private lazy var questionView = {
        let view = UIImageView(image: UIImage(named: "status_q")?.withRenderingMode(.alwaysOriginal))
        return view
    }()
    
    override func setupUI() {
        super.setupUI()
        
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8 * scale)
        }
        
        addSubview(sysdiaLabel)
        sysdiaLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(16 * scale)
            make.left.equalTo(containerView).offset(16)
            make.height.equalTo(32 * scale)
        }
        
        let sysdiaUnitLabel = UILabel()
        sysdiaUnitLabel.text = "mmHg"
        sysdiaUnitLabel.textColor = .text_2
        sysdiaUnitLabel.font = .fontWithSize(size: 14)
        addSubview(sysdiaUnitLabel)
        sysdiaUnitLabel.snp.makeConstraints { make in
            make.bottom.equalTo(sysdiaLabel).offset(-3)
            make.left.equalTo(sysdiaLabel.snp.right).offset(8)
        }
        
        let pulseIcon = UIImageView(image: UIImage(named: "result_pulse"))
        addSubview(pulseIcon)
        pulseIcon.snp.makeConstraints { make in
            make.left.equalTo(sysdiaLabel)
            make.height.equalTo(14 * scale)
        }
        addSubview(pulseLabel)
        pulseLabel.snp.makeConstraints { make in
            make.top.equalTo(sysdiaUnitLabel.snp.bottom).offset(12 * scale)
            make.height.equalTo(20 * scale)
            make.centerY.equalTo(pulseIcon)
            make.left.equalTo(pulseIcon.snp.right).offset(4)
        }
        
        let timeIcon = UIImageView(image: UIImage(named: "result_time"))
        addSubview(timeIcon)
        timeIcon.snp.makeConstraints { make in
            make.centerY.equalTo(pulseIcon)
            make.left.equalTo(pulseLabel.snp.right).offset(16)
            make.height.equalTo(14 * scale)
        }
        
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(pulseIcon)
            make.left.equalTo(timeIcon.snp.right).offset(4)
        }
        
        let dateIcon = UIImageView(image: UIImage(named: "result_date"))
        addSubview(dateIcon)
        dateIcon.snp.makeConstraints { make in
            make.centerY.equalTo(pulseIcon)
            make.left.equalTo(timeLabel.snp.right).offset(16)
            make.height.equalTo(14 * scale)
        }
        
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(pulseIcon)
            make.left.equalTo(dateIcon.snp.right).offset(4)
        }
        
        addSubview(sceneIcon)
        sceneIcon.snp.makeConstraints { make in
            make.left.equalTo(pulseIcon)
            make.width.height.equalTo(14 * scale)
        }
        
        addSubview(sceneLabel)
        sceneLabel.snp.makeConstraints { make in
            make.centerY.equalTo(sceneIcon)
            make.top.equalTo(pulseIcon.snp.bottom).offset(8 * scale)
            make.height.equalTo(20 * scale)
            make.left.equalTo(sceneIcon.snp.right).offset(4)
            make.bottom.equalTo(containerView).offset(-16 * scale)
        }
        
        addSubview(statusView)
        statusView.snp.makeConstraints { make in
            make.top.right.equalTo(containerView).inset(16)
        }
        
        statusView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4 * scale)
            make.left.equalToSuperview().offset(8)
        }
        
        statusView.addSubview(questionView)
        questionView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(statusLabel.snp.right).offset(4)
            make.width.height.equalTo(16)
            make.right.equalToSuperview().offset(-8)
        }
        
        let button = UIButton()
        statusView.addSubview(button)
        button.addAction { [weak self] in
            self?.goIntroduce()
        }
        statusView.addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func goIntroduce() {
        if let url = URL(string: AppUtil.shared.introduceURL) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
}
