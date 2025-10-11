//
//  Request.swift
//  OfflineMusic
//
//  Created by 阳剑 on 2024/8/14.
//

import UIKit
import Foundation
import Alamofire
import AdSupport
import UIKit

let isDebug = false
var BaseURL = "http://43.153.85.64:8887/analyzer"

let sessionManager: Session = {
    let configuration = URLSessionConfiguration.af.default
    configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    return Session(configuration: configuration)
}()


enum RequestCode : Int {
    case success = 200 //请求成功
    case networkFail = -9999 //网络错误
    case tokenMiss = 401 // token过期
    case tokenExpired = 403 // token过期
    case serverError = 500 // 服务器错误
    case jsonError = 501 // 解析错误
    case unknown = -8888 //未定义
}

/// 请求成功
typealias NetWorkSuccess = (_ obj:Any?) -> Void
/// 网络错误回调
typealias NetWorkError = (_ obj:Any?, _ code:RequestCode) -> Void
/// 主要用于网络请求完成过后停止列表刷新/加载
typealias NetWorkEnd = () -> Void

class Request<T:Codable> {
    
    var method : HTTPMethod = .get
    var showHud : Bool = true
    var timeOut : TimeInterval = 40
    var showError : Bool = true
    var decoding: Bool = true
    var isTMDB: Bool = false
    var files:[String:Data]? = nil
    
    private(set) var resonse: Response<T>?
    private var path : String!
    private var parameters : [String:Any]? = nil
    private var success : NetWorkSuccess?
    private var error : NetWorkError?
    private var end : NetWorkEnd?
    private var config : ((_ req:Request) -> Void)?
    private var query: [String: Any]?
    private var page: Int = 0 // 从一开始
    private var pageSize: Int = 0 // 服务器限定20


    required init(path:String, query: [String: Any]? = nil, parameters: [String:Any]? = nil, files: [String: Data]? = nil, page: Int = 0, pageSize: Int = 0) {
        self.path = path
        self.parameters = parameters
        self.query = query
        self.files = files
        self.page = page
        self.pageSize = pageSize
    }
    
    func netWorkConfig(config:((_ req:Request) -> Void)) -> Self {
        config(self)
        return self
    }
    
    @discardableResult
    func startRequestSuccess(success: NetWorkSuccess?) -> Self {
        self.success = success
        self.startRequest()
        return self
    }
    
    
    @discardableResult
    func end(end:@escaping NetWorkEnd) -> Self {
        self.end = end
        return self
    }

    @discardableResult
    func error(error:@escaping NetWorkError) -> Self {
        self.error = error
        return self
    }
    
    deinit {
        debugPrint("request===============deinit")
    }
    
}

struct Response<T: Codable>: Codable {
    var code: Int?
    var msg: String?
    var data: T?
    var results: T?
    var cast: T?
    var success: Bool?
    var status_message: String?
}

// MARK: 请求实现
extension Request {
    private func startRequest() -> Void {
        var BaseURL = "http://43.153.85.64:8887/analyzer"

        if showHud {
//            LoadingView.show("Loading...")
        }
        var url = BaseURL + (isDebug ? "/debug" : "") + path
        if path.hasPrefix("http") || path.hasPrefix("https") {
            url = path
        }
        
        if page > 0 {
            if query == nil {
                query = [:]
            }
        }
        if query == nil {
            query = [:]
            query?["language"] = Locale.current.identifier
        } else {
            query?["language"] = Locale.current.identifier
        }
        
        if var query = query {
            if pageSize > 0 {
                query["page"] = self.page
                query["pageSize"] = self.pageSize
            }
            
            let strings = query.compactMap({
                if let value = $0.value as? String, var encodedString = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    encodedString = encodedString.replacingOccurrences(of: "=", with: "%253D")
                    return "\($0.key)=\(encodedString)"
                }
                return "\($0.key)=\($0.value)"
            })
            let string = strings.joined(separator: "&")
            url = url + "?" + string
        }
        
        var headerDic:[String: String] = [:]
//        if url.contains(AppUtil.shared.baseUrl) {
//            // 公共头部
//            headerDic["token"] = ProfileUtil.shared.token
//        }
//        headerDic["Authorization"] = "Bearer " + AppInfo.shared.getToken()
//
        
        let httpHeaders = HTTPHeaders.init(headerDic)
        
        
        var dataRequest : DataRequest!
        typealias RequestModifier = (inout URLRequest) throws -> Void
        let requestModifier : RequestModifier = { (rq) in
            rq.timeoutInterval = self.timeOut
            if self.method != .get {
                rq.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
                if self.path.contains("http") {
                    rq.httpBody = self.parameters?.data
                } else {
                    rq.httpBody = isDebug ? self.parameters?.data : self.parameters?.encoding
                }
            }
            debugPrint("[API] -----------------------")
            debugPrint("[API] 请求地址:\(url)")
            debugPrint("[API] 请求参数:\(String(describing: self.parameters?.jsonString))")
            debugPrint("[API] 请求header:\(String(describing: headerDic.jsonString))")
            debugPrint("[API] -----------------------")
        }
        
