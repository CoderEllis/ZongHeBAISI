//
//  UILable+Extension.swift
//  VideoPlayer
//
//  Created by Soul on 9/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(text: String? = nil, textColor : UIColor, fontSize : CGFloat) {
        self.init()
        if text != nil {
            self.text = text
        }
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: fontSize)
    }
}
