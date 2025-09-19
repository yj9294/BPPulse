//
//  PLColorUtil.swift
//  Pulse
//
//  Created by admin on 2025/9/16.
//

import UIKit

/// 颜色
extension UIColor {
  
    
    /// 规范定义
    static let light1 = UIColor.white
    static let light2 = UIColor.init(hex: "#F4F6FC")
    static let light3 = UIColor.init(hex: "#F2F5F9")
    static let light4 = UIColor.init(hex: "#ECEEF6")
    static let light5 = UIColor.init(hex: "#EAEEF3")
    static let light6 = UIColor.init(hex: "#D1D0FC")
    
    static let light6_10 = UIColor.init(hex: "D1D0FC1A")?.withAlphaComponent(0.1)
    static let light_80 = UIColor.white.withAlphaComponent(0.8)
    
    static let dark1 = UIColor.init(hex: "#353535")
    static let dark2 = UIColor.init(hex: "#3A3C43")
    static let dark3 = UIColor.init(hex: "#9A9AA2")
    static let dark4 = UIColor.init(hex: "#B2B2B2")
    static let dark_30 = UIColor.init(hex: "#353535")?.withAlphaComponent(0.3)
    static let dark_40 = UIColor.init(hex: "#353535")?.withAlphaComponent(0.4)
    static let dark_50 = UIColor.init(hex: "#353535")?.withAlphaComponent(0.5)
    
    /// 功能色
    static let discountLabelColor = UIColor.init(hex: "#FFE347") // 主页优惠条字体颜色
    static let discountLabelShadowColor = UIColor.init(hex: "#FF7DD6")?.withAlphaComponent(0.8) // 主页优惠条shadow字体颜色
    static let discountViewColor = UIColor.init(hex: "#CD54F6") // 主页优惠券背景颜色
    static let discountButtonColor = UIColor.init(hex: "#FFBA03") // 闹钟
    
    
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexString.hasPrefix("0x") || hexString.hasPrefix("0X") {
            hexString.removeFirst(2)
        } else if hexString.hasPrefix("#") {
            hexString.removeFirst()
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)

        let red, green, blue: CGFloat
        switch hexString.count {
        case 6: // RGB
            red = CGFloat((rgb >> 16) & 0xff) / 255.0
            green = CGFloat((rgb >> 8) & 0xff) / 255.0
            blue = CGFloat(rgb & 0xff) / 255.0
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        case 8: // RGBA
            red = CGFloat((rgb >> 24) & 0xff) / 255.0
            green = CGFloat((rgb >> 16) & 0xff) / 255.0
            blue = CGFloat((rgb >> 8) & 0xff) / 255.0
            let alphaValue = CGFloat(rgb & 0xff) / 255.0
            self.init(red: red, green: green, blue: blue, alpha: alphaValue * alpha)
        default:
            return nil
        }
    }
}

extension UIColor {
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let multiplier = CGFloat(255.0)
        
        // 获取 UIColor 的 RGB 分量
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        // 将 RGB 分量转换为十六进制字符串
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        } else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}

/// 图片填充颜色
extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}



@propertyWrapper
struct DynamicColor {
    private let light: UIColor
    private let dark: UIColor
    
    init(light: UIColor?, dark: UIColor?) {
        self.light = light ?? UIColor.clear
        self.dark = dark ?? UIColor.clear
    }
    
    var wrappedValue: UIColor {
        return UIColor { traits in
            traits.userInterfaceStyle == .dark ? self.dark : self.light
        }
    }
}

/// 暗黑模式 颜色扩展
extension UIColor {
    // MARK: - 品牌色
    @DynamicColor(light: UIColor.init(hex: "#4A90E2"), dark: UIColor.init(hex: "#4A90E2        "))
    static var primary_1: UIColor //常规
    
    @DynamicColor(light: UIColor.init(hex: "#B3B1FA"), dark: UIColor.init(hex: "#BDBBFA"))
    static var primary_2: UIColor // 一般禁用
    
    // MARK: - 功能色
    @DynamicColor(light: UIColor.init(hex: "#EFF6FF"), dark: UIColor.init(hex: "#EFF6FF"))
    static var warnning_1_bg: UIColor // 标题
    
