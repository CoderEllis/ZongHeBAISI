//
//  ELFastButton.swift
//  index
//
//  Created by Soul on 31/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELFastButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        // 设置图片位置
        imageView?.y = 0
        imageView?.centerX = self.width * 0.5
        
        //设置标题的位置
        titleLabel?.y = self.height - (titleLabel?.height)!
        
        // 计算文字宽度 , 设置label的宽度
        titleLabel?.sizeToFit()
        titleLabel?.centerX = self.width * 0.5
        
    }

}
