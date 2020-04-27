//
//  UIBarButtonItem-Extension.swift
//  index
//
//  Created by Soul on 26/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    ///普通和高亮
    convenience init(backItemWithimage: String, target: Any?, ation: Selector, title: String) {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.setImage(UIImage(named: backItemWithimage), for: .normal)
        btn.setImage(UIImage(named: "\(backItemWithimage)Click"), for: .highlighted)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitleColor(UIColor.red, for: .highlighted)
        btn.sizeToFit()
        btn.addTarget(target, action: ation, for: UIControl.Event.touchUpInside)
        self.init(customView: btn)
    }
    
    ///左边导航按钮highImage
    convenience init(itemWithimage: String, highImage: String, target: Any?, ation: Selector) {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: itemWithimage), for: .normal)
        btn.setImage(UIImage(named: highImage), for: .highlighted)
        btn.sizeToFit()
        btn.addTarget(target, action: ation, for: UIControl.Event.touchUpInside)
        self.init(customView: btn)
    }
    
    ///左边导航按钮selected
    convenience init(itemWithimage: String, selected: String, target: Any?, ation: Selector) {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: itemWithimage), for: .normal)
        btn.setImage(UIImage(named: selected), for: .selected)
        btn.sizeToFit()
        btn.addTarget(target, action: ation, for: UIControl.Event.touchUpInside)
        self.init(customView: btn)
    }
    
    convenience init(itemColor: UIColor, highColor: UIColor, target: Any?, ation: Selector, title: String) {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(itemColor, for: .normal)
        btn.setTitleColor(highColor, for: .highlighted)
        btn.setTitle(title, for: UIControl.State.normal)
        btn.sizeToFit()
        btn.addTarget(target, action: ation, for: UIControl.Event.touchUpInside)
        self.init(customView: btn)
    }
}
