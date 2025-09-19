//
//  PLPrivacyVC.swift
//  BPPulse
//
//  Created by admin on 2025/9/19.
//

import UIKit

class PLPrivacyVC: PLBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Privacy Policy"
    }
    
    override func setupUI() {
        super.setupUI()
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.snp.width)
        }
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview().inset(16)
        }
        
        func createSectionTitle(_ text: String) -> UILabel {
            let label = UILabel()
            label.font = UIFont.fontWithSize(size: 16, weigth: .medium)
            label.textColor = .text_3
            label.text = text
            return label
        }
        
        func createContentLabel(_ text: String) -> UILabel {
            let label = UILabel()
            label.font = UIFont.fontWithSize(size: 14)
            label.textColor = .text_3
            label.numberOfLines = 0
            label.text = text
            return label
        }
        
        func createBulletPoint(_ text: String) -> UILabel {
            let label = UILabel()
            label.font = UIFont.fontWithSize(size: 14)
            label.textColor = .text_3
            label.numberOfLines = 0
            label.text = "• \(text)"
            return label
        }
        
        // Top updated label
        let updatedLabel = UILabel()
        updatedLabel.font = UIFont.fontWithSize(size: 14)
        updatedLabel.textColor = .text_3
        updatedLabel.text = "Updated: September 15, 2025"
        stackView.addArrangedSubview(updatedLabel)
        
        // 1. Information Collection
        stackView.addArrangedSubview(createSectionTitle("1. Information Collection"))
        stackView.addArrangedSubview(createContentLabel("In order to provide quality services, we may collect the following types of information:"))
        stackView.addArrangedSubview(createBulletPoint("Information provided by users: When you register for an account, use app features, or contact us, you may be required to provide personal information, such as name, contact information, gender, etc."))
        stackView.addArrangedSubview(createBulletPoint("Information collected automatically: We may use Cookies and similar technologies to collect information about your use of the App, including device information, IP address, operating system and App usage."))
        stackView.addArrangedSubview(createBulletPoint("Blood pressure data: The main function of the application is to collect and analyze blood pressure data. This data will be stored in your personal account for the purpose of providing monitoring and analysis services."))
        
        // 2. Information Usage
        stackView.addArrangedSubview(createSectionTitle("2. Information Usage"))
        stackView.addArrangedSubview(createContentLabel("The information we collect will be used for the following purposes:"))
        stackView.addArrangedSubview(createBulletPoint("Provide, maintain and improve the functions and services of the application."))
        stackView.addArrangedSubview(createBulletPoint("Analyze the health status of users and provide personalized health advice to users."))
        stackView.addArrangedSubview(createBulletPoint("Send app alerts and notifications to users."))
        stackView.addArrangedSubview(createBulletPoint("Handle user requests and feedback."))
        stackView.addArrangedSubview(createBulletPoint("Comply with legal and regulatory requirements."))
        
        // 3. Information Security
        stackView.addArrangedSubview(createSectionTitle("3. Information Security"))
        stackView.addArrangedSubview(createContentLabel("We take reasonable security measures to protect your personal information. This includes:"))
        stackView.addArrangedSubview(createBulletPoint("Using encryption to protect the transmission of sensitive information."))
        stackView.addArrangedSubview(createBulletPoint("Restricting who has access to your personal information."))
        stackView.addArrangedSubview(createBulletPoint("Conducting regular security reviews."))
        
        // 4. Information Sharing
        stackView.addArrangedSubview(createSectionTitle("4. Information Sharing"))
        stackView.addArrangedSubview(createContentLabel("We promise not to sell, exchange or transfer your personal information to third parties. We will not share your information unless we have your express consent or to the extent permitted by law."))
        
        // 5. User Rights
        stackView.addArrangedSubview(createSectionTitle("5. User Rights"))
        stackView.addArrangedSubview(createContentLabel("Our app is not aimed at children under the age of 13. We do not knowingly collect personal information from children under the age of 13. If you are a parent or guardian and you find that your child has provided us with personal information, please contact us and we will delete the information immediately."))
        
        // 6. Privacy Policy Updates
        stackView.addArrangedSubview(createSectionTitle("6. Privacy Policy Updates"))
        stackView.addArrangedSubview(createContentLabel("We reserve the right to amend or update this Privacy policy at any time. Any material changes will be made through in-app notifications or by posting an updated Privacy Policy on our website to keep users informed of changes. By using BP Pulse, you agree to the terms of this Privacy Policy. If you do not agree to these terms, please stop using our app."))
        
        // 7. Contact Us
        stackView.addArrangedSubview(createSectionTitle("7. Contact Us"))
        stackView.addArrangedSubview(createContentLabel("If you have any questions or concerns regarding this Privacy Policy, please contact us. Thank you for choosing BP Pulse, we will be happy to provide you with better service."))
        stackView.addArrangedSubview(createContentLabel("Email: support@bppulse.com"))
    }
}
