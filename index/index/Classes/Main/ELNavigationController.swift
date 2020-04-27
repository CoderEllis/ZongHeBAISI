//
//  ELNavigationController.swift
//  index
//
//  Created by Soul on 25/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(interactivePopGestureRecognizer?.delegate as Any) // 打印查看KVC属性
        defaultSetting()
//        setUpGlobalPan() 
        jubufanhui()
    }
    
    
    /// 全局拖拽手势
    fileprivate func setUpGlobalPan() {
        //全屏滑动返回
        let handler: Selector = NSSelectorFromString("handleNavigationTransition:")
        let globalPan = UIPanGestureRecognizer(target: self.interactivePopGestureRecognizer?.delegate, action: handler)
        globalPan.delegate = self
        view.addGestureRecognizer(globalPan)
        
        //禁止之前的手势
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//        print(interactivePopGestureRecognizer)
    }
    
    var popDelegate: UIGestureRecognizerDelegate?
    /// 自定义返回按钮保留侧滑返回手势
    func jubufanhui() {
        // 1.保留局部返回手势
        interactivePopGestureRecognizer?.delegate = nil
        self.popDelegate = interactivePopGestureRecognizer?.delegate
        self.delegate = self
    }
    
    //全局设置外观
    fileprivate func defaultSetting() {
        let nvc = UINavigationBar.appearance(whenContainedInInstancesOf: [ELNavigationController.self])
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20),NSAttributedString.Key.foregroundColor : UIColor.red]
        nvc.titleTextAttributes = attrs
        
        // 设置导航条背景图片
        navigationBar.setBackgroundImage(UIImage(named: "navigationbarBackgroundWhite"), for: UIBarMetrics.default)
    }
    
    //全局设置外观
//    fileprivate func defaultSetting() {
//        //导航栏的背景色与标题设
//        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red,NSAttributedString.Key.font:UIFont.systemFont(ofSize:17)]
//        navigationBar.setBackgroundImage(UIImage(named: "navigationbarBackgroundWhite"), for: UIBarMetrics.default)
//        UINavigationBar.appearance().tintColor = UIColor.orange
//    }
    
    
    override var childForStatusBarStyle: UIViewController? {
        return visibleViewController
    }

}



extension ELNavigationController : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        //获取当前状态栏的方向 不是竖屏 不能返回
        let currentOrientation = UIDevice.current.orientation
        
        return children.count > 1 && currentOrientation == .portrait
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 { // 非根控制器
            // 恢复滑动返回功能 -> 分析:把系统的返回按钮覆盖 -> 1.手势失效(1.手势被清空 2.可能手势代理做了一些事情,导致手势失效)
            // 隐藏 tabbar必须要在跳转之前设置 全局设置
            viewController.hidesBottomBarWhenPushed = true
            // 设置返回按钮,只有非根控制器
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(backItemWithimage: "navigationButtonReturn", target: self , ation: #selector(back), title: "返回  <<<<<")
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    
    
    @objc fileprivate func back() {
        popViewController(animated: true)
    }
}


// MARK: - UINavigationControllerDelegate
//自定义UIButton替换导航返回按钮,仍然保持系统边缘返回手势-[UIViewController preferredStatusBarStyle]
extension ELNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // 实现滑动返回功能
        // 清空滑动返回手势的代理就能实现ProdProgressItemListVC
        if viewController == self.viewControllers[0] {//|| viewController is ProdProgressItemListVC { // 可以控制那个控制器不需要局部返回手势
            self.interactivePopGestureRecognizer!.delegate = self.popDelegate
        } else {
            self.interactivePopGestureRecognizer!.delegate = nil
        }
    }
}
