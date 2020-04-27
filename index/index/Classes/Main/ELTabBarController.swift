//
//  ELTabBarController.swift
//  index
//
//  Created by Soul on 25/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tabBar = UITabBarItem.appearance(whenContainedInInstancesOf: [ELTabBarController.self])
        
        let normal = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : UIColor.gray]
        let selected = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        tabBar.setTitleTextAttributes(normal, for: .normal)
        tabBar.setTitleTextAttributes(selected, for: .selected)
        
        
        setupAllChildViewController()
        setupTabBar()
        
    }
    
    
    // MARK: - 自定义tabBar
    func setupTabBar () {
        setValue(ELTabBar(), forKey: "tabBar")
    }
    
    
    fileprivate func setupAllChildViewController() {
        let vcArray = [ELEssenceViewController(), ELNewViewController(), ELFriendTrendViewController(), UIStoryboard(name: "ELMeViewController", bundle: nil).instantiateInitialViewController() as! ELMeViewController]
        
        let titleArray = [("精华", "essence"), ("新帖", "new"), ("关注", "friendTrends"), ("我", "me")]
        
        for i in 0..<vcArray.count {
            addChild(vcArray[i], title: titleArray[i].0, imageName: titleArray[i].1)
        }
        
    }
    
    fileprivate func addChild(_ childController: UIViewController, title: String, imageName: String) {
        childController.tabBarItem.title = title
        childController.tabBarItem.image =  UIImage(named: "tabBar_\(imageName)_icon")
        childController.tabBarItem.selectedImage = UIImage(named: "tabBar_\(imageName)_click_icon")?.withRenderingMode(.alwaysOriginal) ///采用图片原生颜色
        addChild(ELNavigationController(rootViewController: childController))
    }
    
    //简写1
    fileprivate func setupUI() {
        let vcArray = [ELEssenceViewController(), ELNewViewController(), ELFriendTrendViewController(), UIStoryboard(name: "ELMeViewController", bundle: nil).instantiateInitialViewController() as! ELMeViewController]
        
        let titleArray = [("精华", "essence"), ("新帖", "new"), ("关注", "friendTrends"), ("我", "me")]
        for (i, vc) in vcArray.enumerated() {
            vc.tabBarItem.title = titleArray[i].0
            vc.tabBarItem.image = UIImage(named: "tabBar_\(titleArray[i].1)_icon")
            vc.tabBarItem.selectedImage = UIImage(named: "tabBar_\(titleArray[i].1)_click_icon")?.withRenderingMode(.alwaysOriginal) //采用图片原生颜色
            addChild(ELNavigationController(rootViewController: vc))
            
        }
    }
    
    //简写2
    fileprivate func setupAllChildVC() {
        let vcArray = [ELEssenceViewController(), ELNewViewController(), ELFriendTrendViewController(), UIStoryboard(name: "ELMeViewController", bundle: nil).instantiateInitialViewController() as! ELMeViewController]
        
        let titleArray = [("精华", "essence"), ("新帖", "new"), ("关注", "friendTrends"), ("我", "me")]
        
        for i in 0..<vcArray.count {
            vcArray[i].tabBarItem.title = titleArray[i].0
            vcArray[i].tabBarItem.image =  UIImage(named: "tabBar_\(titleArray[i].1)_icon")
            vcArray[i].tabBarItem.selectedImage = UIImage(named: "tabBar_\(titleArray[i].1)_click_icon")?.withRenderingMode(.alwaysOriginal) ///采用图片原生颜色
            addChild(ELNavigationController(rootViewController: vcArray[i]))
            
        }
        
    }
    
}
