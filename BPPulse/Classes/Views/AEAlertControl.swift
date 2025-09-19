//
//  AEAlertControl.swift
//  BPPulse
//
//  Created by admin on 2025/9/17.
//

import UIKit
import SwifterSwift

class AEAlertControl: NSObject {
    
    static func alert(title: String?, content: String?, actions: [AEAction]) {
        presentAlertView(title: title, content: content, actions: actions)
    }
    
    static func toast(title: String? = nil, content: String? = nil)  {
        presentToastView(title: title, style: .success)
    }
    
    static func error(title: String? = nil, content: String? = nil)  {
        presentToastView(title: title, style: .failed)
    }
    
    static func tips(title: String? = nil, content: String? = nil)  {
        presentToastView(title: title, style: .tips)
    }
    
    static func sheet(title: String? = nil, content: String? = nil, action: AEAction? = nil)  {
        presentSheetView(title: title, content: content, action: action)
    }
    
    private static func presentToastView(title: String?, style: AEToastView.Style) {
        let superView = ScreenUtil.window()
        superView.subviews.forEach({ if $0 is AEToastView {
            $0.removeFromSuperview()
        }})
    
        let alertView = AEToastView(title: title, style: style)
        superView.addSubview(alertView)
        alertView.snp.remakeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            alertView.present()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.75) {
            AEToastView.dismiss()
        }
    }
    
    private static func presentSheetView(title: String?, content: String?, action: AEAction?) {
        let superView = ScreenUtil.window()
        superView.subviews.forEach({ if $0 is AESheetView {
            $0.removeFromSuperview()
        }})
        let alertView = AESheetView(title: title, content: content, action: action)
        superView.addSubview(alertView)
        alertView.snp.remakeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            alertView.showAnimation()
        }
    }
    
    private static func presentAlertView(title: String?, content: String?, actions: [AEAction]) {
        let superView = ScreenUtil.window()
        superView.subviews.forEach({ if $0 is AEAlertView {
            $0.removeFromSuperview()
        }})
        let alertView = AEAlertView(title: title, content: content, actions: actions)
        superView.addSubview(alertView)
        alertView.alpha = 0
        alertView.snp.remakeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            alertView.showAnimation()
        }
    }
}

struct AEAction {
    var buttonColor: UIColor? = .text_1
    var title: String?
    var action: (()->Void)?
}

private class AEAlertView: PLBaseView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text_1
        label.font = .fontWithSize(size: 16, weigth: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = title
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text_1
        label.font = .fontWithSize(size: 13, weigth: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = content
        return label
    }()
    
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .fill_t_3
        return backgroundView
    }()
    
    private var title: String? = nil
    private var content: String? = nil
    private var actions: [AEAction] = []
     
    init(title: String?, content: String?, actions: [AEAction] = []) {
        self.title = title
        self.content = content
        self.actions = actions
        super.init()
    }
    
    override func setupUI() {
        super.setupUI()
        
        let noContent = content == nil || content?.isEmpty == true
        
        addSubview(backgroundView)
        backgroundView.snp.remakeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        
        
        let contentView = UIView()
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        addSubview(contentView)
        contentView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(52)
            make.right.equalToSuperview().offset(-52)
        }
        
        let effectView = VisualEffectView()
        effectView.backgroundColor = .fill_wb_12
        effectView.blurRadius = 20
        contentView.addSubview(effectView)
        effectView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(titleLabel)
        let height = title?.textHeightFromTextString(textWidth: ScreenUtil.window().width - 104 - 48, font: titleLabel.font) ?? 0.0
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview().offset(24)
            make.height.equalTo(height == 0.0 ? 0 : height + 8.0)
        }
        
        contentView.addSubview(contentLabel)
        let contentHeight = content?.textHeightFromTextString(textWidth: ScreenUtil.window().width - 104 - 48, font: contentLabel.font) ?? 0.0
        contentLabel.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(noContent ? 0 : 8)
            make.left.greaterThanOrEqualToSuperview().offset(16)
            make.height.equalTo(contentHeight == 0.0 ? 0 : contentHeight + 6.0)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = .border_3
        contentView.addSubview(lineView)
        lineView.snp.remakeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        let actionView = UIView()
        actionView.backgroundColor = .clear
        contentView.addSubview(actionView)
        actionView.snp.remakeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(46)
        }
        
        var lastView: UIView = UIView()
        for (index, action) in actions.enumerated() {
            let button  = UIButton()
            button.addAction { [weak self] in
                self?.dismissAnimation()
                action.action?()
            }
            button.backgroundColor = .clear
            button.setTitle(action.title, for: .normal)
            button.setTitleColor(action.buttonColor, for: .normal)
            button.titleLabel?.font = UIFont.fontWithSize(size: 16, weigth: .medium)
            actionView.addSubview(button)
            button.snp.remakeConstraints { make in
                if index == 0 {
                    make.left.equalToSuperview()
                } else {
                    make.left.equalTo(lastView.snp.right).offset(0.5)
                    make.width.equalTo(lastView.snp.width)
                    setupSeparatorLineView(supView: actionView, targetView: lastView)
                }
                make.top.bottom.equalToSuperview()
                if index == actions.count - 1 {
                    make.right.equalToSuperview()
                }
            }
            
            lastView = button
        }
        
    }
    
    private func setupSeparatorLineView(supView: UIView, targetView: UIView) {
        let lineView = UIView()
        lineView.backgroundColor = .border_3
        supView.addSubview(lineView)
        
        lineView.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(targetView.snp.right)
            make.width.equalTo(0.5)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showAnimation() {
        self.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.alpha = 1
            self.alpha = 1
        }
    }
    
    func dismissAnimation() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0
        } completion: { ret in
            if ret {
                self.removeFromSuperview()
            }
        }
    }
}

