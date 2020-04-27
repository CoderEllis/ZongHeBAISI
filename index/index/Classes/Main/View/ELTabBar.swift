
//
//  ELTabBar.swift
//  index
//
//  Created by Soul on 25/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELTabBar: UITabBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func setUI() {
        addSubview(publishButton)
    }
    
    
    fileprivate lazy var publishButton : UIButton = {
        let publishButton = UIButton(type: UIButton.ButtonType.custom)
        publishButton.setImage(UIImage(named: "tabBar_publish_icon"), for: .normal)
        publishButton.setImage(UIImage(named: "tabBar_publish_click_icon"), for: .selected)
        publishButton.addTarget(self, action: #selector(tabBarButtonChick(_:)), for: .touchUpInside)
        publishButton.sizeToFit()
        return publishButton
    }()
    
    var previousClickedTabBarButton : UIControl?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let count = (items?.count)!
        
        let btnW = width / CGFloat(count + 1)
        
        var index : CGFloat = 0
        
        for tabBarbutton in subviews {
            if type(of: tabBarbutton).description() == "UITabBarButton" {
                if (index == 0 && previousClickedTabBarButton == nil ){ //进来默认第一个已经点击 并且 为空的时候
                    previousClickedTabBarButton = tabBarbutton as? UIControl
                }
                
                let buttonX = (index < 2) ? index * btnW : (index + 1) * btnW
                tabBarbutton.frame = CGRect(x: buttonX, y: 0, width: btnW, height: 49)
                index += 1
                
                (tabBarbutton as! UIControl).addTarget(self, action: #selector(reTabBarButtonChick(_:)), for: .touchUpInside)
            }
        }
        
        publishButton.center = CGPoint(x: width/2, y: 49/2)
        
    }
    
    
    @objc func tabBarButtonChick(_ tabBarButton: UIButton) {
        let pushVc = ELPublishV()
        UIApplication.shared.keyWindow?.addSubview(pushVc)
        pushVc.frame = (UIApplication.shared.keyWindow?.bounds)!
    }
    
    @objc func reTabBarButtonChick(_ tabBarButton : UIControl) {
        if previousClickedTabBarButton == tabBarButton {
            print("重复点击")
            // 发出通知
            NotificationCenter.default.post(name: NSNotification.Name(ELTabBarButtonDidRepeatClickNotification), object: nil)
        }
        
        previousClickedTabBarButton = tabBarButton
    }
    
}
