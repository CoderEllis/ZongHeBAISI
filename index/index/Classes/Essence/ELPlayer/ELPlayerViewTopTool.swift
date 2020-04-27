//
//  ELPlayerViewTopTool.swift
//  VideoPlayer
//
//  Created by Soul on 9/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

protocol ELPlayerViewTopTooldelegate: NSObjectProtocol {
    func back()
    func like(_ isLike: Bool)
}

class ELPlayerViewTopTool: UIView {
    
    weak var delegate : ELPlayerViewTopTooldelegate?
    
    var title : String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
//        backgroundColor = UIColor(white: 1, alpha: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        printLog("ELPlayerViewTopTool deinit")
    }
    
    private func setupUI() {
        addSubview(backgroundView)
        addSubview(backBtn)
        addSubview(titleLabel)
        addSubview(likeBtn)
        
    }
    
    func setupFrame(isFullScreen: Bool) {
        if isFullScreen {
            
            titleLabel.isHidden = false
            likeBtn.isHidden = false
            
//            backgroundView.image = ELPlayerImage(named: "video_topBackground")
            
            backBtn.snp.remakeConstraints { (make) in
                make.left.equalToSuperview().offset(5)
                make.top.equalToSuperview()
                make.size.equalTo(CGSize(width: 40, height: 40))
            }
            
            titleLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(backBtn.snp.right).offset(10)
                make.centerY.equalTo(backBtn.snp.centerY)
                make.height.equalTo(30)
            }
            
            likeBtn.snp.remakeConstraints { (make) in
                make.right.equalToSuperview().offset(-20)
                make.centerY.equalTo(backBtn.snp.centerY)
                make.size.equalTo(CGSize(width: 40, height: 40))
            }
        } else {
            likeBtn.isHidden = true
            titleLabel.isHidden = true
//            backgroundView.image = ELPlayerImage(named: "video_topBackground_small")
            
            backgroundView.snp.remakeConstraints { (make) in
                make.top.right.bottom.left.equalToSuperview()
            }
            
            backBtn.snp.remakeConstraints { (make) in
                make.left.equalToSuperview().offset(5)
                make.top.equalToSuperview()
                make.size.equalTo(CGSize(width: 40, height: 40))
            }
            
            titleLabel.snp.remakeConstraints { (make) in
                make.left.equalTo(backBtn.snp.right).offset(10)
                make.centerY.equalTo(backBtn.snp.centerY)
                make.height.equalTo(30)
            }
            
            likeBtn.snp.remakeConstraints { (make) in
                make.right.equalToSuperview().offset(-20)
                make.centerY.equalTo(backBtn.snp.centerY)
                make.size.equalTo(CGSize(width: 40, height: 40))
            }
        }
        
    }
    var isFull : Bool = false {
        didSet {
            setupFrame(isFullScreen: isFull)
        }
    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        setupFrame(isFullScreen: isFull)
//    }
    
    private lazy var backgroundView = UIImageView()
    
    private lazy var backBtn : UIButton = {
        let backBtn = UIButton(type: UIButton.ButtonType.custom)
        backBtn.setImage(ELPlayerImage(named: "video_back"), for: .normal)
        backBtn.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
        sizeToFit()
        return backBtn
    }()
    
    private lazy var titleLabel = UILabel(text: "Title", textColor: WHITE, fontSize: 15)
    
    private lazy var likeBtn : UIButton = {
        let likeBtn = UIButton()
        likeBtn.setImage(ELPlayerImage(named: "video_like"), for: .normal)
        likeBtn.setImage(ELPlayerImage(named: "video_like_sel"), for: .selected)
        likeBtn.addTarget(self, action: #selector(self.clickLikeBtn(_:)), for: .touchUpInside)
        sizeToFit()
        return likeBtn
    }()
    
}


// MARK: - 点击事件
extension ELPlayerViewTopTool {
    @objc func clickBackBtn() {
        if delegate != nil {
            delegate?.back()
        }
    }
    
    @objc func clickLikeBtn(_ sender: UIButton) {
        likeBtn.isSelected = !sender.isSelected
        
        if delegate != nil {
            delegate?.like(sender.isSelected)
        }
        
        if sender.isSelected {
            ///动画跳动效果
            let animation = CAKeyframeAnimation()
            animation.keyPath = "transform.scale"
            animation.values = [1.0, 1.3, 0.9, 1.0]
            animation.duration = 0.25
            animation.calculationMode = .cubic
            likeBtn.layer.add(animation, forKey: nil)
        }
        
    }
    
}
