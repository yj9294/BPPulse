//
//  PLHomeFilter.swift
//  Pulse
//
//  Created by admin on 2025/9/16.
//

import UIKit

enum PLHomeFilterModel: String, Codable {
    // 赋用户最近一次记录的三个数值；
    // 三个数值分别赋用户全部记录的对应数值的平均值；
    // 三个数值分别赋用户48小时内全部记录的对应数值的平均值；
    case newest = "Newest Record"
    case average = "Average Record"
    case twodays = "48 Hour Average"
}
