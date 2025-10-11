//
//  ConfigCommon.swift
//  OfflineMusic
//
//  Created by admin on 2024/11/23.
//

import UIKit

struct ConfigModel: Codable{
    var bundleID: String?
    var appName: String?
    var configs: [Config]?
    
    struct Config: Codable {
        var configKey: String?
        var configValue: String?
        var configType: Int? // 0 bool, 1 int, 2 flot, 3, string
        var configDesc: String?
    }
}


extension Request {
    // 获取config信息
    class func getConfigs(success: ((ConfigModel)->Void)?, err:NetWorkError? = nil) -> Void {
        Request(path: "/config", query: ["BundleID": "com.bp.pulse"]).netWorkConfig { req in
            req.showHud = false
            req.decoding = false
            req.showError = false
        }.startRequestSuccess { obj in
            if let obj = obj as? ConfigModel {
                success?(obj)
            }
        }.error(error: { obj, code in
            err?(obj, code)
        })
    }
}
