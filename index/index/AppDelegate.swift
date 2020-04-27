//
//  AppDelegate.swift
//  index
//
//  Created by Soul on 25/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    /** *控制屏幕旋转 */
    var allowRotation = false
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if allowRotation {
            return .allButUpsideDown
        }
        return .portrait
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let elTabBarVC = ELAddViewController() //ELTabBarController()
        window?.rootViewController = elTabBarVC
        
        window?.makeKeyAndVisible()
        
        // 5.每次启动程序，都清除过期的图片
        KingfisherManager.shared.cache.clearMemoryCache()
        
        let manager = IQKeyboardManager.shared
        //控制整个功能是否启用
        manager.enable = true
        //控制点击背景是否收起键盘
        manager.shouldResignOnTouchOutside = true
        //控制键盘上的工具条文字颜色是否用户自定义
        manager.shouldToolbarUsesTextFieldTintColor = true
        //控制是否显示键盘上的工具条
        manager.enableAutoToolbar = true
        
        return true
    }
    
    //         sceneWillResignActive
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    //         sceneDidEnterBackground
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    //         sceneWillEnterForeground
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    //         sceneDidBecomeActive
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

