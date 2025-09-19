//
//  PLHomeContentCell.swift
//  BPPulse
//
//  Created by admin on 2025/9/17.
//

import UIKit

class PLHomeContentView: PLBaseView {

    var item: PLPulseModel? = nil {
        didSet {
            guard let item = item else { return }
            sysLabel.text = item.systolic.string
            diaLabel.text = item.diastolic.string
            pulseLabel.text = "Pulse: \(item.pulse)"
            stateView.status = item.status
            timeLabel.text = item.createDate.dateTimeString      (ofStyle: .short)
            sceneView.scene = item.scene
        }
    }
    
    lazy var sysLabel = {
        let label = UILabel()
        label.textColor = .text_1
        label.font = .fontWithSize(size: 30, weigth: .medium)
        label.text = "???"
        return label
    }()
    
    lazy var diaLabel = {
        let label = UILabel()
        label.textColor = .text_1
        label.font = .fontWithSize(size: 30, weigth: .medium)
        label.text = "??"
        return label
    }()
    
    lazy var stateView = {
        let stateView = PLStatusView()
        stateView.layerCornerRadius = 8
        return stateView
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
    
    lazy var sceneView = {
        let sceneLabel = PLSceneView()
        stateView.layerCornerRadius = 8
        return sceneLabel
    }()
    
    lazy var timeLabel = {
        let sceneLabel = UILabel()
        sceneLabel.textColor = .text_3
        sceneLabel.font = .fontWithSize(size: 12)
        sceneLabel.text = Date().dateTimeString(ofStyle: .short)
        return sceneLabel
    }()
    
    override func setupUI() {
        super.setupUI()
        
        self.layerCornerRadius = 16
        
        let contentView = UIImageView(image: UIImage(named: "home_cell"))
        contentView.contentMode = .scaleAspectFill
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(168 * scale)
        }
        
        addSubview(sysLabel)
        sysLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24 * scale)
            make.height.equalTo(36 * scale)
            make.left.equalToSuperview().offset(24)
        }
        
        let label = UILabel()
        label.text = "/"
        label.font = .fontWithSize(size: 14, weigth: .regular)
        label.textColor = .text_3
        addSubview(label)
        label.snp.makeConstraints { make in
            make.bottom.equalTo(sysLabel).offset(-3)
            make.left.equalTo(sysLabel.snp.right).offset(8)
        }
        
        addSubview(diaLabel)
        diaLabel.snp.makeConstraints { make in
            make.centerY.equalTo(sysLabel)
            make.left.equalTo(label.snp.right).offset(8)
        }
        
        let label1 = UILabel()
        label1.text = "mmHg"
        label1.textColor = .text_3
        label1.font = .fontWithSize(size: 14, weigth: .regular)
        addSubview(label1)
        label1.snp.makeConstraints { make in
            make.left.equalTo(diaLabel.snp.right).offset(8)
            make.bottom.equalTo(sysLabel).offset(-3)
        }
        

        addSubview(stateView)
        stateView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(sysLabel.snp.bottom).offset(16 * scale)
        }

        
        addSubview(pulseLabel)
        pulseLabel.snp.makeConstraints { make in
            make.centerY.equalTo(stateView)
            make.left.equalTo(stateView.snp.right).offset(12)
        }
        
        addSubview(pulseUnitLabel)
        pulseUnitLabel.snp.makeConstraints { make in
            make.bottom.equalTo(pulseLabel)
            make.left.equalTo(pulseLabel.snp.right).offset(4)
        }
        
        addSubview(sceneView)
        sceneView.snp.makeConstraints { make in
            make.top.equalTo(stateView.snp.bottom).offset(16 * scale)
            make.left.equalTo(stateView)
        }
        
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(sceneView)
            make.left.equalTo(sceneView.snp.right).offset(16)
        }
    }
}
