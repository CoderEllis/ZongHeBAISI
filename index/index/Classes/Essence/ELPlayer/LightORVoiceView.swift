//
//  LightORVoiceView.swift
//  VideoPlayer
//
//  Created by Soul on 12/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class LightORVoiceView: UIView {
    
    var progressValue : Float = 0.0 {
        willSet {
            removeProgressTimer()
        }
        didSet {
            
            if progressValue > 1.0 {
                progressValue = 1.0
            }
            if progressValue < 0 {
                progressValue = 0
            }
            
            progressView.progress = progressValue
            
            if progressView.progress == 0.0 {
                backgroundBtn.isSelected = true
            } else {
                backgroundBtn.isSelected = false
            }
            DelayOperation()
        }
    }
    private var timer: Timer? 
    private func DelayOperation()  {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(hideControlView), userInfo: nil, repeats: false)
    }
    
    ///删除定时器
    private func removeProgressTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func hideControlView() {
        self.isHidden = true
    }
    
    var normalImage : UIImage? {
        didSet {
            backgroundBtn.setImage(normalImage, for: .normal)
        }
    }
    
    var selectedImage : UIImage? {
        didSet {
            backgroundBtn.setImage(selectedImage, for: .selected)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.gray
        addSubview(backgroundBtn)
        addSubview(progressView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        printLog("LightORVoiceView deinit")
    }
    
    lazy var backgroundBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.isUserInteractionEnabled = false
        btn.setImage(ELPlayerImage(named: "shengyin"), for: .normal)
        sizeToFit()
        return btn
    }()
    
    
    private lazy var progressView : UIProgressView = {
        let progressV = UIProgressView()
        progressV.trackTintColor = UIColor.darkGray
//        progressV.progress = progressValue
        progressV.progressTintColor = UIColor.red
        progressV.trackTintColor = UIColor.lightGray
        return progressV
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        progressView.snp.makeConstraints { (make) in
            make.centerY.equalTo(backgroundBtn.snp.centerY)
            make.left.equalTo(backgroundBtn.snp.right).offset(15)
            make.right.equalToSuperview().offset(-10)
        }
        
    }
}
