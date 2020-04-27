//
//  ELNetTools.swift
//  index
//
//  Created by Soul on 10/10/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit
import Alamofire

enum MethodTypes : String{
    case get
    case post
}

//一次封装
class ELNetTools: NSObject {
    //单例
    static let share = ELNetTools()
    
    private lazy var manager : Alamofire.SessionManager = {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        
//        let serverTrustPolicies : [String: ServerTrustPolicy] = [
//            "baidu.com":ServerTrustPolicy.pinCertificates(certificates: ServerTrustPolicy.certificates(), validateCertificateChain: true, validateHost: true), 
//            "192.168.1.213:8002": ServerTrustPolicy.disableEvaluation
//        ]
//        
//        return Alamofire.SessionManager(configuration: configuration, delegate: SessionDelegate(), serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        
        return Alamofire.SessionManager(configuration: configuration)
        
    }()
    
    typealias SuccessBlock = (_ json: Data) -> ()
    
    typealias FaliedBlock = (Int?, String) -> ()
    
    typealias ProgressBlock  = (Double) -> ()
    
    private func requestData(_ type: MethodTypes, urlString: String, parameters: Parameters?, successBlock: @escaping SuccessBlock, faliedBlock: FaliedBlock?) {
        
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        let encoding = type == .get ? URLEncoding.default : URLEncoding.httpBody
        //        let headers : HTTPHeaders = ["Content-Type":"application/jsoncharset=utf-8","Content-Type": "application/json"] // http
        let headers = type == .get ? nil : ["Content-Type":"application/jsoncharset=utf-8","Content-Type": "application/json"]
        
        TProgressHUD.show()
        manager.request(urlString, method: method, parameters: parameters, encoding: encoding, headers: headers)
            //            .responseJSON { (response) in //responseJSON OC对象 jsonObject
            //                if let value = response.result.value {
            //                    guard let jsonDic = value as? [String: Any] else {
            //                        print("数据返回有误")
            //                        return
            //                    }
            //                }
            //            }
            //JSON 数据 {}= OC 的字典 () = OC数组
            .responseData { (respones) in
                
                TProgressHUD.hide()
                
                
                switch respones.result {
                    
                case .success(let succ): 
                    
                    guard let data = respones.data else {
                        return
                    }
                    printLog(succ)
//                    let dict = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                    
//                    guard  let jsonDic = dict as? [String: Any] else {
//                        printLog("数据返回有误")
//                        return
//                    }
//                    printLog(jsonDic.toJSONString())
                    
                    successBlock(data)
                    
//                    do {
//                        // ***********这里可以统一处理错误码，统一弹出错误 ****
//                        let baseModel = try? JSONDecoder().decode(BaseModel.self, from: json)
//                        guard let model = baseModel else {
//                            printLog("解析失败")
//                            debugPrint("解析--------失败")
//                            faliedBlock?(nil,"解析失败")
//                            return
//                        }
//                        
//                        switch (model.generalCode) {
//                        case HttpCode.success.rawValue :
//                            //数据返回正确
//                            successBlock(json)
//                        case HttpCode.needLogin.rawValue :
//                            //请重新登录
//                            faliedBlock?(model.generalCode, model.generalMessage)
//                            self.alertLogin(model.generalMessage)
//                        default:
//                            //其他错误
//                            self.failureHandle(failure: faliedBlock, stateCode: model.generalCode, message: model.generalMessage)
//                        }
//                    }
                    
                case .failure(let error): 
                    self.failureHandle(failure: faliedBlock, stateCode: nil, message: error.localizedDescription)
                }
        }
        
        
        
    }
    
    //错误处理 - 弹出错误信息
    func failureHandle(failure: ((Int?, String) ->Void)? , stateCode: Int?, message: String) {
        TAlert.show(.error, message)
        failure?(stateCode ,message)
    }
    
    //登录弹窗 - 弹出是否需要登录的窗口
    func alertLogin(_ title: String?) {
        //TODO: 跳转到登录页的操作：
    }
    
}


//二次封装
extension ELNetTools {
    func GET(url: String, params: [String: Any]?, success: @escaping SuccessBlock, failure: FaliedBlock? = nil) {
        requestData(.get, urlString: url, parameters: params, successBlock: success, faliedBlock: failure)
    }
    
    func POST(url: String, params: [String: Any]?, success: @escaping SuccessBlock, failure: FaliedBlock? = nil) {
        requestData(.post, urlString: url, parameters: params, successBlock: success, faliedBlock: failure)
    }
}


#warning("下面的代码需要根据项目进行更改")
/**
 1.状态码 根据自家后台数据更改
 
 - Todo: 根据自己的需要更改
 **/
enum HttpCode : Int {
    case success = 1 //请求成功的状态吗
    case needLogin = -1  // 返回需要登录的错误码
}

/**
 2.为了统一处理错误码和错误信息，在请求回调里会用这个model尝试解析返回值
 - Todo: 根据自家后台更改。
 **/
struct BaseModel: Decodable {
    var code: Int
    var data: Content
    struct Content: Decodable {
        var message: String
    }
}

//下面的错误码及错误信息用来在HttpRequest中使用
extension BaseModel {
    var generalCode: Int {
        return code
    }
    
    var generalMessage: String {
        return data.message
    }
}


