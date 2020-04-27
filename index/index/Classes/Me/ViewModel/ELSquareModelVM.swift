//
//  ELSquareModel.swift
//  index
//
//  Created by Soul on 14/10/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELSquareModelVM: NSObject {
    
    var square_list : [Square]?

    typealias ELSquareModelVMReturnBlock = () -> ()
    var updateDataBlock : ELSquareModelVMReturnBlock?
    
    typealias faliedBlock = (Int?, String) -> ()
    
    func squareRequestData( _ falied: faliedBlock?) {
        let parameters = [
            "a":"square",
            "c":"topic"] as [String: Any]
        
        ELNetTools.share.GET(url: "http://api.budejie.com/api/api_open.php", params: parameters, success: { (jsonData) in
            
            let sss = try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
//            printLog(sss.toJSONString())
            let arr = sss["square_list"] as! [Any]
//            arr.removeLast()
            
            var dic = [Any]()
            for i in arr {//去除空数据
                if (i as? [String:Any] != nil) {
                    dic.append(i)
                }
            }
            
            
//            printLog(arr.toJSONString())
//            let data = dic.toJSONString()?.data(using: String.Encoding.utf8)
            let data = dic.toData()
            
            
            
            do {
                let str = try JSONDecoder().decode([Square].self, from: data!)
//                printLog(str)
                self.square_list = self.resloveData(str)
                self.updateDataBlock?()
            } catch let error as NSError {
                printLog(error)
            }
            
        }, failure: falied)
        
    }
    
    
    func resloveData(_ cou: [Square])-> [Square] {
        // 判断下缺几个
        // 3 % 4 = 3 cols - 3 = 1
        //5 % 4 = 1 cols - 1 = 3
        var items = cou
        let cols = 4
        let count = items.count
        var exter = count % cols
        if exter != 0 {
            exter = cols - exter
            for _ in 0..<exter {
                let item = Square.init(url: "", name: "", icon: "")
                items.append(item)
            }
        }
        return items
    }
    
}

struct Square : Codable {//Mappable
    public let url : String
    public let name : String
    public let icon : String
    
}


struct ELSquareModelStruct: Codable {
    public let square_list : Array<Square>?
    
//    private enum CodingKeys : String , CodingKey {
//        case square_list
//        case tag_list
//    }
    let tag_list : [Tag]?
}

struct Tag: Codable {
    public let theme_id : String
    public let theme_name : String
}

