//
//  VideoListController.swift
//  VideoPlayer
//
//  Created by Soul on 19/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

private let ImageViewHeight: CGFloat = ScreenWidth * (750/1334)

class VideoListController: UIViewController {

    private lazy var viewModel = VideoListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        
        viewModel.setupData { [unowned self] in
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //状态条隐藏
    override var prefersStatusBarHidden: Bool {
        get {
            return false
        }
    }
    //状态条颜色
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.style
    }
    
    // 当前statusBar使用的样式
    var style: UIStatusBarStyle = .default {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    
    deinit {
        print("videoListController deinit")
    }

    func setUI() {
        view.backgroundColor = BACKGROUND_COLOR
        view.addSubview(imageView)
        view.addSubview(logoView)
        view.addSubview(activityIndicator)
        view.addSubview(coverView)
        view.addSubview(tableView)
        
        logoView.center = imageView.center
    }
    
    func refreshData() {
        if activityIndicator.isAnimating {
            return
        }
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { 
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    lazy var callBackBtn: UIButton = {
        let callBack = UIButton(frame: CGRect(x: imageView.frame.size.width * 0.5 - 50, y: imageView.frame.size.height * 0.7, width: 100, height: 30))
        callBack.addTarget(self, action: #selector(back), for: .touchUpInside)
        callBack.setTitle("点我返回", for: .normal)
        callBack.backgroundColor = UIColor.orange
        callBack.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return callBack
    }()
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    //顶端放大的View
    lazy var imageView : UIImageView =  {
       let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ImageViewHeight))
        imageView.image = UIImage(named: "list_header")
        return imageView
    }()
    
    lazy var logoView = UIImageView(image: UIImage(named: "list_daily special"))
    
    lazy var coverView : UIView =  {
        let coverView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ImageViewHeight))
//        coverView.backgroundColor = RGB(r: 0x00, g: 0x00, b: 0x00, alpha: 0)
        coverView.backgroundColor = UIColor.green
        return coverView
    }()
    
    lazy var activityIndicator : UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.centerX = view.centerX
        activityIndicator.y = imageView.height - 25
        activityIndicator.isHidden = true
        return activityIndicator
    }()
    
    lazy var tableView : UITableView = {
       let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ImageViewHeight))
        headerView.backgroundColor = UIColor.clear
        headerView.addSubview(callBackBtn)
        tableView.tableHeaderView = headerView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(VideoListCell.self, forCellReuseIdentifier: "VideoCell")
        tableView.register(ListHeaderView.self, forHeaderFooterViewReuseIdentifier: "HeaderView")
        return tableView
    }()
    
}

extension VideoListController: UITableViewDelegate, UITableViewDataSource {
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ListCellHeight + 140
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoController = VideoController()
        videoController.video = viewModel.videoArr[indexPath.row]
        navigationController?.pushViewController(videoController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0  {
            let height = ImageViewHeight-scrollView.contentOffset.y
            let width = ScreenWidth*(1+(-offsetY)/ImageViewHeight)
            let x = -(width-ScreenWidth)/2
            let frame = CGRect(x: x, y: 0, width: width, height: height)
            imageView.frame = frame
            logoView.center = imageView.center
            activityIndicator.y = imageView.height - 25
            coverView.backgroundColor = RGB(r: 0x00, g: 0x00, b: 0x00, alpha: 0)
            if offsetY < -50 {
                refreshData()
            }
        } else if offsetY >= 0 {
            let alpha = offsetY/ImageViewHeight
            coverView.backgroundColor = RGB(r: 0x00, g: 0x00, b: 0x00, alpha: alpha*0.9)
            if offsetY >= ImageViewHeight {
                style = .default
            } else {
                style = .lightContent
            }
            
        }
        
    }
    
    //UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.videoArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoListCell
        cell.video = viewModel.videoArr[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView")
        return headerView
    }
    
}
