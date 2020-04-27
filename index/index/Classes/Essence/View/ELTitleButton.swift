//
//  ELTitleButton.swift
//  index
//
//  Created by Soul on 6/6/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELTitleButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.font = UIFont.systemFont(ofSize: 16)
        setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        setTitleColor(UIColor.red, for: UIControl.State.selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 只要重写了这个方法，按钮就无法进入highlighted状态
    override var isHighlighted: Bool {
        set {
            
        }
        get {
            return false
        }
    }
}
