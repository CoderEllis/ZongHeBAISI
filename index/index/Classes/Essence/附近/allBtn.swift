//
//  allBtn.swift
//  allClick
//
//  Created by Soul on 8/7/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class allBtn: UIButton {

    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 设置图片位置
        imageView?.frame.origin.y = 0
        imageView?.center.x = frame.size.width * 0.5
        
        //设置标题的位置
        titleLabel?.frame.origin.y = frame.size.height - (titleLabel?.frame.size.height)!
        
        // 计算文字宽度 , 设置label的宽度
        titleLabel?.sizeToFit()
        titleLabel?.center.x = frame.size.width * 0.5
        
    }
}
