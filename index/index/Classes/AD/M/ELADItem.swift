//
//  ELADItem.swift
//  index
//
//  Created by Soul on 28/7/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

@objcMembers class ELADItem: NSObject {
    var w : CGFloat?
    var h : CGFloat?
    
    init(_ dict: [String: Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}










struct ELADModel : Codable {
    
    var iap_buy : Int
    var ext_style : String = "" 
    var aaa : Int
    
    var ad : [Add]
    
    //右边是服务器返回的key要对应  key 映射
    private enum CodingKeys: String, CodingKey { 
        case iap_buy
        case aaa = "n" 
        
        case ad
    }
    
    struct Add : Codable {
        var qk : String = ""
        var id : Int = 0
        var closetype : Int = 0
        ///点击广告跳转的界面
        var curl : String = ""
        var winurl : String
        ///广告地址
        var w_picurl : String
        var mimetype : String = ""
        var type : String = ""
        var act : Int
        var adtd : Int = 0
        var buyer : Int = 0
        
        //新增属性
//        var height: Int
//        var weight: Int
        
        enum CodingKeys: String, CodingKey {
            case w_picurl
            case act
            case winurl
            
//            case body
        }
        
//        enum BodyKeys: String, CodingKey {
//            
//            case height
//            case weight
//            
//        }
        // 用于解析数据
        init(from decoder: Decoder) throws {
            let vals = try decoder.container(keyedBy: CodingKeys.self)
            
            w_picurl = try vals.decode(String.self, forKey: CodingKeys.w_picurl)
            act = try vals.decode(Int.self, forKey: CodingKeys.act)
            winurl = try vals.decode(String.self, forKey: CodingKeys.winurl)
            
//            let body = try vals.nestedContainer(keyedBy: BodyKeys.self, forKey: .body)
//            height = try body.decode(Int.self, forKey: .height)
//            weight = try body.decode(Int.self, forKey: .weight)
        }
        
        //用于编码数据
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(w_picurl, forKey: .w_picurl)
            try container.encode(act, forKey: .act)
            try container.encode(winurl, forKey: .winurl)
            
//            var body = container.nestedContainer(keyedBy: BodyKeys.self, forKey: .body)
//            try  body.encode(weight, forKey: .weight)
//            try  body.encode(height, forKey: .height)
            
        }
        
    }
}












///VM
class VMModel: NSObject {
    //    var square : ELSquareModel?
    //    var code: Int = 0
    var list : Addd?
    var ad : ELADModel?
    typealias ELSquareModelVMReturnBlock = () -> ()
    var updateDataBlock : ELSquareModelVMReturnBlock?
    
    func squareRequestData() {
        
        let parameters = ["code2":"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"] as [String: Any]
        
        ELNetTools.share.GET(url: "http://mobads.baidu.com/cpro/ui/mads.php", params: parameters, success: { (jsonData) in
            //这步可以网络请求直接返回jsonstring (字典)
            let dict = try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
            
            
//            printLog(jsonAttay[0] as! [String: Any])
            guard let jsonArray = dict["ad"] as? [Any], let dataDic =  jsonArray.last as? [String: Any] else {
                printLog("数据有误")
                return
            }
            let data = try! JSONSerialization.data(withJSONObject: dataDic, options: .prettyPrinted)
            
            let str = try? JSONDecoder().decode(Addd.self, from: data)
            
            
            
            self.list = str
            self.updateDataBlock?()
        })
        
    }
}

struct Addd : Mappable {//Mappable
    ///点击广告跳转的界面
    var curl : String = ""
    var winurl : String
    ///广告地址
    var w_picurl : String
    
    enum CodingKeys: String, CodingKey {
        case w_picurl
        case curl
        case winurl
    }
}
