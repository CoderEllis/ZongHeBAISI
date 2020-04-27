//
//  NibLoadable.swift
//  VideoPlayer
//
//  Created by Soul on 5/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//


//面向协议
import UIKit

protocol ViewLoadNib {
}

///快速通过xib创建的类方法
extension ViewLoadNib where Self : UIView {
    static func loadNib(_ nibName : String? = nil) -> Self {
        let loadName = nibName == nil ? "\(self)" : nibName!
        return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
}

//    /// MARK:- 提供快速通过xib创建的类方法
//    class func loadFromNib() -> PlayerView {
//        return Bundle.main.loadNibNamed("PlayerView", owner: nil, options: nil)?.first as! PlayerView
//    }

/*
 //直接加载bundle  (有缓存)
 let imag = UIImage(named: "Player.bundle/Test")
 
 //没有缓存的加载方法
 let file = Bundle.main.path(forResource: "Player.bundle/Test", ofType: "png")
 let image = UIImage(contentsOfFile: file!)
 
 //这种写法意义不大
 let path = Bundle.main.path(forResource: "Player", ofType: "bundle")
 let bundle = Bundle(path: path!)
 let file2 = bundle?.path(forResource: "Test", ofType: "png")
 
 */

//协议的使用
//一定要在  extension 中写方法的实现

//协议封装动画
protocol Shakable {
    
}

extension Shakable where Self : UIView{
    
    func shake(){
        
        //创建核心动画
        
        let animate = CAKeyframeAnimation(keyPath: "transform.translate.x")
        
        //设置属性
        
        animate.duration = 0.1
        
        animate.values = [-8,0,8,0]
        
        animate.repeatCount = 5
        
        //layer蹭上添加动画
        
        layer.add(animate, forKey: nil)
        
    }
    
}

protocol Flashable {
    
}

extension Flashable where Self : UIView{
    
    func flash(){
        
        UIView.animate(withDuration: 0.25) {
            
            self.alpha = 1.0
            
            UIView.animate(withDuration: 0.25, delay: 2, options: [], animations: {
                
                self.alpha = 0
                
            }, completion: nil)
        }
    }
    
}
