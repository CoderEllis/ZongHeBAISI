//
//  UITextField+Placeholder.swift
//  index
//
//  Created by Soul on 1/6/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

extension UITextField {
   
    private struct RuntimeKey {
        static let newPropertyKey = UnsafeRawPointer(bitPattern: "placeholderColor".hashValue)!
    }
    
    public var placeholderColor : UIColor? {
        set {
            /**
             * 第一个参数：关联的对象：给哪一个对象添加关联，这里就传哪一个对象
             * 第二个参数：关联的key，通过这个key设置（存储）对应的值，这里定义了一个newPropertyKey的key
             * 第三个参数：关联的值，即通过key所关联的值，在get方法中获取的就是这个值
             * 第四个参数：关联的方式
             */
            
            objc_setAssociatedObject(self, RuntimeKey.newPropertyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            let placeholderLabel : UILabel = self.value(forKey: "placeholderLabel") as! UILabel
            placeholderLabel.textColor = placeholderColor
        }
        get {
            return objc_getAssociatedObject(self, RuntimeKey.newPropertyKey) as? UIColor
        }
    }
    
}
