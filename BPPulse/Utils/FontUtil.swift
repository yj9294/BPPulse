//
//  FontUtil.swift
//  Pulse
//
//  Created by admin on 2025/9/16.
//

import UIKit

extension UIFont {
    static func fontWithSize(size: Double, weigth: UIFont.Weight = .regular) -> UIFont {
        var font: UIFont?
        switch weigth {
        case .regular:
            font = UIFont(name: "Lexend-Regular", size: size)
        case .bold:
            font = UIFont(name: "Lexend-Bold", size: size)
        case .medium:
            font = UIFont(name: "Lexend-Medium", size: size)
        case .semibold:
            font = UIFont(name: "Lexend-SemiBold", size: size)
        case .heavy:
            font = UIFont(name: "Lexend-ExtraBold", size: size)
        case .black:
            font = UIFont(name: "Lexend-Black", size: size)
        default:
            font = .systemFont(ofSize: size)
        }
        return font ?? .systemFont(ofSize: size)
    }
}
