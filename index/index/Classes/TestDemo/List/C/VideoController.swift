//
//  VideoController.swift
//  VideoPlayer
//
//  Created by Soul on 20/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class VideoController: UIViewController {
    var video: DemoVideo?
    var playerView : ELPlayerView?
    
    ///重写横盘旋转 应该旋转
    override var shouldAutorotate : Bool { 
        return true
    }
    
    deinit {
        print("VideoController deinit")
    }
    
    
    // 跳转页面的导航 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        view.semanticContentAttribute = UISemanticContentAttribute ForceLeftToRight
        view.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //隐藏导航栏 // 隐藏首页的导航栏
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // 跳转到下一个页面
    //    func viewToSecond() {
    //        // 下一个页面返回首页，隐藏导航栏  需要动画
    //        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "NextVC")
    //        self.navigationController?.≈ViewController(nextVC!, animated: true)
    //    }
    
    
   
    
    // MARK: - 状态栏的隐藏
    override var prefersStatusBarHidden: Bool {
        return self.isStatusBarHidden
    }
    
    var isStatusBarHidden = false {
        
        didSet{
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    //状态栏颜色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
    }
    
    //旋转方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    
    func setUI() {
        view.backgroundColor = BACKGROUND_COLOR
        
        view.addSubview(videoToolBar)
        
        view.addSubview(tableView)
        
        view.addSubview(commentView)
        
        setPlayerView()
    }
    
    fileprivate func commentEdit() {
        let commentEditController = CommentEditController()
        present(UINavigationController(rootViewController: commentEditController), animated: true, completion: nil)
    }
    
    
    func setPlayerView() {
        playerView = ELPlayerView.shared.initWithFrame(CGRect(x: 0, y: statusBarHeight, width: ScreenWidth, height: PlayerViewHeight), videoUrl: (video?.play_address)!)
        playerView?.delegate = self
        view.addSubview(playerView!)
    }
    
    lazy var videoToolBar : VideoToolBar = {
        let videoToolBar = VideoToolBar(frame: CGRect(x: 0, y: PlayerViewHeight+statusBarHeight, width: ScreenWidth, height: 40)) 
        videoToolBar.backgroundColor = UIColor.lightGray
        return videoToolBar
    }()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: PlayerViewHeight+40+statusBarHeight, width: ScreenWidth, height: ScreenHeight-PlayerViewHeight-40))
        tableView.backgroundColor = BACKGROUND_COLOR
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(VideoInfoCell.self, forCellReuseIdentifier: "VideoInfoCell")
        tableView.register(VideoAuthorInfoCell.self, forCellReuseIdentifier: "AuthorInfoCell")
        tableView.register(VideoSelectionsCell.self, forCellReuseIdentifier: "SelectionsCell")
        tableView.register(VideoRecommendMediaCell.self, forCellReuseIdentifier: "RecommendMediaCell")
        tableView.register(VideoUserInputCell.self, forCellReuseIdentifier: "UserInputCell")
        tableView.register(VideoCommentCell.self, forCellReuseIdentifier: "CommentCell")
        tableView.register(VideoAllCommentCell.self, forCellReuseIdentifier: "AllCommentCell")
        return tableView
    }()
    
    lazy var commentView : VideoCommentView = {
        let commentView = VideoCommentView(frame: CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: ScreenHeight-PlayerViewHeight))
        commentView.commentCallBack = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.commentEdit()
        }
        return commentView
    }()
    
}

extension VideoController : UITableViewDataSource, UITableViewDelegate{
    //UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 5 {
            return 3
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"VideoInfoCell", for: indexPath) as! VideoInfoCell
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"AuthorInfoCell", for: indexPath) as! VideoAuthorInfoCell
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"SelectionsCell", for: indexPath) as! VideoSelectionsCell
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"RecommendMediaCell", for: indexPath) as! VideoRecommendMediaCell
            return cell
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"UserInputCell", for: indexPath) as! VideoUserInputCell
            cell.commentCallBack = { [weak self] in
                guard let `self` = self else { return } // `self` == strongSelf
                self.commentEdit()
            }
            
            return cell
        } else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier:"CommentCell", for: indexPath) as! VideoCommentCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:"AllCommentCell", for: indexPath) as! VideoAllCommentCell
            return cell
        }
        
    }
    
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0,1:
            return 80
        case 2:
            return 110
        case 3:
            return recommendMediaHeight+40+40
        case 4:
            return 110
        case 5:
            return 85
            
        default:
            return 50
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 6 {
            UIView.animate(withDuration: 0.25) { 
                self.commentView.y = PlayerViewHeight + statusBarHeight
            }
        }
    }
}


extension VideoController: ELPlayerViewDelegate {
    func isLandscapeHome(isAutoHidden: Bool) {
        
    }
    
    
    func isStatusBarHidden(isFull: Bool) {
        isStatusBarHidden = isFull
    }
    
    func TopGoBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func likeAction(isLike: Bool) {
        
    }
}
