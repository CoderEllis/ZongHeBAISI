
//
//  ELLoginRegisterView.swift
//  index
//
//  Created by Soul on 30/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELRegister: UIView {
    
    /// MARK:- 提供快速通过xib创建的类方法
    class func loadFromNib() -> ELRegister {
        return Bundle.main.loadNibNamed("ELRegister", owner: nil, options: nil)?.first as! ELRegister
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard var image = loginBtn.currentBackgroundImage else {return}
        // 让按钮背景图片不要被拉伸
        image = image.stretchableImage(withLeftCapWidth: Int(image.size.width * 0.5), topCapHeight: Int(image.size.height * 0.5))
        loginBtn.setBackgroundImage(image, for: UIControl.State.normal)
        
        topView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(92)
            make.width.equalTo(260)
        }
        
        backImageV.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        phoneNum.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(backImageV).multipliedBy(0.5)
        }
        passwordNum.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.leading.equalTo(phoneNum)
            make.width.height.equalTo(phoneNum)
        }
        
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(topView)
        }
    }
    
    func setUI() {
        addSubview(topView)
        topView.addSubview(backImageV)
        topView.addSubview(phoneNum)
        topView.addSubview(passwordNum)
        addSubview(loginBtn)
        
    }
    
    lazy var topView = UIView()
    
    lazy var backImageV = UIImageView(image: UIImage(named: "login_rgister_textfield_bg"))
    
    lazy var phoneNum : ELLoginField = {
        let phoneNum = ELLoginField()
        phoneNum.placeholder = "请输入手机号:"
        phoneNum.font = UIFont.systemFont(ofSize: 14)
        phoneNum.borderStyle = .none
        phoneNum.textAlignment = .natural
        return phoneNum
    }()
    
    lazy var passwordNum : ELLoginField = {
        let PasswordNum = ELLoginField()
        PasswordNum.placeholder = "请输入密码:"
        PasswordNum.font = UIFont.systemFont(ofSize: 14)
        PasswordNum.borderStyle = .none
        PasswordNum.textAlignment = .natural
        PasswordNum.isSecureTextEntry = true
        return PasswordNum
    }()
    
    lazy var loginBtn : UIButton = {
        let login = UIButton()
        login.setBackgroundImage(UIImage(named: "loginBtnBg"), for: UIControl.State.normal)
        login.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        login.titleLabel?.textColor = UIColor.white
        login.setTitle("注册", for: UIControl.State.normal)
        return login
    }()
    
}
