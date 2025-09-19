//
//  PLHealthDetailVC.swift
//  BPPulse
//
//  Created by admin on 2025/9/18.
//

import UIKit
import ObjectiveC

class PLHealthDetailVC: PLBaseVC {
    
    var item: PLHealthModel? = nil {
        didSet {
            if let item = item {
                setupUI(with: item)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func setupUI(with item: PLHealthModel) {
        self.title = item.value
        
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        let contentView = UIView()
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        let headerImageView = UIImageView(image: item.bgIcon)
        headerImageView.contentMode = .scaleAspectFit
        contentView.addSubview(headerImageView)
        headerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(180)
            make.width.lessThanOrEqualToSuperview().offset(-32)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = item.title
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
        }
        
        let descLabel = UILabel()
        descLabel.text = item.description
        descLabel.font = .systemFont(ofSize: 14)
        descLabel.numberOfLines = 0
        descLabel.textColor = .darkGray
        contentView.addSubview(descLabel)

        let sourceTitleLabel = UILabel()
        sourceTitleLabel.text = "Sources of information for the article:"
        sourceTitleLabel.font = .boldSystemFont(ofSize: 12)
        sourceTitleLabel.textColor = .darkText
        contentView.addSubview(sourceTitleLabel)

        let sourceStack = UIStackView()
        sourceStack.axis = .vertical
        sourceStack.spacing = 4
        contentView.addSubview(sourceStack)

        for (index, urlString) in item.source.enumerated() {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 6
            rowStack.alignment = .top

            let numberLabel = UILabel()
            numberLabel.text = "\(index + 1)."
            numberLabel.font = .systemFont(ofSize: 12)
            numberLabel.textColor = .darkText

            let sourceLabel = UILabel()
            sourceLabel.text = urlString
            sourceLabel.textColor = .systemBlue
            sourceLabel.font = .systemFont(ofSize: 12)
            sourceLabel.isUserInteractionEnabled = true
            sourceLabel.numberOfLines = 0

            rowStack.addArrangedSubview(numberLabel)
            rowStack.addArrangedSubview(sourceLabel)
            sourceStack.addArrangedSubview(rowStack)

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openSourceLink(_:)))
            sourceLabel.addGestureRecognizer(tapGesture)
        }

        let otherSuggestionsLabel = UILabel()
        otherSuggestionsLabel.text = "Other Suggestions:"
        otherSuggestionsLabel.font = .boldSystemFont(ofSize: 16)
        otherSuggestionsLabel.textColor = .darkText
        contentView.addSubview(otherSuggestionsLabel)

        let bottomStack = UIStackView()
        bottomStack.axis = .horizontal
        bottomStack.distribution = .fillEqually
        bottomStack.spacing = 12
        contentView.addSubview(bottomStack)

        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(sourceTitleLabel.snp.top).offset(-8)
        }

        sourceTitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(sourceStack.snp.top).offset(-8)
        }

        sourceStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(otherSuggestionsLabel.snp.top).offset(-20)
        }

        otherSuggestionsLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(bottomStack.snp.top).offset(-8)
        }

        bottomStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-20)
        }

        for model in PLHealthModel.allCases {
            if model == item {
                continue
            }
            let container = UIView()
            container.backgroundColor = .bg_6
            container.layerBorderColor = .border_1
            container.layerBorderWidth = 1
            container.layerCornerRadius = 8
            
            let imageView = UIImageView(image: model.icon)
            imageView.contentMode = .scaleAspectFit
            container.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(10)
                make.centerX.equalToSuperview()
                make.width.height.equalTo(20)
            }
            
            let label = UILabel()
            label.text = model.value
            label.font = .systemFont(ofSize: 12)
            label.textAlignment = .center
            container.addSubview(label)
            label.snp.makeConstraints { make in
                make.top.equalTo(imageView.snp.bottom).offset(5)
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview().offset(-10)
            }
            
            bottomStack.addArrangedSubview(container)
        }
    }
    
    @objc private func openSourceLink(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel else { return }
        guard let url = URL(string: label.text) else { return }
        UIApplication.shared.open(url)
    }
}
