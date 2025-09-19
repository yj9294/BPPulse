//
//  PLFeedbackVC.swift
//  BPPulse
//
//  Created by admin on 2025/9/19.
//

import UIKit
import IQKeyboardManagerSwift

class PLFeedbackVC: PLBaseVC {

    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    // Section 1: Feedback Type
    private let feedbackTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Feedback Type"
        label.font = UIFont.fontWithSize(size: 16)
        label.textColor = .text_1
        return label
    }()
    private let featureButton = FeedbackTypeButton(
        title: "Feature Suggestion",
        iconName: "feedback_suggestion"
    )
    private let bugButton = FeedbackTypeButton(
        title: "Bug Report",
        iconName: "feedback_bug"
    )
    private lazy var feedbackTypeStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [featureButton, bugButton])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()

    // Section 2: Content
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "Content"
        label.font = UIFont.fontWithSize(size: 16)
        label.textColor = .text_1
        return label
    }()
    private let contentTextView = PlaceholderTextView()
    private let charCounterLabel: UILabel = {
        let label = UILabel()
        label.text = "0/500"
        label.font = UIFont.fontWithSize(size: 12)
        label.textColor = .text_3
        label.textAlignment = .right
        return label
    }()

    // Section 3: Contact
    private let contactLabel: UILabel = {
        let label = UILabel()
        label.text = "Contact (Optional)"
        label.font = UIFont.fontWithSize(size: 16)
        label.textColor = .text_1
        return label
    }()
    private let contactField: UITextField = {
        let field = UITextField()
        field.font = UIFont.fontWithSize(size: 12)
        field.textColor = .text_2
        field.attributedPlaceholder = NSAttributedString(
            string: "Email/Phone number for our response",
            attributes: [
                .foregroundColor: UIColor.text_3,
                .font: UIFont.fontWithSize(size: 12)
            ]
        )
        field.borderStyle = .roundedRect
        field.layer.cornerRadius = 8
        field.layer.borderWidth = 1
        field.layerBorderColor = .border_1
        field.backgroundColor = .white
        return field
    }()

    // Submit Button
    private let submitButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Submit Feedback", for: .normal)
        btn.titleLabel?.font = UIFont.fontWithSize(size: 14)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .btn_2
        btn.layer.cornerRadius = 8
        btn.clipsToBounds = true
        btn.isEnabled = false
        return btn
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
    }

    // MARK: - UI Setup
    override func setupUI() {
        super.setupUI()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
        }

        // Add all views to contentView
        contentView.addSubview(feedbackTypeLabel)
        contentView.addSubview(feedbackTypeStack)
        contentView.addSubview(contentLabel)
        contentView.addSubview(contentTextView)
        contentView.addSubview(charCounterLabel)
        contentView.addSubview(contactLabel)
        contentView.addSubview(contactField)
        contentView.addSubview(submitButton)

        let horizontalPadding = 16
        let verticalSpacing = 20

        feedbackTypeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(horizontalPadding)
            make.right.equalToSuperview().offset(-horizontalPadding)
        }
        feedbackTypeStack.snp.makeConstraints { make in
            make.top.equalTo(feedbackTypeLabel.snp.bottom).offset(12)
            make.left.right.equalTo(feedbackTypeLabel)
            make.height.equalTo(56)
        }

        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(feedbackTypeStack.snp.bottom).offset(verticalSpacing)
            make.left.right.equalTo(feedbackTypeLabel)
        }
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(12)
            make.left.right.equalTo(feedbackTypeLabel)
            make.height.equalTo(120)
        }
        charCounterLabel.snp.makeConstraints { make in
            make.right.equalTo(contentTextView).offset(-8)
            make.bottom.equalTo(contentTextView).offset(-8)
        }

        contactLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(verticalSpacing)
            make.left.right.equalTo(feedbackTypeLabel)
        }
        contactField.snp.makeConstraints { make in
            make.top.equalTo(contactLabel.snp.bottom).offset(12)
            make.left.right.equalTo(feedbackTypeLabel)
            make.height.equalTo(44)
        }

        submitButton.snp.makeConstraints { make in
            make.top.equalTo(contactField.snp.bottom).offset(32)
            make.left.right.equalTo(feedbackTypeLabel)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-40)
        }

        // Default selection
        featureButton.isSelected = true
        bugButton.isSelected = false
        updateFeedbackTypeSelection()

        // Setup contentTextView
        contentTextView.placeholder = "Please describe your suggestion or issue in detail..."
        contentTextView.font = UIFont.fontWithSize(size: 12)
        contentTextView.textColor = .text_2
        contentTextView.placeholderColor = .text_3
        contentTextView.layer.cornerRadius = 8
        contentTextView.layer.borderWidth = 1
        contentTextView.layerBorderColor = .border_1
        contentTextView.backgroundColor = .bg_6
        contentTextView.delegate = self

        // Initialize submitButton as disabled and button_2 color
        submitButton.isEnabled = false
        submitButton.backgroundColor = .btn_2
    }

    // MARK: - Actions
    private func setupActions() {
        featureButton.addTarget(self, action: #selector(featureTapped), for: .touchUpInside)
        bugButton.addTarget(self, action: #selector(bugTapped), for: .touchUpInside)
        contentTextView.delegate = self
        submitButton.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
    }

    @objc private func featureTapped() {
        featureButton.isSelected = true
        bugButton.isSelected = false
        updateFeedbackTypeSelection()
    }
    @objc private func bugTapped() {
        featureButton.isSelected = false
        bugButton.isSelected = true
        updateFeedbackTypeSelection()
    }
    private func updateFeedbackTypeSelection() {
        featureButton.updateSelection()
        bugButton.updateSelection()
    }
    
    @objc private func submitAction() {
        self.view.endEditing(true)
        AEAlertControl.alert(title: "Feedback Successfully", content: "We will process your comments and suggestions as soon as possible and express our sincerest gratitude to you.", actions: [
            .init(title: "OK", action: {
                self.navigationController?.popViewController()
            })
        ])
    }
}

// MARK: - UITextViewDelegate
extension PLFeedbackVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        var count = textView.text.count
        if count > 500 {
            textView.text = String(textView.text.prefix(500))
            count = 500
        }
        charCounterLabel.text = "\(count)/500"
        if count == 0 {
            submitButton.isEnabled = false
            submitButton.backgroundColor = .btn_2
        } else {
            submitButton.isEnabled = true
            submitButton.backgroundColor = .primary_1
        }
    }
}

