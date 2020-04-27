//
//  UIBarButtonItem+Extension.swift
//  VideoPlayer
//
//  Created by Soul on 9/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    ///快速构造函数
    convenience init( imageName : String? = nil, title: String? = nil, target: Any?, action: Selector) {
        self.init()
        
        let button = UIButton()
        if imageName != nil {
            button.setImage(UIImage(named: imageName!), for: .normal)
//            button.setImage(UIImage(named: imageName!+"_highlighted"), for: .highlighted)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        }
        
        if title != nil {
            button.setTitle(title!, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitleColor(UIColor.blue, for: .highlighted)
            button.setTitleColor(UIColor.darkGray, for: .disabled)
        }
        button.addTarget(target, action: action, for: .touchUpInside)
        button.sizeToFit()
        customView = button
    }
    
}
