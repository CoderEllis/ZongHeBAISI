//
//  UITabBarController+Rotation.swift
//  VideoPlayer
//
//  Created by Soul on 9/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

extension UITabBarController {
    
    // 重写 shouldAutorotate 属性，保证 TabBarController 嵌套下的控制器能根据自身属性决定是否旋转
    open override var shouldAutorotate: Bool {
        return viewControllers!.last!.shouldAutorotate
    }
    
}
