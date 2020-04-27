//
//  ELFastLoginView.swift
//  index
//
//  Created by Soul on 31/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELFastLoginView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setUI() {
        addSubview(qqBtn)
        addSubview(xinlangBtn)
        addSubview(txBtn)
        
        addSubview(leftView)
        addSubview(fastLabel)
        addSubview(rightView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        qqBtn.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.height.equalTo(100)
            make.right.equalTo(xinlangBtn.snp.left)
        }
        
        xinlangBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.width.height.equalTo(qqBtn)
            make.right.equalTo(txBtn.snp.left)
        }
        
        txBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(xinlangBtn)
            make.right.bottom.equalToSuperview()
        }
        
        leftView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.right.equalTo(fastLabel.snp.left)
            make.bottom.equalTo(qqBtn.snp.top)
        }
        
        fastLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(60)
        }
        
        rightView.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview()
            make.left.equalTo(fastLabel.snp.right)
            make.bottom.equalTo(txBtn.snp.top)
        }
        
    }
    
    
    lazy var leftView : UIImageView = {
        let leftView = UIImageView(image: UIImage(named: "login_register_left_line"))
        leftView.contentMode = .center
        return leftView
    }()
    
    lazy var rightView : UIImageView = {
        let rightView = UIImageView(image: UIImage(named: "login_register_right_line"))
        rightView.contentMode = .center
        return rightView
    }()
    
    lazy var fastLabel : UILabel = {
        let fastLabel = UILabel()
        fastLabel.textAlignment = .center
        fastLabel.font = UIFont.systemFont(ofSize: 14)
        fastLabel.text = "快速登录"
        fastLabel.textColor = UIColor.white
        return fastLabel
    }()
    
    lazy var qqBtn : ELFastButton = {
        let qqBtn = ELFastButton(type: UIButton.ButtonType.custom)
        qqBtn.setImage(UIImage(named: "login_QQ_icon"), for: UIControl.State.normal)
        qqBtn.setImage(UIImage(named: "login_QQ_icon_click"), for: UIControl.State.highlighted)
        qqBtn.titleLabel?.textColor = UIColor.white
        qqBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        qqBtn.setTitle("QQ登录", for: UIControl.State.normal)
        return qqBtn
    }()
    
    lazy var xinlangBtn : ELFastButton = {
        let xinlangBtn = ELFastButton(type: UIButton.ButtonType.custom)
        xinlangBtn.setImage(UIImage(named: "login_sina_icon"), for: UIControl.State.normal)
        xinlangBtn.setImage(UIImage(named: "login_sina_icon_click"), for: UIControl.State.highlighted)
        xinlangBtn.titleLabel?.textColor = UIColor.white
        xinlangBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        xinlangBtn.setTitle("新浪微博", for: UIControl.State.normal)
        return xinlangBtn 
    }()
    
    lazy var txBtn : ELFastButton = {
        let txBtn = ELFastButton(type: UIButton.ButtonType.custom)
        txBtn.setImage(UIImage(named: "login_tecent_icon"), for: UIControl.State.normal)
        txBtn.setImage(UIImage(named: "login_tecent_icon_click"), for: UIControl.State.highlighted)
        txBtn.titleLabel?.textColor = UIColor.white
        txBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        txBtn.setTitle("腾讯微博", for: UIControl.State.normal)
        return txBtn
    }()
}
