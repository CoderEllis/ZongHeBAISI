///Users/soulai/Desktop/index/index
//  ELFileTool.swift
//  index
//
//  Created by Soul on 29/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELFileTool: NSObject {
    
    
    /// 删除文件夹所有文件
    ///
    /// - Parameter directoryPath: 文件夹路径
    class func removeDirectoryPath(directoryPath: String) {
        // 获取文件管理者
        let fileManager = FileManager.default
        // 判断是否文件夹
        var isDirectory : ObjCBool = false
        
        // 判断文件是否存在,并且判断是否是文件夹
        let isExist : Bool = fileManager.fileExists(atPath: directoryPath, isDirectory: &isDirectory)
        
        // name:异常名称
        // reason:报错原因
        if (!isExist || !isDirectory.boolValue) {
            let excp = NSException(name: NSExceptionName(rawValue: "pathError"), reason: "额??需要传入的是文件夹路径,并且路径要存在", userInfo: nil)
            //抛异常
            excp.raise() 
        }
        
        // NSFileManager
        // attributesOfItemAtPath:指定文件路径,就能获取文件属性
        // 把所有文件尺寸加起来
        // 获取cache文件夹下所有文件,不包括子路径的子路径
        do {
            let subPaths = try fileManager.contentsOfDirectory(atPath: directoryPath)
            for subPath in subPaths {
                // 拼接完成全路径
                let filePath = directoryPath.appending("/\(subPath)")
                try fileManager.removeItem(atPath: filePath)
            }
        } catch {
            print("error :\(error)")
        }
        
        
        
        
    }
    
    
    /// 获取文件夹尺寸
    ///
    /// - Parameters:
    ///   - directoryPath: 文件夹路径
    ///   - completion: 数据回调
    class func getFileSize(directoryPath: String, completion : @escaping (_ completion: UInt64) -> Void ) {
        // 获取文件管理者
        let fileManager = FileManager.default
        // 判断是否文件夹
        var isDirectory : ObjCBool = false
        
        // 判断文件是否存在,并且判断是否是文件夹
        let isExist : Bool = fileManager.fileExists(atPath: directoryPath, isDirectory: &isDirectory)
        
        // name:异常名称
        // reason:报错原因
        if (!isExist || !isDirectory.boolValue) {
            let excp = NSException(name: NSExceptionName(rawValue: "pathError"), reason: "额??需要传入的是文件夹路径,并且路径要存在", userInfo: nil)
            //抛异常
            excp.raise() 
        }
        
        DispatchQueue.global().async { 
            // 获取文件夹下所有的子路径
            guard let subPaths = fileManager.subpaths(atPath: directoryPath) else {return}
            var totalSize : UInt64 = 0
            // 遍历文件夹所有文件,一个一个加起来
            for subPath in subPaths {
                let pilePath = directoryPath.appending("/\(subPath)")
                // 获取文件全路径
                if (pilePath.contains(".DS")) {continue}
                
                // 判断是否文件夹
                var isDirectory : ObjCBool = false
                
                // 判断文件是否存在,并且判断是否是文件夹
                let isExist : Bool = fileManager.fileExists(atPath: directoryPath, isDirectory: &isDirectory)
                if (!isExist || !isDirectory.boolValue) {continue}
                
                // 获取文件属性
                // attributesOfItemAtPath:只能获取文件尺寸,获取文件夹不对,
                do {
                    let attr = try fileManager.attributesOfItem(atPath: pilePath)
                    // 获取文件尺寸
                    let fileSize = attr[FileAttributeKey.size] as! UInt64 
                    totalSize += fileSize
                    
                    //如果您转换为NSDictionary，您也可以通过旧方式获取文件大小
//                    _ = (attr as NSDictionary).fileSize()
                } catch {
                     print("error :\(error)")
                }
            }
            
            //计算完成回调 回到主线程
            DispatchQueue.main.async {
                completion(totalSize)
            }
            
        }
        
    }
    
}


extension String {
    ///获取文件大小
    func getFileSize() -> UInt64  {
        var size: UInt64 = 0
        let fileManager = FileManager.default
        var isDir: ObjCBool = false
        let isExists = fileManager.fileExists(atPath: self, isDirectory: &isDir)
        // 判断文件存在
        if isExists {
            // 是否为文件夹
            if isDir.boolValue {
                // 迭代器 存放文件夹下的所有文件名
                let enumerator = fileManager.enumerator(atPath: self)
                for subPath in enumerator! {
                    // 获得全路径
                    let fullPath = self.appending("/\(subPath)")
                    do {
                        let attr = try fileManager.attributesOfItem(atPath: fullPath)
                        size += attr[FileAttributeKey.size] as! UInt64
                    } catch  {
                        print("error :\(error)")
                    }
                }
            } else { // 单文件
                do {
                    let attr = try fileManager.attributesOfItem(atPath: self)
                    size += attr[FileAttributeKey.size] as! UInt64
                    
                } catch  {
                    print("error :\(error)")
                }
            }
        }
        return size
    }
}