private class AEToastView: PLBaseView {
    
    static func dismiss() {
        let superView = ScreenUtil.window()
        let view = superView.subviews.filter({$0 is AEToastView}).first
        if let view = view as? AEToastView {
            view.dismiss()
        }
        UIView.animate(withDuration: 0.25) {
            view?.alpha = 0
        } completion: { ret in
            if ret {
                view?.removeFromSuperview()
            }
        }
    }
    
    init(title: String?, style: Style) {
        self.title = title
        self.style = style
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var title: String?
    var style: Style
    enum Style {
        case success, failed, tips
        
        var iconName: String {
            switch self {
            case .success:
                return "common_success"
            case .failed:
                return "common_failed"
            case .tips:
                return "common_tips"
            }
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .fontWithSize(size: 13, weigth: .regular)
        label.textColor = style == .success || style == .tips ? .text_1 : .text_5
        label.text = title
        label.numberOfLines = 0
        return label
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    func dismiss() {
        UIView.animate(withDuration: 0.25) {
            let height = self.title?.textHeightFromTextString(textWidth: 250 , font: .fontWithSize(size: 13, weigth: .regular)) ?? 0.0
            if self.contentView.superview != nil {
                self.contentView.snp.remakeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.top.equalToSuperview().offset(-height - 30)
                }
            }
            self.updateConstraints()
            self.updateFocusIfNeeded()
            self.layoutIfNeeded()
        } completion: { ret in
            if ret {
                self.contentView.removeFromSuperview()
            }
        }
    }
    
    func present() {
        UIView.animate(withDuration: 0.25) {
            if self.contentView.superview != nil {
                self.contentView.snp.remakeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.top.equalToSuperview().offset(88)
                }
            }
            self.updateConstraints()
            self.updateFocusIfNeeded()
            self.layoutIfNeeded()
        }
    }
    
    override func setupUI() {
        super.setupUI()
        
        let height = (title?.textHeightFromTextString(textWidth: 250 , font: .fontWithSize(size: 13, weigth: .regular)) ?? 0.0) + 5
        addSubview(contentView)
        contentView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(-height - 30)
        }
        
        let contentBgView = UIView()
        contentBgView.backgroundColor = style == .success || style == .tips ? .fill_wb_12 : .danger_1
        contentBgView.layer.cornerRadius = 14
        contentView.addSubview(contentBgView)
        contentBgView.snp.remakeConstraints { make in
            make.top.left.right.bottom.equalTo(contentView)
        }
                
        if style != .tips {
            let icon = UIImageView(image: UIImage(named: style.iconName))
            contentView.addSubview(icon)
            icon.snp.remakeConstraints { make in
                make.centerY.equalTo(contentView)
                make.left.equalTo(contentView).offset(16)
            }
            
            contentView.addSubview(titleLabel)
            titleLabel.snp.remakeConstraints { make in
                make.top.equalTo(contentView).offset(16)
                make.left.equalTo(icon.snp.right).offset(8)
                make.right.equalTo(contentView).offset(-16)
                make.bottom.equalTo(contentView).offset(-16)
            }
            
            let width = (title?.textwidthFromTextString(textHeight: 20.0, font: .fontWithSize(size: 13, weigth: .regular)) ?? 0.0) + 5
            if width > 250 {
                titleLabel.snp.remakeConstraints { make in
                    make.top.equalTo(contentView).offset(16)
                    make.left.equalTo(icon.snp.right).offset(8)
                    make.right.equalTo(contentView).offset(-16)
                    make.bottom.equalTo(contentView).offset(-16)
                    make.width.equalTo(250)
                }
            }
        } else {
            contentView.addSubview(titleLabel)
            titleLabel.snp.remakeConstraints { make in
                make.top.equalTo(contentView).offset(16)
                make.left.equalTo(contentView).offset(16)
                make.right.equalTo(contentView).offset(-16)
                make.bottom.equalTo(contentView).offset(-16)
            }
            
            let width = (title?.textwidthFromTextString(textHeight: 20.0, font: .fontWithSize(size: 13, weigth: .regular)) ?? 0.0) + 5
            if width > 250 {
                titleLabel.snp.remakeConstraints { make in
                    make.top.equalTo(contentView).offset(16)
                    make.right.equalTo(contentView).offset(-16)
                    make.bottom.equalTo(contentView).offset(-16)
                    make.left.equalTo(contentView).offset(16)
                    make.width.equalTo(250)
                }
            }
        }

    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view is AEToastView {
            return nil
        }
        return view
    }
    
}

