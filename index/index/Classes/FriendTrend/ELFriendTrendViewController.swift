//
//  ELFriendTrendViewController.swift
//  index
//
//  Created by Soul on 25/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELFriendTrendViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setupNavBar()
    }
    
    func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(itemWithimage: "friendsRecommentIcon", highImage: "friendsRecommentIcon-click", target: self, ation: #selector(friendsRecomment))
        navigationItem.title = "我的关注"
    }
    
    
    @objc func loginClick() {
        let loginVc = ELLoginRegisterViewController()
        present(loginVc, animated: true, completion: nil)
        
    }
    
    @objc func friendsRecomment() {
        let recommendVC = ELRecommendVC()
        navigationController?.pushViewController(recommendVC, animated: true)
        
    }
    
    
    func setUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(testField)
        view.addSubview(imageView)
        view.addSubview(testLabel)
        view.addSubview(loginBtn)
        
        testField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(imageView.snp.top).offset(-40)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 50, height: 50))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(testLabel.snp.top).offset(-20)
        }
        
        
        testLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(testLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 240, height: 44))
        }
        
    }
    
        
    
    lazy var testField : UITextField = {
        let testField = UITextField()
        testField.textColor = UIColor.yellow
        testField.borderStyle = .roundedRect
        testField.placeholder = "runtime交换颜色测试"
        testField.font = UIFont.systemFont(ofSize: 14)
        return testField
    }()
    
    lazy var imageView = UIImageView(image: UIImage(named: "header_cry_icon"))
    
    lazy var testLabel : UILabel = {
        let testLabel = UILabel()
        testLabel.text = "快快登录吧, 关注百思最in牛人\n好友动态让你过吧瘾儿~ \n欧耶~~~~!"
        testLabel.font = UIFont.systemFont(ofSize: 17)
        testLabel.textColor = UIColor.black
        testLabel.numberOfLines = 0
        testLabel.textAlignment = .center
        return testLabel
    }()
    
    lazy var loginBtn : UIButton = {
        let loginBtn = UIButton() 
        loginBtn.setTitle("立即登录注册", for: UIControl.State.normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        loginBtn.setTitleColor(UIColor.red, for: UIControl.State.normal)
        loginBtn.addTarget(self, action: #selector(loginClick), for: UIControl.Event.touchUpInside)
        loginBtn.setBackgroundImage(UIImage(named: "friendsTrend_login"), for: UIControl.State.normal)
        return loginBtn
    }()
    
    
}
