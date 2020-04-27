//
//  ELAddViewController.swift
//  index
//
//  Created by Soul on 28/7/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELAddViewController: UIViewController {
    lazy var items = ELADItem([:])
    
    lazy var model = VMModel()
    
    var model2 : Addd?
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(launchImageView)
        view.addSubview(addContainView)
        addContainView.addSubview(adView)
        view.addSubview(jumpBtn)
        
        setupLaunchImage()
        
        loadAdDat()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeChange), userInfo: nil, repeats: true)
        var params = ["psw":"123","zhanghao":"123456"]
        
        let signStr = SignUtil.init(datas: &params).signInfo()
        printLog(signStr)
        printLog("123".sha12)
        printLog("123".sha1())
    }
    
    
    deinit {
//        print("ADview销毁了")
    }
    
    var i = 3
    
    @objc func timeChange() {
        
        if (i == 0) {
            jumpClick()
        }
        i -= 1
         // 设置跳转按钮文字
        jumpBtn.setTitle("跳过 \(i)", for: .normal)
        
    }
    
    let code2 = "phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"
    
    
    // MARK: - 加载广告数据
    func loadAdDat() {
        
//        let parameters = ["code2":code2] as [String: Any]
//        NetworkTools.shareInstance.getRequest("http://mobads.baidu.com/cpro/ui/mads.php", param: parameters, successBlock: { (json) in
//            
//            if let addDict = json["ad"].arrayObject {
//                
//                guard let data = addDict.last as? [String: Any] else {
//                    return
//                }
//                
//                self.items = ELADItem(data)
//                
//                self.adView.kf.setImage(with: URL(string: self.items.curl), placeholder: nil, options: [], progressBlock: nil, completionHandler: { (_) in
//                    if self.adView.image != nil {
//                        self.adView.isUserInteractionEnabled = true
//                    }
//                })
//                
//            }
//            
//        }) { (error) in
//            printLog(error)
//        }
        
        //测试  VM    unowned
        model.updateDataBlock = { [weak self] in
            guard let `self` = self else {
                return
            }
            guard let url = self.model.list?.w_picurl else { return }
//            guard let url = self.model.ad?.ad[0].w_picurl else { return }
            
//            self.adView.kf.setImage(with: URL(string: url))
//            if self.adView.image != nil {
//                self.adView.isUserInteractionEnabled = true
//            }
            
            self.adView.kf.setImage(with: URL(string: url), placeholder: nil, options: [], progressBlock: nil, completionHandler: { (_) in
                if self.adView.image != nil {
                    self.adView.isUserInteractionEnabled = true
                }
            })
            
        }
        model.squareRequestData()
        
    }
    
    /// 设置启动图片
    func setupLaunchImage() {
        launchImageView.image = UIImage(named: "fengjing")
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUIframe()
    }
    
    private func setUIframe() {
        jumpBtn.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.right.equalToSuperview()
            make.width.equalTo(65)
        }
        
        adView.snp.makeConstraints { (make) in
            make.right.left.equalToSuperview()
            make.height.equalTo(ScreenHeight * 0.75)
            make.centerY.equalToSuperview()
        }
    }
    
    
    private lazy var addContainView = UIView(frame: view.bounds)
    
    private lazy var launchImageView = UIImageView(frame: view.bounds)

    private lazy var jumpBtn: UIButton = {
        let jumpBtn = UIButton(type: .custom)
        jumpBtn.addTarget(self, action: #selector(jumpClick), for: .touchUpInside)
        jumpBtn.setTitle("跳过 (3)", for: .normal)
        jumpBtn.backgroundColor = UIColor.black
        jumpBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        return jumpBtn
    }()
    
    //跳转到主View
    @objc func jumpClick() {
        let tabBarVc = ELTabBarController()
        UIApplication.shared.keyWindow?.rootViewController = tabBarVc
        timer?.invalidate()
    }
    
    private lazy var adView: UIImageView = {
        let imageView = UIImageView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    @objc private func tapImage() {
        print("点击了")
        guard let url = URL(string: model.list?.curl ?? "") else { return }
        let app = UIApplication.shared
        if app.canOpenURL(url) {
            app.open(url, options: [:], completionHandler: nil)
        }
    }
}

