//
//  PLAboutUsVC.swift
//  BPPulse
//
//  Created by admin on 2025/9/19.
//

import UIKit

class PLAboutUsVC: PLBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "About Us"
    }
    
    override func setupUI() {
        super.setupUI()

        view.backgroundColor = .white

        // ScrollView and contentView
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        // Logo
        let logoImageView = UIImageView(image: UIImage(named: "launch_icon"))
        logoImageView.contentMode = .scaleAspectFit
        contentView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }

        // App Name
        let appNameLabel = UILabel()
        appNameLabel.text = "BP Pulse"
        appNameLabel.font = .fontWithSize(size: 20, weigth: .medium)
        appNameLabel.textColor = .primary_1
        appNameLabel.textAlignment = .center
        contentView.addSubview(appNameLabel)
        appNameLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }

        // Version
        let versionLabel = UILabel()
        versionLabel.text = "Version 1.0.0"
        versionLabel.font = .fontWithSize(size: 14.0)
        versionLabel.textColor = .text_3
        versionLabel.textAlignment = .center
        contentView.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { make in
            make.top.equalTo(appNameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }

        // Mission Container
        let missionContainer = UIView()
        missionContainer.backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 1.0, alpha: 1.0)
        missionContainer.layer.cornerRadius = 16
        contentView.addSubview(missionContainer)
        missionContainer.snp.makeConstraints { make in
            make.top.equalTo(versionLabel.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }

        let missionIcon = UIImageView(image: UIImage(named: "about_our"))
        missionIcon.contentMode = .scaleAspectFit
        missionContainer.addSubview(missionIcon)
        missionIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(28)
        }

        let missionTitleLabel = UILabel()
        missionTitleLabel.text = "Our Mission"
        missionTitleLabel.font = .fontWithSize(size: 16, weigth: .medium)
        missionTitleLabel.textColor = .text_1
        missionContainer.addSubview(missionTitleLabel)
        missionTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(missionIcon)
            make.left.equalTo(missionIcon.snp.right).offset(12)
            make.right.lessThanOrEqualToSuperview().offset(-20)
        }

        let missionDescLabel = UILabel()
        missionDescLabel.text = "We are committed to providing professional and convenient blood pressure monitoring and health management services, helping everyone better understand and manage their health."
        missionDescLabel.font = .fontWithSize(size: 14, weigth: .regular)
        missionDescLabel.textColor = .text_2
        missionDescLabel.numberOfLines = 0
        missionContainer.addSubview(missionDescLabel)
        missionDescLabel.snp.makeConstraints { make in
            make.top.equalTo(missionIcon.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }

        // Commitment Container
        let commitmentContainer = UIView()
        commitmentContainer.backgroundColor = UIColor(red: 0.97, green: 0.98, blue: 1.0, alpha: 1.0)
        commitmentContainer.layer.cornerRadius = 16
        contentView.addSubview(commitmentContainer)
        commitmentContainer.snp.makeConstraints { make in
            make.top.equalTo(missionContainer.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }

        let commitmentIcon = UIImageView(image: UIImage(named: "about_commitment"))
        commitmentIcon.contentMode = .scaleAspectFit
        commitmentContainer.addSubview(commitmentIcon)
        commitmentIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(28)
        }

        let commitmentTitleLabel = UILabel()
        commitmentTitleLabel.text = "Our Commitments"
        commitmentTitleLabel.font = .fontWithSize(size: 16, weigth: .medium)
        commitmentTitleLabel.textColor = .text_1
        commitmentContainer.addSubview(commitmentTitleLabel)
        commitmentTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(commitmentIcon)
            make.left.equalTo(commitmentIcon.snp.right).offset(12)
            make.right.lessThanOrEqualToSuperview().offset(-20)
        }

        // Commitment Items Enum
        enum CommitmentItem: CaseIterable {
            case security, realtime, analytics, service
            var iconName: String {
                switch self {
                case .security: return "about_safe"
                case .realtime: return "about_realtime"
                case .analytics: return "about_analytics"
                case .service: return "about_services"
                }
            }
            var title: String {
                switch self {
                case .security: return "Data Security"
                case .realtime: return "Real-time Monitoring"
                case .analytics: return "Data Analytics"
                case .service: return "Customer Service"
                }
            }
            var desc: String {
                switch self {
                case .security: return "Strictly protect user privacy and data security."
                case .realtime: return "Provide 24/7 health data tracking."
                case .analytics: return "Professional health data analysis reports."
                case .service: return "Timely user feedback and support."
                }
            }
        }

        // Grid of 2x2 Commitment Items
        let itemsStack = UIStackView()
        itemsStack.axis = .vertical
        itemsStack.spacing = 16
        itemsStack.distribution = .fillEqually
        commitmentContainer.addSubview(itemsStack)
        itemsStack.snp.makeConstraints { make in
            make.top.equalTo(commitmentIcon.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-20)
        }

        let allItems = Array(CommitmentItem.allCases)
        for row in 0..<2 {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 16
            rowStack.distribution = .fillEqually
            for col in 0..<2 {
                let idx = row * 2 + col
                if idx < allItems.count {
                    let item = allItems[idx]
                    let itemBackgrounView = UIView()
                    itemBackgrounView.backgroundColor = .bg_6
                    itemBackgrounView.layerBorderColor = .border_1
                    itemBackgrounView.layerBorderWidth = 1
                    itemBackgrounView.layerCornerRadius = 8
                    
                    let itemView = UIView()
                    itemBackgrounView.addSubview(itemView)
                    itemView.snp.makeConstraints { make in
                        make.edges.equalToSuperview().inset(16)
                    }

                    let icon = UIImageView(image: UIImage(named: item.iconName))
                    icon.contentMode = .scaleAspectFit
                    itemView.addSubview(icon)
                    icon.snp.makeConstraints { make in
                        make.top.equalToSuperview()
                        make.left.equalToSuperview()
                        make.width.height.equalTo(14)
                    }
                    let titleLabel = UILabel()
                    titleLabel.text = item.title
                    titleLabel.font = .fontWithSize(size: 14)
                    titleLabel.textColor = .text_1
                    itemView.addSubview(titleLabel)
                    titleLabel.snp.makeConstraints { make in
                        make.top.equalTo(icon.snp.bottom).offset(8)
                        make.left.equalTo(icon)
                        make.right.lessThanOrEqualToSuperview()
                    }
                    let descLabel = UILabel()
                    descLabel.text = item.desc
                    descLabel.font = .fontWithSize(size: 12.0)
                    descLabel.textColor = .text_2
                    descLabel.numberOfLines = 0
                    itemView.addSubview(descLabel)
                    descLabel.snp.makeConstraints { make in
                        make.top.equalTo(titleLabel.snp.bottom).offset(6)
                        make.left.equalToSuperview()
                        make.right.equalToSuperview()
                        make.bottom.lessThanOrEqualToSuperview()
                    }
                    rowStack.addArrangedSubview(itemBackgrounView)
                }
            }
            itemsStack.addArrangedSubview(rowStack)
        }

        // Set contentView bottom constraint for scroll
        commitmentContainer.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-40)
        }
    }

}
