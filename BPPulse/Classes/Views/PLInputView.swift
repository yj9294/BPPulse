//
//  PLInputView.swift
//  BPPulse
//
//  Created by admin on 2025/9/18.
//

import UIKit

fileprivate class NoMenuTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

class PLInputView: PLBaseView {

    enum Style {
        case input, datePicker
    }
    
    var title: String? = nil {
        didSet {
            if style == .input {
                txf.text = title
            }  else {
                button.setTitle(title, for: .normal)
            }
        }
    }
    
    var goChangeHandle: ((Int)->Void)? = nil
    var goDatePickerHandle: ((Date)->Void)? = nil
    
    init(style: Style) {
        self.style = style
        super.init()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var txf: UITextField = {
        let txf = NoMenuTextField()
        txf.keyboardType = .numberPad
        txf.textColor = .text_1
        txf.font = .fontWithSize(size: 14)
        txf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return txf
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.text_1, for: .normal)
        button.titleLabel?.font = .fontWithSize(size: 14)
        button.addAction { [weak self] in
            self?.datePickerAction()
        }
        return button
    }()
    
    var style: Style
    override func setupUI() {
        super.setupUI()
        self.layerCornerRadius = 4
        self.layerBorderColor = .border_1
        self.layerBorderWidth = 1
        self.backgroundColor = .bg_6
        
        if style == .input {
            addSubview(txf)
            txf.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(16)
                make.top.bottom.equalToSuperview()
            }
        } else {
            addSubview(button)
            button.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(16)
                make.top.bottom.equalToSuperview()
            }
            
            let imageView = UIImageView(image: UIImage(named: "arrow"))
            addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-16)
            }
        }

    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        // handle text change, for now print or update
        if let text = textField.text, let value = Int(text) {
            goChangeHandle?(value)
        }
    }
    
    func datePickerAction() {
        let date = title?.dateFromDateTimeString(ofStyle: .short) ?? Date()
        DatePickerView.show(date:date ) { [weak self] selectedDate in
            self?.goDatePickerHandle?(selectedDate)
        }
    }

}

class DatePickerView: UIView {
    
    private let blurView: UIVisualEffectView
    private let container = UIView()
    private let datePicker = UIDatePicker()
    
    private var completion: ((Date)->Void)?
    
    init(date: Date = Date(), completion: ((Date)->Void)? = nil) {
        let blurEffect = UIBlurEffect(style: .dark)
        self.blurView = UIVisualEffectView(effect: blurEffect)
        super.init(frame: .zero)
        
        self.completion = completion
        setupUI(date: date)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(date: Date) {
        backgroundColor = .clear
        
        // 背景模糊
        blurView.alpha = 0.9
        addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 点击背景消失
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        blurView.addGestureRecognizer(tap)
        
        // 底部容器
        container.backgroundColor = .white
        container.layer.cornerRadius = 12
        container.clipsToBounds = true
        blurView.contentView.addSubview(container)
        container.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // DatePicker
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.date = date
        container.addSubview(datePicker)
        datePicker.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
            make.height.equalTo(260)
        }
    }
    
    @objc private func dismissSelf() {
        completion?(datePicker.date)
        removeFromSuperview()
    }
    
    // MARK: - Public Show
    static func show(date: Date = Date(), completion: ((Date)->Void)? = nil) {
        let pickerView = DatePickerView(date: date, completion: completion)
        ScreenUtil.window().addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
