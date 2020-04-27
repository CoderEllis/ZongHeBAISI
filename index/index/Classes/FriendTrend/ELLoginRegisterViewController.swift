

//
//  ELLoginRegisterViewController.swift
//  index
//
//  Created by Soul on 30/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit
import SnapKit

class ELLoginRegisterViewController: UIViewController {
    ///中间View保存约束的的属性
    var leadingConstraint: Constraint? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let loginView : ELLoginView = middleView.subviews[0] as! ELLoginView
        loginView.frame = CGRect(x: 0, y: 0, width: middleView.width * 0.5, height: middleView.height)
        let register : ELRegister = middleView.subviews[1] as! ELRegister
        register.frame = CGRect(x: middleView.width * 0.5, y: 0, width: middleView.width * 0.5, height: middleView.height)
        
        let fastloginView = bottonView.subviews.first
        fastloginView?.frame = bottonView.bounds
    }
    
    
    @objc func closeClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func clickRegister(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        // 平移中间view
        leadingConstraint?.update(offset: middleView.x == 0 ? -middleView.width*0.5 : 0)
        UIView.animate(withDuration: 0.3) { 
            self.view.layoutIfNeeded()
        }
    }
    
    func setUI() {
        view.addSubview(backGroundView)
        view.addSubview(topView)
        topView.addSubview(closeBtn)
        topView.addSubview(registerBtn)
        view.addSubview(middleView)
        view.addSubview(bottonView)
        middleView.addSubview(loginView)
        middleView.addSubview(register)
        bottonView.addSubview(fastloginView)
        
        topView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.bottom.equalToSuperview()
        }
        
        registerBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.top.bottom.equalToSuperview()
        }
        
        middleView.snp.makeConstraints { (make) in
            make.height.equalTo(300)
            make.top.equalTo(topView.snp.bottom).offset(40)
            leadingConstraint = make.leading.equalToSuperview().constraint//保存约束
            make.width.equalToSuperview().multipliedBy(2)
        }
        
        bottonView.snp.makeConstraints { (make) in
            make.height.equalTo(120)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    
    lazy var backGroundView : UIImageView = {
        let backGroundView = UIImageView(frame: view.bounds)
        backGroundView.image = UIImage(named: "login_register_background")
        return backGroundView
    }()
    lazy var topView = UIView()
    
    lazy var closeBtn : UIButton = {
        let closeBtn = UIButton(type: UIButton.ButtonType.custom)
        closeBtn.setImage(UIImage(named: "login_close_icon"), for: UIControl.State.normal)
        closeBtn.addTarget(self, action: #selector(closeClick), for: UIControl.Event.touchUpInside)
        return closeBtn
    }()
    
    lazy var registerBtn : UIButton = {
        let registerBtn = UIButton(type: UIButton.ButtonType.custom)
        registerBtn.setTitle("注册账号", for: UIControl.State.normal)
        registerBtn.setTitle("已有账号?", for: UIControl.State.selected)
        registerBtn.addTarget(self, action: #selector(clickRegister(_:)), for: UIControl.Event.touchUpInside)
        return registerBtn
    }()
    
    lazy var middleView = UIView()
    
    lazy var bottonView = UIView()
    
    lazy var loginView = ELLoginView()
    lazy var register = ELRegister()
    lazy var fastloginView = ELFastLoginView()
    
}
