//
//  UIView+Position.swift
//  VideoPlayer
//
//  Created by Soul on 9/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

extension UIView {
    
    public var x : CGFloat {
        set {
            var rect = self.frame
            rect.origin.x = newValue
            self.frame = rect
        }
        get {
            return self.frame.origin.x
        }
    }
    
    public var y : CGFloat {
        set {
            var rect = self.frame
            rect.origin.y = newValue
            self.frame = rect
        }
        get {
            return self.frame.origin.y
        }
    }
    
    public var width : CGFloat {
        set {
            var rect = self.frame
            rect.size.width = newValue
            self.frame = rect
        }
        get {
            return self.frame.size.width
        }
    }
    
    public var height : CGFloat {
        set {
            var rect = self.frame
            rect.size.height = newValue
            self.frame = rect
        }
        get {
            return self.frame.size.height
        }
    }
    
    public var el_center : CGPoint {
        set {
            center = CGPoint(x: newValue.x, y: newValue.y)
        }
        
        get {
            return CGPoint(x: bounds.width/2, y: bounds.height/2)
        }
    }
    
    public var centerX : CGFloat {
        set {
            var center = self.center
            center.x = newValue
            self.center = center
        }
        get {
            return self.center.x
        }
    }
    
    public var centerY : CGFloat {
        set {
            var center = self.center
            center.y = newValue
            self.center = center
        }
        get {
            return self.center.y
        }
    }
    
    public var maxX : CGFloat {
        get {
            return self.frame.maxX
        }
    }
    
    public var maxY : CGFloat {
        get {
            return self.frame.maxY
        }
    }
    
    public var origin : CGPoint {
        set {
            self.x = newValue.x
            self.y = newValue.y
        }
        get {
            return self.frame.origin
        }
    }
    
    public var size : CGSize {
        set {
            self.width = newValue.width
            self.height = newValue.height
        }
        get {
            return self.frame.size
        }
    }
    
    /// 右边界的x值
    public var rightX : CGFloat {
        set {
            var rect = self.frame
            rect.origin.x = newValue - frame.size.width
            self.frame = rect
        }
        get {
            return self.x  + self.width
        }
    }
    
    /// 下边界的y值
    public var rightY : CGFloat {
        set {
            var rect = self.frame
            rect.origin.y = newValue - frame.size.height
            self.frame = rect
        }
        get {
            return self.y  + self.height
        }
    }
}
