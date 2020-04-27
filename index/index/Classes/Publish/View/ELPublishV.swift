//
//  ELPublishV.swift
//  index
//
//  Created by Soul on 26/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit
import pop

class ELPublishV: UIView {
    let AnimationDelay : CGFloat = 0.1
    let SpringFactor : CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(imageView)
        addSubview(cancelBtn)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cancelBtn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(33)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        imageView.frame = self.bounds
        setViews()
    }
    
    private func setViews() {
        UIApplication.shared.keyWindow?.rootViewController?.view.isUserInteractionEnabled = false
        isUserInteractionEnabled = false
        let titles = ["发视频","发图片","发段子","发声音","发链接","音乐相册","测试视频"]
        let images = ["publish-video","publish-picture","publish-text","publish-audio","publish-link","publish-review","publish-video"]
        let buttonW : CGFloat = 72
        let buttonH = buttonW + 30
        let maxCols = 3
        let buttonStratX = 3 * ELMarin
        let buttonXMargin = (ScreenWidth - 2 * buttonStratX - CGFloat(maxCols) * buttonW) / CGFloat(maxCols - 1) 
        let buttonStratY = (ScreenHeight - 2 * buttonH) * 0.5
        
        for i in 0..<titles.count {
            let button = ELTagBtn(type: UIButton.ButtonType.custom)
            button.setTitle(titles[i], for: UIControl.State.normal)
            button.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
            button.setImage(UIImage(named: images[i]), for: UIControl.State.normal)
            button.tag = i
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
            
            let row = i / maxCols
            let col = i % maxCols
            let buttonX = buttonStratX + CGFloat(col) * (buttonW + buttonXMargin)
            let buttonEndY = buttonStratY + CGFloat(row) * (buttonH + buttonStratX)
            let buttonBeginY = buttonEndY - ScreenHeight
            addSubview(button)
            
            let anmi = POPSpringAnimation(propertyNamed: kPOPViewFrame)
            anmi?.springSpeed = SpringFactor
            anmi?.springBounciness = SpringFactor
            anmi?.beginTime = CACurrentMediaTime() + Double(AnimationDelay * CGFloat(i))
            anmi?.fromValue = NSValue.init(cgRect: CGRect(x: buttonX, y: buttonBeginY, width: buttonW, height: buttonH))
            anmi?.toValue = NSValue.init(cgRect: CGRect(x: buttonX, y: buttonEndY, width: buttonW, height: buttonH))
            button.pop_add(anmi, forKey: nil)
        }
        
        let titleImageV = UIImageView(image: UIImage(named: "app_slogan"))
        titleImageV.y = ScreenHeight * 0.2 - ScreenHeight
        addSubview(titleImageV)
        let centerX = ScreenWidth * 0.5
        let titleStartY = titleImageV.y
        let titleEndY = ScreenHeight * 0.2
        
        let anim = POPSpringAnimation(propertyNamed: kPOPViewCenter)
        anim?.springSpeed = SpringFactor
        anim?.springBounciness = SpringFactor
        anim?.fromValue = NSValue.init(cgPoint: CGPoint(x: centerX, y: titleStartY))
        anim?.toValue = NSValue.init(cgPoint: CGPoint(x: centerX, y: titleEndY))
        titleImageV.pop_add(anim, forKey: nil)
        anim?.completionBlock = { (anim,isFinished) in
            UIApplication.shared.keyWindow?.rootViewController?.view.isUserInteractionEnabled = true
            self.isUserInteractionEnabled = true
        }
        
    }
    
    @objc func btnClick(_ button:ELTagBtn) {
        cancelWithCompletionBlock { 
            printLog("点击\(button.titleLabel?.text ?? "??")")
            
            if button.tag == 2 {
                let vc = ELPublishViewController()
                let nav = ELNavigationController.init(rootViewController: vc)
                UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
            } else if button.tag == 6 {
                
            }
        }
    }
    
    @objc func cancelClick() {
        cancelWithCompletionBlock(nil)
    }
    
    
    func cancelWithCompletionBlock(_ completionBlock: (()->())?) {
        UIApplication.shared.keyWindow?.rootViewController?.view.isUserInteractionEnabled = false
        isUserInteractionEnabled = false
        let i = 2
        for i in i..<self.subviews.count {
            let currentView = self.subviews[i]
            let anim = POPBasicAnimation.init(propertyNamed: kPOPViewCenter)
            let endY = currentView.y + ScreenHeight
            anim?.toValue = NSValue.init(cgPoint: CGPoint(x: currentView.centerX, y: endY))
            anim?.beginTime = CACurrentMediaTime() + Double(CGFloat(i - 2) * AnimationDelay)
            
            anim?.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeIn)
            currentView.pop_add(anim, forKey: nil)
            
            if (i == self.subviews.count - 1) {
                anim?.completionBlock = { (anim,isFinished) in
                    UIApplication.shared.keyWindow?.rootViewController?.view.isUserInteractionEnabled = true
                    self.isUserInteractionEnabled = true
                    self.removeFromSuperview()
                    completionBlock?()
                }
            }
            
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "shareBottomBackground"))
        
        return imageView
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: UIButton.ButtonType.custom)
//        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        cancelBtn.setTitle("取消", for: UIControl.State.normal)
        cancelBtn.setImage(UIImage(named: "shareButtonCancel"), for: UIControl.State.normal)
        cancelBtn.setImage(UIImage(named: "shareButtonCancelClick"), for: UIControl.State.highlighted)
        cancelBtn.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        cancelBtn.addTarget(self, action: #selector(cancelClick), for: UIControl.Event.touchUpInside)
        return cancelBtn
    }()
}