    @DynamicColor(light: UIColor.init(hex: "#FEF9C3"), dark: UIColor.init(hex: "#FEF9C3"))
    static var warnning_bg: UIColor // 标题
    
    @DynamicColor(light: UIColor.init(hex: "#DCFCE7"), dark: UIColor.init(hex: "#DCFCE7"))
    static var normal_bg: UIColor // 标题
    
    @DynamicColor(light: UIColor.init(hex: "#FEE2E2"), dark: UIColor.init(hex: "#FEE2E2"))
    static var danger_bg: UIColor // 标题
    
    @DynamicColor(light: UIColor.init(hex: "#CA8A04"), dark: UIColor.init(hex: "#CA8A04"))
    static var warnning: UIColor // 标题
    
    @DynamicColor(light: UIColor.init(hex: "#2563EB"), dark: UIColor.init(hex: "#2563EB"))
    static var warnning_1: UIColor // 标题
    
    @DynamicColor(light: UIColor.init(hex: "#16A34A"), dark: UIColor.init(hex: "#16A34A"))
    static var normal: UIColor // 标题
    
    @DynamicColor(light: UIColor.init(hex: "#DC2626"), dark: UIColor.init(hex: "#DC2626"))
    static var danger: UIColor // 标题
    
    // MARK: - 文字色
    @DynamicColor(light: UIColor.init(hex: "#111827"), dark: UIColor.init(hex: "#F9F9F9"))
    static var text_1: UIColor // 标题
    
    @DynamicColor(light: UIColor.init(hex: "#4B5563"), dark: UIColor.init(hex: "#B8B9BC"))
    static var text_2: UIColor // 正文
    
    @DynamicColor(light: UIColor.init(hex: "#6B7280"), dark: UIColor.init(hex: "#737481"))
    static var text_3: UIColor // 次要
    
    @DynamicColor(light: UIColor.init(hex: "#9CA3AF"), dark: UIColor.init(hex: "#484954"))
    static var text_4: UIColor // 辅助
    
    @DynamicColor(light: UIColor.init(hex: "#FFFFFF"), dark: UIColor.init(hex: "#F9F9F9"))
    static var text_5: UIColor // 纯白文字
    
