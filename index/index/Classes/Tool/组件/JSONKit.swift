//
//  CodableTool.swift
//  index
//
//  Created by Soul on 1/8/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import Foundation

enum MapError: Error {
    case jsonToModelFail    //json转model失败
    case jsonToDataFail     //json转data失败
    case jsonToArrFail      //json转数组失败
    case dictToJsonFail     //字典转json失败
    case modelToJsonFail    //model转json失败
}

public protocol Mappable: Codable {//系统 Codable 协议 不允许扩展
    func modelMapFinished()
    mutating func structMapFinished()
}

extension Mappable {
    //默认实现协议
    public func modelMapFinished() {
        print("1111111---------")
        //外部自己实现
    }
    
    public mutating func structMapFinished() {
        print("2222222--------")
        //外部自己实现
    }
    //字典转模型: 字典 ->Serialization oc (对象)字典序列化成 json ->编码输出 JSONString字符串 -> 转码jsondata -> JSONDecoder解码 -> 模型
    ///字典转模型
    public static func mapFromDict<T : Mappable>(_ dict: [String: Any], _ type: T.Type) throws -> T {
//        guard let data = dict.toData(), let JSONString = data.toString() else { 
//            print(MapError.dictToJsonFail)
//            throw MapError.dictToJsonFail 
//        }
//        guard let jsonData = JSONString.data(using: .utf8) else {
//            print(MapError.jsonToDataFail)
//            throw MapError.jsonToDataFail
//        }
        guard let jsonData = dict.toData() else {
            print(MapError.dictToJsonFail)
            throw MapError.dictToJsonFail 
        }
        
        do {//OC --- DATA----json
            let obj = try JSONDecoder().decode(type, from: jsonData)
            var vobj = obj
            let mirro = Mirror(reflecting: vobj)
            
            if mirro.displayStyle == Mirror.DisplayStyle.struct {
                vobj.structMapFinished()
            }
            if mirro.displayStyle == Mirror.DisplayStyle.class {
                vobj.modelMapFinished()
            }
            return vobj
        } catch {
            print(error)
        }
        
        throw MapError.jsonToModelFail
    }
    //JSON转模型:  JSON -> 编码jsonData -> JSONDecoder解码 -> 模型
    ///JSON转模型
    static func mapFromJson<T : Mappable>(_ JSONString: String, _ type: T.Type) throws -> T {
        guard let jsonData = JSONString.data(using: .utf8) else {
            print(MapError.jsonToDataFail)
            throw MapError.jsonToDataFail
        }
        
        let decoder = JSONDecoder()
        do {
            let obj = try decoder.decode(type, from: jsonData)
            var vobj = obj
            let mirro = Mirror(reflecting: vobj)
            
            if mirro.displayStyle == Mirror.DisplayStyle.struct {
                vobj.structMapFinished()
            }
            if mirro.displayStyle == Mirror.DisplayStyle.class {
                vobj.modelMapFinished()
            }
            return vobj
        } catch {
            print(error)
        }
        
        print(MapError.jsonToModelFail)
        throw MapError.jsonToModelFail
    }
    
    //模型转字典:  模型 -> 创建临时字典装载 遍历模型取出key对应的value的值
    ///模型转字典
    public func reflectToDict() -> [String: Any] {
        let mirro = Mirror(reflecting: self)
        var dict = [String: Any]()
        for case let (key?, value) in mirro.children {
            dict[key] = value
        }
        return dict
        
    }
    
    //模型转json字符串:  模型 ->字典  -> Serialization字典序列化成data ->编码输出 JSONString
    ///模型转json字符串
    public func reflectTotoJSON() throws -> String {
        if let str = self.reflectToDict().toData()?.toString() {
            return str
        }
        print(MapError.modelToJsonFail)
        throw MapError.modelToJsonFail
    }
    
    ///编码 JSONEncoder
    func toData() -> Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted //输出格式好看点
        do {
            return  try encoder.encode(self)
        } catch  {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
}




extension Array {
    ///数组OC转data 序列化
    func toData() -> Data? {
        if JSONSerialization.isValidJSONObject(self) {
            if let newData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
                return newData
            }
        }
        print("array转data失败")
        return nil
    }
    
}

extension Dictionary {
    ///字典OC转data 序列化
    func toData() -> Data? {
        if JSONSerialization.isValidJSONObject(self) {//给定对象可以转换为json数据，则返回yes，否则返回no
            if let newData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
                return newData
            }
        }
        print("dict转data失败")
        return nil
    }
    
}


extension String {
    ///字符串转 data
    func toData() -> Data? {
        if JSONSerialization.isValidJSONObject(self) {
            return self.data(using: .utf8)
        }
        print("json转data失败")
        return nil
    }
}


let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, .userDomainMask, true).first
let cachePathUrl = URL(fileURLWithPath: cachePath!)


// MARK: - 类扩展读写方法 转换json
extension Data {
    
    func toModel<T: Codable>(modelType: T.Type) -> T? {
        do {
            return try JSONDecoder().decode(modelType, from: self)
        } catch  {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
    ///data转字符串
    func toString() -> String? {
        return String(data: self, encoding: .utf8)
    }
    
    
    /// Data-> OC 字典 反序列化
    func toDictionary(options: JSONSerialization.ReadingOptions) -> Dictionary<String,Any>? {
        if let data = try? JSONSerialization.jsonObject(with: self, options: options) {
            if let result = data as? Dictionary<String,Any> {
                return result
            }
        }
        return nil
        
    }
    
    /// Data->  OC 数组 反序列化
    func toArray(options: JSONSerialization.ReadingOptions) -> Array<Any>? {
        if let data = try? JSONSerialization.jsonObject(with: self, options: options) {
            if let result = data as? Array<Any> {
                return result
            }
        }
        return nil
        
    }
    
    
    ///写入到桌面 writeTo  -> JsonFile  
    func writeTo(_ jsonFileName:String) {
        do {
            try self.write(to: URL(fileURLWithPath: "/Users/soulai/Desktop/\(jsonFileName).json"))
        } catch {
            print("写入失败,检查路径")
        }
        
    }
    
    ///write data 写入到沙盒
    func write(_ toCacheFilename: String) -> Bool {
        try? FileManager.default.createDirectory(at: cachePathUrl, withIntermediateDirectories: true, attributes: nil)
        
        let url = cachePathUrl.appendingPathComponent(toCacheFilename)
        do {
            try self.write(to: url)
            return true
        } catch {
            return false
        }
        
    }
    
    ///read data 读取沙盒
    init?(_ cachefileName: String) {
        let url = cachePathUrl.appendingPathComponent(cachefileName)
        do {
            try self.init(contentsOf: url, options: .alwaysMapped)
        }catch {
            return nil
        }
    }
    
}
