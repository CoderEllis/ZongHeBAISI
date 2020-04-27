//
//  ELSquareItem.swift
//  index
//
//  Created by Soul on 28/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

@objcMembers class ELSquareItem: NSObject {
     var name: String? //@objc
     var url : String?
     var icon : String?
             //key  - Type   value 就是外来赋值的那个
    init(_ dic: [String: Any]) {
        super.init()
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
//        printLog(value as Any)
//        printLog(key)
        
    }
    
}