// MARK: - Helper Views
private class FeedbackTypeButton: UIControl {
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let stack = UIStackView()

    init(title: String, iconName: String) {
        super.init(frame: .zero)
        iconView.image = UIImage(named: iconName)
        iconView.isUserInteractionEnabled = false
        iconView.contentMode = .scaleAspectFit
        iconView.snp.makeConstraints { $0.size.equalTo(CGSize(width: 24, height: 24)) }
        titleLabel.text = title
        titleLabel.isUserInteractionEnabled = false
        titleLabel.font = UIFont.fontWithSize(size: 14)
        titleLabel.textColor = .text_2

        stack.axis = .horizontal
        stack.isUserInteractionEnabled = false
        stack.spacing = 8
        stack.alignment = .center
        stack.addArrangedSubview(iconView)
        stack.addArrangedSubview(titleLabel)
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        layer.cornerRadius = 8
        layer.borderWidth = 2
        backgroundColor = .white
        updateSelection()
    }
    required init?(coder: NSCoder) { fatalError() }

    override var isSelected: Bool {
        didSet { updateSelection() }
    }
    func updateSelection() {
        if isSelected {
            layerBorderColor = .primary_1
            titleLabel.textColor = .primary_1
            self.backgroundColor = .warnning_1_bg
        } else {
            layerBorderColor = .border_1
            titleLabel.textColor = .text_1
            self.backgroundColor = .bg_6
        }
    }
}

private class PlaceholderTextView: UITextView {
    var placeholder: String? {
        didSet { setNeedsDisplay() }
    }
    var placeholderColor: UIColor = .lightGray {
        didSet { setNeedsDisplay() }
    }
    override var text: String! {
        didSet { setNeedsDisplay() }
    }
    override var attributedText: NSAttributedString! {
        didSet { setNeedsDisplay() }
    }
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: self)
    }
    @objc private func textDidChange(notification: Notification) {
        setNeedsDisplay()
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if text.isEmpty, let placeholder = placeholder {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font ?? UIFont.systemFont(ofSize: 15),
                .foregroundColor: placeholderColor
            ]
            let insets = textContainerInset
            let rect = CGRect(
                x: insets.left + 4,
                y: insets.top,
                width: bounds.width - insets.left - insets.right - 8,
                height: bounds.height - insets.top - insets.bottom
            )
            placeholder.draw(in: rect, withAttributes: attributes)
        }
    }
}
