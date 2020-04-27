//
//  NetworkTools.swift
//  index
//
//  Created by Soul on 28/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

// API 接口定义
struct ConstAPI {
    
    /** 统一的一个请求路径 */
    static let ELCommonURL : String = "http://api.budejie.com/api/api_open.php"
     
}

class NetworkTools : NSObject {
    //单例
    static let shareInstance = NetworkTools()
    
    private var manager: Alamofire.SessionManager = {
        
        let configuration = URLSessionConfiguration.default
        
        configuration.timeoutIntervalForRequest = 10
        
        return Alamofire.SessionManager(configuration: configuration)
        
    }()
    
    ///get
    func getRequest(_ url: String? = ConstAPI.ELCommonURL,param: [String: Any]?, successBlock: @escaping(_ json:JSON) -> Void, failure: @escaping(_ error: Error) -> Void) { // JSONEncoding 与 URLEncoding 服务接受数据的区别
        
        manager.request(url!, method: .get, parameters: param, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
//            printLog(response.response) 
//            printLog(response.request)
            
            switch response.result {
            case .success(let value): //这里的data就是response的数据
                
                let json = JSON(value)
                successBlock(json)
                
//                guard let resultDict = result as? [String:Any] else {return}
//                var array = resultDict["square_list"] as! [Any]
//                array.removeLast()//移除空数据
//                let sss = array as? [[String : Any]] //数组字典
//                NSDictionary(dictionary: dictionary).write(toFile: "/Users/soulai/Desktop/222.plist", atomically: true) //写入plist
//                    printLog(sss)
            
            case .failure(let error): //这里的err就是网路链接失败返回的数据
                failure(error)
            }
        }
        
    }
    

    
}