        if files == nil {
            dataRequest = sessionManager.request(url, method: method, parameters: nil , encoding: JSONEncoding(), headers: httpHeaders, requestModifier: requestModifier)
        }else {
            dataRequest = sessionManager.upload(multipartFormData: { (mutilPartData) in
                for (key,obj) in self.files! {
                    mutilPartData.append(obj, withName: key,fileName: "1.jpeg",mimeType: "jpeg")
                }
                if self.parameters != nil {
                    for (key,value) in self.parameters! {
                        if let str = value as? String {
                            mutilPartData.append(str.data(using: String.Encoding.utf8)!, withName: key)
                        }else if let int = value as? Int
                        {
                            mutilPartData.append(String(int).data(using: String.Encoding.utf8)!, withName: key)
                        }
                    }
                }
            }, to: url,method:self.method, headers: httpHeaders,requestModifier: requestModifier).uploadProgress(closure: { progress in
                debugPrint(progress)
            })
        }
        
        dataRequest.responseData { (result: AFDataResponse) in
//            LoadingView.hide()
            guard let code = result.response?.statusCode, code == RequestCode.success.rawValue else {
                debugPrint("[API] [ERROR]  url:\(url) code: \(result.response?.statusCode ?? -9999)")
                self.handleError(message: "Code Error: \(result.response?.statusCode ?? -9999)")
                return
            }
            if var data = result.data {
                if self.decoding, !self.path.contains("http") {
                    data = data.decoding ?? Data()
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                    debugPrint("[API] url: \(url) response \(String(describing: json))")
                    if self.path.contains("http") {
                        let response = try JSONDecoder().decode(T.self, from: data)
                        self.resonse = Response<T>(code: 200, data: response)
                    } else {
                        if self.isTMDB {
                            let res = try JSONDecoder().decode(Response<T>.self, from: data)
                            if let results = res.results  {
                                self.resonse = Response<T>(code: 200, data: results)
                            } else if let cast = res.cast {
                                self.resonse = Response<T>(code: 200, data: cast)
                            } else {
                                if res.success == false {
                                    self.handleError(message: "error code \(code) msg: \(self.resonse?.status_message ?? "")")
                                    return
                                } else {
                                    let response = try JSONDecoder().decode(T.self, from: data)
                                    self.resonse = Response<T>(code: 200, data: response)
                                }
                            }
                        } else {
                            self.resonse = try JSONDecoder().decode(Response<T>.self, from: data)
                        }
                    }
                } catch let err {
                    debugPrint(err)
                    self.handleError(message: err.localizedDescription)
                    return
                }
                if let code = self.resonse?.code {
                    if code == RequestCode.success.rawValue {
                        self.requestSuccess()
                    } else {
                        self.handleError(message: "error code \(code) msg: \(self.resonse?.msg ?? "")")
                    }
                } else {
                    self.handleError(message: "error code \(code) msg: \(self.resonse?.msg ?? "")")
                }
            } else {
                debugPrint("[API] [ERROR] url: \(url) response data is nil")
                self.handleError(message: "\(url) response data is nil")
            }
        }
        
    }
    
    func uploadFile(withData data:Data) -> Void {
        
    }
    
    private func requestSuccess() -> Void {
        if let success = self.success {
            if let resonse = self.resonse {
                success(resonse.data)
            } else {
                success(nil)
            }
            self.success = nil
        }
    }
    
    private func requestError(msg: String?) -> Void {
        if let error = self.error {
            error(self.resonse?.data , .unknown)
            self.error = nil
        }
    }
    
    // MARK: 错误处理
    func handleError(message: String?) -> Void {
        self.requestError(msg: message)
        self.end?()
        self.end = nil
        if let msg = message {
            if let vc = AppCurrentShowVC(), showError {
                vc.alertController(msg)
            }
        } else {
            if let vc = AppCurrentShowVC(), showError {
                vc.alertController("Request Error: \(message ?? "0")")
            }
        }
    }
    
}


func AppCurrentShowVC() -> UIViewController? {
    
    if var vc = (UIApplication.shared.connectedScenes.filter({$0 is UIWindowScene}).first as? UIWindowScene)?.windows.first?.rootViewController {
        while (true) {
            if let tabbarVC = vc as? UITabBarController {
                vc = tabbarVC.selectedViewController!
            }
            if let nav = vc as? UINavigationController {
                vc = nav.topViewController!
            }
            if vc.presentedViewController != nil {
                vc = vc.presentedViewController!
            }
            
            if (!(vc is UITabBarController || vc is UINavigationController || vc.presentedViewController != nil)) {
                return vc
            }
        }
    }
    return nil
}

func AppWindow() -> UIWindow? {
    (UIApplication.shared.connectedScenes.filter({$0 is UIWindowScene}).first as? UIWindowScene)?.windows.first
}

extension UIViewController {
    
    func alertController(_ message: String, isOK: Bool = false, completion: (()->Void)? = nil) {
        let vc = UIAlertController(title: message, message: nil, preferredStyle: .alert)

        if !isOK {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                vc.dismiss(animated: true)
                completion?()
            }
        } else {
            vc.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                completion?()
            }))
        }
        if let root = AppCurrentShowVC() {
            root.present(vc, animated: true)
        }
    }
    
    
}
