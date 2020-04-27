//
//  ELSubTagAPI.swift
//  index
//
//  Created by Soul on 26/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import Foundation
import Moya
import HandyJSON

let ELSubTagProvider = MoyaProvider<ELSubTagAPI>()

// 请求分类
enum ELSubTagAPI {
    case tuijian
}

extension ELSubTagAPI: TargetType {
    
    // 服务器地址
    var baseURL: URL {
        switch self {
        case .tuijian:
            return URL(string: "http://api.budejie.com/api/api_open.php")!
        }
    }
    
    // 各个请求的具体路径
    var path: String {
        switch self {
        case .tuijian:
            return ""
        }
    }
    
    // 请求类型
    var method: Moya.Method {
        return .get
    }
    
    // 这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    // 请求任务事件（这里附带上参数
    var task: Task {
        var parmeters:[String:Any] = [:]
        switch self {
            
        case .tuijian:
            parmeters = [
                "a":"tag_recommend",
                "action":"sub",
                "c":"topic"
            ]
            
        }
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
    
    // 请求头
    var headers: [String : String]? {
        return nil
    }
    
    
}