class AESheetView: PLBaseView {
    private lazy var backgroundView = {
        let backgroundView = UIView()
        backgroundView.alpha = 0
        backgroundView.backgroundColor = .fill_t_3
        return backgroundView
    }()
    
    private lazy var contentView = {
        let contentView = UIView()
        return contentView
    }()
    
    private lazy var animationView = {
        let view = UIView()
        return view
    }()
    
    init(title: String?, content: String?, action: AEAction?) {
        self.title = title
        self.subtitle = content
        self.buttonType = action
        super.init()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var title: String?
    private var subtitle: String?
    private var buttonType: AEAction?
    
    override func setupUI() {
        super.setupUI()
        
        addSubview(backgroundView)
        backgroundView.snp.remakeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        addSubview(animationView)
        animationView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(225+34)
            make.bottom.equalToSuperview().offset(225+34)
        }
        
        animationView.addSubview(contentView)
        contentView.snp.remakeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        let contentBgView = UIView()
        contentBgView.layer.cornerRadius = 20
        contentBgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentBgView.backgroundColor = .fill_wb_12
        animationView.addSubview(contentBgView)
        contentBgView.snp.remakeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        let lineView = UIView()
        lineView.backgroundColor = .border_3
        lineView.layer.cornerRadius = 2
        contentView.addSubview(lineView)
        lineView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(50)
            make.height.equalTo(4)
        }
        
        let titleLabel = UILabel()
        titleLabel.textColor = .text_1
        titleLabel.font = .fontWithSize(size: 20, weigth: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = title
        contentView.addSubview(titleLabel)
        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(38)
            make.left.equalToSuperview().offset(60)
            make.right.equalToSuperview().offset(-60)
        }
        
        let subtitleLabel = UILabel()
        subtitleLabel.textColor = .text_1
        subtitleLabel.font = .fontWithSize(size: 13, weigth: .regular)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.text = subtitle
        contentView.addSubview(subtitleLabel)
        subtitleLabel.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-40)
        }
        
        let button = UIButton()
        button.addAction {  [weak self] in
            self?.buttonType?.action?()
        }
        button.setTitle(buttonType?.title, for: .normal)
        contentBgView.addSubview(button)
        button.snp.remakeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(38)
            make.right.equalToSuperview().offset(-38)
            make.height.equalTo(56)
        }
    }
    
    func showAnimation() {
        backgroundView.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.alpha = 1
            if self.animationView.superview != nil {
                self.animationView.snp.remakeConstraints { make in
                    make.bottom.left.right.equalToSuperview()
                    make.height.equalTo(225+34)
                }
            }
            self.animationView.updateConstraints()
            self.animationView.updateConstraintsIfNeeded()
            self.animationView.layoutIfNeeded()
        }
    }
    
    func dismissAnimation() {
        UIView.animate(withDuration: 0.25) {
            self.backgroundView.alpha = 0
            if self.animationView.superview != nil {
                self.animationView.snp.remakeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.height.equalTo(225+34)
                    make.bottom.equalToSuperview().offset(225+34)
                }
            }
            self.animationView.updateConstraints()
            self.animationView.updateConstraintsIfNeeded()
            self.animationView.layoutIfNeeded()
        } completion: { ret in
            if ret {
                self.removeFromSuperview()
            }
        }
    }
}

