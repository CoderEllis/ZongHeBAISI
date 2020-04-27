//
//  ELEssenceViewController.swift
//  index
//
//  Created by Soul on 25/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit
////
class ELEssenceViewController: UIViewController {
    var titleUnderline : UIView!
    ///上一次点击的标题按钮
    var previousClickedTitleButton : UIButton!
    
    //如果你的自定义cell是不可编辑的，那么使用[self addSubView:] 或[self.contentView addSubView:]效果是一样的；但是如果是可编辑的，那么就必须要使用 [self.contentView addSubView:]
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化子控制器
        setupAllChildVcs()
        // 设置导航条
        setupNavBar()
        view.addSubview(scrollView)
        view.addSubview(titlesView)
        addChildViewIntoScrollView(index: 0)
        setupTitleButtons()
        setupTitleUnderline()
    }
    
    func setupAllChildVcs() {
        addChild(ELAllViewController())
        addChild(ELVideoViewController())
        addChild(ELVoiceViewController())
        addChild(ELPictureViewController())
        addChild(ELWordViewController())
    }
    
    ///添加第index个子控制器的view到scrollView中
    private func addChildViewIntoScrollView(index: NSInteger) {
        let childVc = children[index]
        if childVc.isViewLoaded { return } //如果VC过返回
        // 取出index位置对应的子控制器view
        let childView = childVc.view
        let scrollViewW = scrollView.width
        childView?.frame = CGRect(x: scrollViewW * CGFloat(index), y: 0, width: scrollViewW, height: scrollView.height)
        scrollView.addSubview(childView!)
    } 
    
    
    private lazy var titlesView : UIView = {
        let titleView = UIView(frame: CGRect(x: 0, y: navigationHeight, width: view.width, height: ELTitleViewH))
        titleView.backgroundColor = UIColor.orange.withAlphaComponent(1)
        return titleView 
    }()
    
    //标题栏按钮
    private func setupTitleButtons() {
        let title = ["全部","视频","声音","图片","段子"]
        let count = title.count
        let titleButtonW = titlesView.width / CGFloat(count)
        let titleButtonH = titlesView.height
        
        for i in 0..<count {
            let titleButton = ELTitleButton()
            titleButton.tag = i
            titleButton.frame = CGRect(x: CGFloat(i) * titleButtonW, y: 0, width: titleButtonW, height: titleButtonH)
            titleButton.addTarget(self, action: #selector(titleButtonClick(_:)), for: UIControl.Event.touchUpInside)
            titleButton.setTitle(title[i], for: UIControl.State.normal)
            titlesView.addSubview(titleButton)
        }
        
    }
    
    // 标题下划线
    private func setupTitleUnderline() {
        guard let firstTitleButton = titlesView.subviews.first as? ELTitleButton else {
            return
        }
        //下划线
        let titleUnderline = UIView()
        titleUnderline.height = 2
        titleUnderline.y = titlesView.height - titleUnderline.height
        titleUnderline.backgroundColor = firstTitleButton.titleColor(for: UIControl.State.selected)
        titlesView.addSubview(titleUnderline)
        self.titleUnderline = titleUnderline
        
        //进来就显示下划线和选中第一个
        firstTitleButton.isSelected = true
        previousClickedTitleButton = firstTitleButton
        firstTitleButton.titleLabel?.sizeToFit() // 让label根据文字内容计算尺寸
        self.titleUnderline.width = firstTitleButton.titleLabel!.width + ELMarin
        self.titleUnderline.centerX = firstTitleButton.centerX
    }
    
    
    private func setupNavBar() {
        view.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(itemWithimage: "nav_item_game_icon", highImage: "nav_item_game_click_icon", target: self, ation: #selector(leftClick))
        let testItem = UIBarButtonItem(itemWithimage: "navigationButtonRandom", highImage: "navigationButtonRandomClick", target: self, ation: #selector(rightClick))
        let QRcodeItem = UIBarButtonItem(itemWithimage: "navigationbar_pop", highImage: "navigationbar_pop_highlighted", target: self, ation: #selector(QRcodeClick))
        QRcodeItem.accessibilityIdentifier  = "123"
        navigationItem.rightBarButtonItems = [testItem,QRcodeItem]
        navigationItem.titleView = UIImageView(image: UIImage(named: "cell_like_in_my_music"))
    }
    
    @objc func leftClick() {
        let vc = CollVC(frame: view.bounds)
        vc.backgroundColor = UIColor(white: 0, alpha: 0.75)
        vc.dataArray = getArray()
        UIApplication.shared.keyWindow?.addSubview(vc)
    }
    
    @objc func QRcodeClick() {
        let scanQRCodeVC = ScanQRCodeVC()
        navigationController?.pushViewController(scanQRCodeVC, animated: true)
    }
    
    private func getArray() -> [ELTopic] {
        
        var array = [ELTopic]()
        
        for i in 0..<20 {
            let model = ELTopic()
            model.userName = String(format: "用户昵称:%d", i)
            model.userImage = "plachImage"
            model.numDou = "22"
            array.append(model)
        }
        
        return array
    }
    
    @objc func rightClick() {
//        let tableVideo = VideoPlayerController("http://uvideo.spriteapp.cn/video/2019/0715/5d2c5d5d962d6_wpd.mp4")
        let tableVC = VideoListController()
        
        navigationController?.pushViewController(tableVC, animated: true)
    }
    
    //点击标题按钮
    @objc func titleButtonClick(_ titleButton: ELTitleButton) {
        
        // 重复点击了标题按钮 发通知给 VC 做出相关响应
        if previousClickedTitleButton == titleButton {
            NotificationCenter.default.post(name: NSNotification.Name(ELTitleButtonDidRepeatClickNotification), object: nil)
        }
        
        dealtitleButtonClick(titleButton: titleButton)
    }
    
    ///处理标题按钮点击
    private func dealtitleButtonClick(titleButton: ELTitleButton) {
        previousClickedTitleButton.isSelected = false
        titleButton.isSelected = true
        
        previousClickedTitleButton = titleButton
        let index = titleButton.tag
        
        UIView.animate(withDuration: 0.25, animations: { 
            self.titleUnderline.width = (titleButton.titleLabel?.width)! + ELMarin
            self.titleUnderline.centerX = titleButton.centerX
            let offsetX = self.scrollView.width * CGFloat(index)
            //contentOffset偏移量
            self.scrollView.contentOffset = CGPoint(x: offsetX, y: self.scrollView.contentOffset.y)
        }) { (_) in
            // 添加子控制器的view
            self.addChildViewIntoScrollView(index: index)
        }
        // 设置index位置对应的tableView.scrollsToTop = YES， 其他都设置为NO
        //点击状态栏顶端 scrollvc滚动到顶部
        
        for i in 0..<children.count {
            let childVc = children[i]
            // 如果view还没有被创建，就不用去处理
            if !childVc.isViewLoaded { continue }
            
            guard let scrollView = childVc.view as? UIScrollView else {return}
            if !scrollView.isKind(of: NSClassFromString("UIScrollView")!) { continue }
            
            scrollView.scrollsToTop = (i == index)
        }
    }
    
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        // 不允许自动修改UIScrollView的内边距
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        scrollView.backgroundColor = UIColor.white
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.scrollsToTop = false // 点击状态栏的时候，这个scrollView不会滚动到最顶部
        
        let count = self.children.count
        scrollView.contentSize = CGSize(width: scrollView.width * CGFloat(count), height: 0)
        return scrollView
    }()

}

extension ELEssenceViewController: UIScrollViewDelegate {
    //当用户松开scrollView并且滑动结束时调用这个代理方法（scrollView停止滚动的时候）
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index : NSInteger = NSInteger(scrollView.contentOffset.x / scrollView.width)
        let titleButton = titlesView.subviews[index] as! ELTitleButton
        dealtitleButtonClick(titleButton: titleButton)
    }
    
    //当用户松开scrollView时调用这个代理方法（结束拖拽的时候）
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    //处理可以重新创建的任何资源
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
