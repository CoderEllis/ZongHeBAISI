//
//  VideoPlayerController.swift
//  index
//
//  Created by Soul on 14/7/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class VideoPlayerController: UIViewController {
    
    var playerView : ELPlayerView?
    
    //Swift 的原则是，所有属性在初始化阶段都要完成赋值，因为 Swift 不会给属性赋默认值，需要开发者自己完成
    var urlString : String = "http://uvideo.spriteapp.cn/video/2019/0715/5d2c5d5d962d6_wpd.mp4"
    var size :CGSize = CGSize.zero
    
    //子类自身属性的初始化需要在调用父类的初始化构造器前完成
    init(_ urlString: String,size :CGSize) {
        self.urlString = urlString
        self.size = size
        super.init(nibName: nil, bundle: nil)
        //父类属性的初始化，需要在调用父类构造器之后
        //要先调用父类的构造器，以防止先给属性赋值了然后才调用父类而把以前的赋值覆盖了
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    convenience init只作为补充和提供使用上的方便。并且convenience init 不能被子类重写或者被子类super形式调用
//    convenience init(_ urlString: String,size :CGSize) {
//        self.init()
//        self.urlString = urlString
//        self.size = size
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var height : CGFloat = 0.0
        let safeHeight = ScreenHeight - topSafeAreaHeight - bottomSafeAreaHeight
        var topHeight : CGFloat = 0.0
        
        
        height = ScreenWidth / size.width * size.height
        if height > safeHeight - 44 {
            height = safeHeight
        } else {
            topHeight = 44
        }
        
//        playerView = ELPlayerView.shared.initWithFrame(CGRect(x: 0, y: topHeight, width: ScreenWidth, height: height), videoUrl: urlString)
        playerView = ELPlayerView(CGRect(x: 0, y: topHeight, width: ScreenWidth, height: height), videoUrl: urlString)
        playerView?.delegate = self
        view.addSubview(playerView!)
        
    }
    
    
    deinit {
        printLog("VideoPlayerController === deinit")
        playerView?.closPlaer()
    }
    
    //    var iSshouldAutorotate = false {
    //        didSet {
    //            let appDeleagte = UIApplication.shared.delegate as! AppDelegate
    //            if iSshouldAutorotate {
    //                appDeleagte.allowRotation = true
    //                let value = UIInterfaceOrientation.landscapeLeft.rawValue
    //                UIDevice.current.setValue(value, forKey: "orientation")
    //            } else {
    //                appDeleagte.allowRotation = false
    //                let value = UIInterfaceOrientation.portrait.rawValue
    //                UIDevice.current.setValue(value, forKey: "orientation")
    //            }
    //        }
    //    }
    
    
    // 是否支持自转 看具体需求
    //    override var shouldAutorotate : Bool {
    //        return true
    //    }
    
    //设置横屏方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        // 横屏 home键在右
        return .landscapeRight
    }
    
    private var interfaceOrientations: UIInterfaceOrientation = .portrait
    //由模态推出的视图控制器 优先支持的屏幕方向
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        get { return interfaceOrientations }
        set { interfaceOrientations = newValue }
    }
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
    }
    
    //隐藏导航栏 // 隐藏首页的导航栏
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // 消失返回时 跳转页面的导航 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    // 跳转到下一个页面
    //    func viewToSecond() {
    //        // 下一个页面返回首页，隐藏导航栏  需要动画
    //        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "NextVC")
    //        self.navigationController?.pushViewController(nextVC!, animated: true)
    //    }
    
    
    //Home横条自动隐藏
    private var isprefersHomeIndicatorAutoHidden = false {
        didSet {
            //设置需要更新 主页指示器自动隐藏
            self.setNeedsUpdateOfHomeIndicatorAutoHidden()
        }
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return isprefersHomeIndicatorAutoHidden
    }
    
    //态栏的隐藏
    override var prefersStatusBarHidden: Bool {
        return isStatusBarHidden
    }
    
    private var isStatusBarHidden = false {
        
        didSet{
            //设置需要状态栏 外观更新
            self.setNeedsStatusBarAppearanceUpdate()
            
            if #available(iOS 11.0, *) {
                //设置屏幕边缘的需要更新 延迟系统手势
                self.setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
            } else {
                
            }
            //设置自定义更新的需求
            self.setNeedsFocusUpdate()
            
        }
    }
    
    //状态条颜色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return style
    }
    
    // 当前statusBar使用的样式
    var style: UIStatusBarStyle = .default {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
}


// MARK: - 代理ELPlayerViewDelegate
extension VideoPlayerController : ELPlayerViewDelegate {
    ///是否全屏
    func isLandscapeHome(isAutoHidden: Bool) {
        isprefersHomeIndicatorAutoHidden = isAutoHidden
    }
    
    
    //状态条隐藏
    func isStatusBarHidden(isFull: Bool) {
        isStatusBarHidden = isFull
    }
    
    //返回主View
    func TopGoBack() {
        navigationController?.popViewController(animated: true)
    }
    
    //喜欢按钮回调操作
    func likeAction(isLike: Bool) {
        
    }
    
    
}