    @DynamicColor(light: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.5), dark: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.6))
    static var text_6: UIColor // Tab文字
    
    // MARK: - 控件色/容器
    @DynamicColor(light: UIColor.init(hex: "#FFFFFF"), dark: UIColor.init(hex: "#0E0E0E"))
    static var bg_1: UIColor // 一级页面背景
    
    @DynamicColor(light: UIColor.init(hex: "#FFFFFF"), dark: UIColor.init(hex: "#1F1F26"))
    static var bg_2: UIColor // 二级页面背景
    
    @DynamicColor(light: UIColor.init(hex: "#F2F5F9"), dark: UIColor.init(hex: "#0E0E0E"))
    static var bg_3: UIColor // 三级页面背景
    
    @DynamicColor(light: UIColor.init(hex: "#F2F5F9"), dark: UIColor.init(hex: "#1F1F26"))
    static var bg_4: UIColor // 一级容器
    
    @DynamicColor(light: UIColor.init(hex: "#F3F4F6"), dark: UIColor.init(hex: "#F3F4F6"))
    static var bg_5: UIColor // 二级容器
    
    @DynamicColor(light: UIColor.init(hex: "#F9FAFB"), dark: UIColor.init(hex: "#F9FAFB"))
    static var bg_6: UIColor // 二级容器
    
    @DynamicColor(light: UIColor.init(hex: "#D1D0FC")?.withAlphaComponent(0.2), dark: UIColor.init(hex: "#5D5E6B"))
    static var bg_7: UIColor // 三级容器
    
    @DynamicColor(light: UIColor.init(hex: "#B3B1FA"), dark: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.8))
    static var bg_8: UIColor // 三级容器

    
    // MARK: - 填充色
    @DynamicColor(light: UIColor.init(hex: "#FFFFFF"), dark: UIColor.init(hex: "#FFFFFF"))
    static var fill_ww_0: UIColor // 透明 0%
    
    @DynamicColor(light: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.05), dark: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.05))
    static var fill_ww_1: UIColor // 透明 5%
    
    @DynamicColor(light: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.1), dark: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.1))
    static var fill_ww_2: UIColor // 透明 10%
    
    @DynamicColor(light: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.2), dark: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.2))
    static var fill_ww_3: UIColor // 透明 20%
    
    @DynamicColor(light: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.3), dark: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.3))
    static var fill_ww_4: UIColor // 透明 30%
    
    @DynamicColor(light: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.5), dark: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.5))
    static var fill_ww_5: UIColor // 透明 50%
    
    @DynamicColor(light: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.7), dark: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.7))
    static var fill_ww_6: UIColor // 透明 70%
    
    @DynamicColor(light: UIColor.init(hex: "#000003"), dark: UIColor.init(hex: "#000003"))
    static var fill_bb_0: UIColor // 透明 0%
    
    @DynamicColor(light: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.05), dark: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.05))
    static var fill_bb_1: UIColor // 透明 5%

    @DynamicColor(light: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.1), dark: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.1))
    static var fill_bb_2: UIColor // 透明 10%
    
    @DynamicColor(light: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.2), dark: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.2))
    static var fill_bb_3: UIColor // 透明 20%
    
    @DynamicColor(light: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.3), dark: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.3))
    static var fill_bb_4: UIColor // 透明 30%
    
    @DynamicColor(light: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.5), dark: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.5))
    static var fill_bb_5: UIColor // 透明 50%
    
    @DynamicColor(light: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.7), dark: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.7))
    static var fill_bb_6: UIColor // 透明 70%
    
    @DynamicColor(light: UIColor.init(hex: "#FFFFFF"), dark: UIColor.init(hex: "#000003"))
    static var fill_wb_0: UIColor // 透明 0%
    
    @DynamicColor(light: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.05), dark: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.05))
    static var fill_wb_1: UIColor // 透明 5%
    
    @DynamicColor(light: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.1), dark: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.1))
    static var fill_wb_2: UIColor // 透明 10%
    
    @DynamicColor(light: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.2), dark: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.2))
    static var fill_wb_3: UIColor // 透明 20%
    
    @DynamicColor(light: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.3), dark: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.3))
    static var fill_wb_4: UIColor // 透明 30%
    
    @DynamicColor(light: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.6), dark: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.6))
    static var fill_wb_5: UIColor // 透明 60%
    
    @DynamicColor(light: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.7), dark: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.7))
    static var fill_wb_6: UIColor // 透明 70%
    
    @DynamicColor(light: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.8), dark: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.8))
    static var fill_wb_7: UIColor // 透明 80%
    
    @DynamicColor(light: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.8), dark: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.9))
    static var fill_wb_8: UIColor // 透明 80% - 90%
    
    @DynamicColor(light: UIColor.init(hex: "#F2F5F9"), dark: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.15))
    static var fill_wb_9: UIColor // 透明 100% - 15%
    
    @DynamicColor(light: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.05), dark: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.1))
    static var fill_wb_10: UIColor // 透明 5% - 10%
    
    @DynamicColor(light: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.9), dark: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.9))
    static var fill_wb_11: UIColor // 透明 90%
    
    @DynamicColor(light: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.9), dark: UIColor.init(hex: "#33343D"))
    static var fill_wb_12: UIColor // 透明 90%
    
    @DynamicColor(light: UIColor.init(hex: "#FFFFFF"), dark: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.2))
    static var fill_wb_13: UIColor // 透明 90%
    
    @DynamicColor(light: UIColor.init(hex: "#D1D0FC")?.withAlphaComponent(0.08), dark: UIColor.init(hex: "#D1D0FC")?.withAlphaComponent(0.08))
    static var fill_d_1: UIColor // 透明 8%
    
    @DynamicColor(light: UIColor.init(hex: "#D1D0FC")?.withAlphaComponent(0.1), dark: UIColor.init(hex: "#28148F")?.withAlphaComponent(0.1))
    static var fill_d_2: UIColor // 透明 10%
    
    @DynamicColor(light: UIColor.init(hex: "#D1D0FC")?.withAlphaComponent(0.15), dark: UIColor.init(hex: "#D1D0FC")?.withAlphaComponent(0.15))
    static var fill_d_3: UIColor // 透明 15%

    @DynamicColor(light: UIColor.init(hex: "#D1D0FC")?.withAlphaComponent(0.2), dark: UIColor.init(hex: "#F9F9F9")?.withAlphaComponent(0.2))
    static var fill_d_4: UIColor // 透明 20%
    
    @DynamicColor(light: UIColor.init(hex: "#000003"), dark: UIColor.init(hex: "#FFFFFF"))
    static var fill_bw_0: UIColor // 透明 0%
    
    @DynamicColor(light: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.05), dark: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.05))
    static var fill_bw_1: UIColor // 透明 5%
    
    @DynamicColor(light: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.1), dark: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.1))
    static var fill_bw_2: UIColor // 透明 10%
    
    @DynamicColor(light: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.2), dark: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.2))
    static var fill_bw_3: UIColor // 透明 20%
    
    @DynamicColor(light: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.3), dark: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.3))
    static var fill_bw_4: UIColor // 透明 30%
    
    @DynamicColor(light: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.5), dark: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.5))
    static var fill_bw_5: UIColor // 透明 50%
    
    @DynamicColor(light: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.8), dark: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.8))
    static var fill_bw_6: UIColor // 透明 80%
    
    // MARK: - 控件色/蒙层
    @DynamicColor(light: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.2), dark: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.2))
    static var fill_t_1: UIColor // 浅
    
    @DynamicColor(light: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.5), dark: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.6))
    static var fill_t_2: UIColor // 中
    

    @DynamicColor(light: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.6), dark: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.7))
    static var fill_t_3: UIColor // 深
    
    @DynamicColor(light: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.85), dark: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.85))
    static var fill_t_4: UIColor // 重
    
    // MARK: - 控件色/按钮
    @DynamicColor(light: UIColor.init(hex: "#6354F3"), dark: UIColor.init(hex: "#7669F5"))
    static var btn_1: UIColor // 默认
    
    @DynamicColor(light: UIColor.init(hex: "#B3B1FA"), dark: UIColor.init(hex: "#3A3C43"))
    static var btn_2: UIColor // 禁用
    
    @DynamicColor(light: UIColor.init(hex: "#EAEEF3"), dark: UIColor.init(hex: "#1F1F26"))
    static var btn_3: UIColor // 不可点击
    
    @DynamicColor(light: UIColor.init(hex: "#E57B00"), dark: UIColor.init(hex: "#E57B00"))
    static var btn_4: UIColor // 聚焦
    
    // MARK: - 控件色/选项
    @DynamicColor(light: UIColor.init(hex: "#6354F3"), dark: UIColor.init(hex: "#F9F9F9"))
    static var fill_opt_1: UIColor // 选中
    
    @DynamicColor(light: UIColor.init(hex: "#D1D0FC")?.withAlphaComponent(0.1), dark: UIColor.init(hex: "#28148F")?.withAlphaComponent(0.3))

    static var fill_opt_2: UIColor // 选中
    
    @DynamicColor(light: UIColor.init(hex: "#F2F5F9"), dark: UIColor.init(hex: "#D1D0FC")?.withAlphaComponent(0.15))
    static var fill_opt_3: UIColor // 未选
    
    @DynamicColor(light: UIColor.init(hex: "#F2F5F9"), dark: UIColor.init(hex: "#33343D"))
    static var fill_opt_4: UIColor // 未选
    
    // MARK: - 线条色
    @DynamicColor(light: UIColor.init(hex: "#E5E7EB"), dark: UIColor.init(hex: "#E5E7EB"))
    static var border_1: UIColor // 分割线-浅
    
    @DynamicColor(light: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.1), dark: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.1))
    static var border_2: UIColor // 分割线-中
    
    @DynamicColor(light: UIColor.init(hex: "#0E0E0E")?.withAlphaComponent(0.2), dark: UIColor.init(hex: "#FFFFFF")?.withAlphaComponent(0.2))
    static var border_3: UIColor // 分割线-深
    
    // MARK: - 醒目色
    @DynamicColor(light: UIColor.init(hex: "#FFB137"), dark: UIColor.init(hex: "#FFB84B"))
    static var info_1: UIColor // 常规
    
    // MARK: - 醒目色
    @DynamicColor(light: UIColor.init(hex: "#FFB137"), dark: UIColor.init(hex: "#FFB84B"))
    static var info_3: UIColor // 常规
    
    // MARK: - 成功色
    @DynamicColor(light: UIColor.init(hex: "#3CCD4D"), dark: UIColor.init(hex: "#68D973"))
    static var success_1: UIColor // 常规
    
    @DynamicColor(light: UIColor.init(hex: "#D1D0FC")?.withAlphaComponent(0.08), dark: UIColor.init(hex: "#D1D0FC")?.withAlphaComponent(0.04))
    static var success_2: UIColor // 常规
    
    // MARK: - 警告色
    @DynamicColor(light: UIColor.init(hex: "#FF7100"), dark: UIColor.init(hex: "#FF9C43"))
    static var warning_1: UIColor // 常规
    
    // MARK: - 错误色
    @DynamicColor(light: UIColor.init(hex: "#FF4941"), dark: UIColor.init(hex: "#FF5A54"))
    static var danger_1: UIColor // 常规
    
    // MARK: - 订阅色/主渐变
    @DynamicColor(light: UIColor.init(hex: "#FFC800"), dark: UIColor.init(hex: "#FFC800"))
    static var subscription_1: UIColor
    
    @DynamicColor(light: UIColor.init(hex: "#FF61EA"), dark: UIColor.init(hex: "#FF61EA"))
    static var subscription_2: UIColor
    
    @DynamicColor(light: UIColor.init(hex: "#3300FF"), dark: UIColor.init(hex: "#3300FF"))
    static var subscription_3: UIColor
    
    // MARK: - 订阅色/黄色
    @DynamicColor(light: UIColor.init(hex: "#FFC800"), dark: UIColor.init(hex: "#FFC800"))
    static var yellow_1: UIColor
    
    @DynamicColor(light: UIColor.init(hex: "#FF9702"), dark: UIColor.init(hex: "#FF9702"))
    static var yellow_2: UIColor
    
    @DynamicColor(light: UIColor.init(hex: "#FC8102"), dark: UIColor.init(hex: "#FC8102"))
    static var yellow_3: UIColor
    
    // MARK: - 订阅色/粉色
    @DynamicColor(light: UIColor.init(hex: "#FF61EA"), dark: UIColor.init(hex: "#FF61EA"))
    static var pink_1: UIColor
    
    @DynamicColor(light: UIColor.init(hex: "#F6519D"), dark: UIColor.init(hex: "#F6519D"))
    static var pink_2: UIColor
    
    @DynamicColor(light: UIColor.init(hex: "#FA574C"), dark: UIColor.init(hex: "#FA574C"))
    static var pink_3: UIColor
    
    
    // MARK: - 订阅色/紫色
    @DynamicColor(light: UIColor.init(hex: "#8A38FF"), dark: UIColor.init(hex: "#8A38FF"))
    static var purple_1: UIColor
    
    @DynamicColor(light: UIColor.init(hex: "#7F52FF"), dark: UIColor.init(hex: "#7F52FF"))
    static var purple_2: UIColor
    
    @DynamicColor(light: UIColor.init(hex: "#6D73FF"), dark: UIColor.init(hex: "#6D73FF"))
    static var purple_3: UIColor
    
    
    // MARK: - 特殊色
    @DynamicColor(light: UIColor.init(hex: "#530AAF"), dark: UIColor.init(hex: "#530AAF"))
    static var special_1: UIColor
    
    @DynamicColor(light: UIColor.init(hex: "#450893"), dark: UIColor.init(hex: "#450893"))
    static var special_2: UIColor
    
    @DynamicColor(light: UIColor.init(hex: "#B86CFF"), dark: UIColor.init(hex: "#B86CFF"))
    static var special_3: UIColor
    
    @DynamicColor(light: UIColor.init(hex: "#F9F4FF"), dark: UIColor.init(hex: "#F9F4FF"))
    static var special_4: UIColor
    
    @DynamicColor(light: UIColor.init(hex: "#FFF5E4"), dark: UIColor.init(hex: "#FFF5E4"))
    static var special_5: UIColor
    
    @DynamicColor(light: UIColor.init(hex: "#C359DF"), dark: UIColor.init(hex: "#C359DF"))
    static var special_6: UIColor
    
    @DynamicColor(light: UIColor.init(hex: "#FFD557"), dark: UIColor.init(hex: "#FFD557"))
    static var special_7: UIColor
}


