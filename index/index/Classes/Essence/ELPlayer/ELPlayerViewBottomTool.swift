//
//  YZPlayerViewBottomTool.swift
//  VideoPlayer
//
//  Created by Soul on 9/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

protocol ELPlayerViewBottomToolDelegate: NSObjectProtocol{
    
    func fullScreen(sender: UIButton)  //全屏、取消
    
}
let clearY: CGFloat = 10
class ELPlayerViewBottomTool: UIView {

    weak var delegate : ELPlayerViewBottomToolDelegate?
    
    var progressValue : Float = 0.0 {
        didSet {
            loadProgress.progress = progressValue
        }
    }
    
    var sliderValue: Float = 0.0 {
        didSet {
            playSlider.value = sliderValue
        }
    }
    
    var nowTime: String?  {
        didSet {
            timeLabel.text = nowTime
        }
    }
    
    var durationTime: String = "00:00" {
        didSet {
            durationLabel.text = durationTime
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    var isFull : Bool = false {
        didSet {
//            setupFrame(isFullScreen: isFull)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        printLog("ELPlayerViewBottomTool deinit")
    }
    
    // MARK: - Set up
    
    private func setupUI() {
        addSubview(backgroundView)
        addSubview(timeLabel)
        addSubview(durationLabel)
        addSubview(loadProgress)
        addSubview(playSlider)
        addSubview(fullScreenBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupFrame(isFullScreen: isFull)
    }
    
    func setupFrame(isFullScreen: Bool) {
        if isFullScreen {//全屏模式
            backgroundColor = RGB(r: 0x00, g: 0x00, b: 0x00, alpha: 0.3)
            timeLabel.isHidden = false
            durationLabel.isHidden = false
            backgroundView.isHidden = true
            fullScreenBtn.isHidden = true
            playSlider.setThumbImage(ELPlayerImage(named: "video_sliderControl"), for: .normal)
            timeLabel.snp.remakeConstraints { (make) in
                make.left.equalToSuperview().offset(25)
                make.centerY.equalToSuperview()
                make.height.equalTo(20)
            }
            
            playSlider.snp.remakeConstraints { (make) in
                make.left.equalTo(timeLabel.snp.right).offset(10)
                make.right.equalTo(durationLabel.snp.left).offset(-10)
                make.centerY.equalTo(timeLabel.centerY)
                make.height.equalTo(40)
            }
            
            loadProgress.snp.remakeConstraints { (make) in
                make.left.right.equalTo(playSlider)
                make.centerY.equalTo(playSlider.snp.centerY).offset(1)
                make.height.equalTo(2)
            }
            
            durationLabel.snp.remakeConstraints { (make) in
                make.centerY.equalTo(timeLabel.snp.centerY)
                make.height.equalTo(20)
                make.right.equalToSuperview().offset(-25)
            }
            
            fullScreenBtn.snp.remakeConstraints { (make) in
                make.size.equalTo(CGSize(width: 40, height: 40))
                make.center.equalToSuperview()
            }
            fullScreenBtn.isHidden = true
        } else {// 竖屏模式
            backgroundColor = UIColor.clear
            timeLabel.isHidden = true
            durationLabel.isHidden = true
            fullScreenBtn.isHidden = false
            backgroundView.isHidden = false
            
            playSlider.setThumbImage(ELPlayerImage(named: "video_sliderControl_small"), for: .normal)
            backgroundView.snp.makeConstraints { (make) in
                make.top.left.right.bottom.equalToSuperview()
            }
            playSlider.snp.remakeConstraints { (make) in
                make.right.left.equalToSuperview()
                make.bottom.equalToSuperview().offset(20)
                make.height.equalTo(40)            
            }
            
            loadProgress.snp.remakeConstraints { (make) in
                make.left.right.equalTo(playSlider)
                make.centerY.equalTo(playSlider.snp.centerY).offset(1)
                make.height.equalTo(2)
            }
            fullScreenBtn.snp.remakeConstraints { (make) in
                make.size.equalTo(CGSize(width: 40, height: 40))
                make.right.equalToSuperview().offset(-5)
                make.centerY.equalToSuperview()
            }
            durationLabel.snp.remakeConstraints { (make) in
                make.center.equalToSuperview()
                make.size.equalTo(CGSize(width: 20, height: 20))
            }
            
            timeLabel.snp.remakeConstraints { (make) in
                make.center.equalToSuperview()
                make.size.equalTo(CGSize(width: 20, height: 20))
            }
        }
    }
    
    
    // MARK: - Action
    @objc private func clickFullScreenBtn(_ sender: UIButton) {
        if delegate != nil {
            delegate?.fullScreen(sender: sender)
        }
    }
    
    // MARK: - Lazy load
    private lazy var backgroundView = UIImageView()
    
    private lazy var timeLabel: UILabel = {
        let timeLabel = UILabel(text: "00:00:00", textColor: WHITE, fontSize: 10)
        timeLabel.font = UIFont.systemFont(ofSize: 15)
        timeLabel.sizeToFit()
        return timeLabel
    }()
    
    private lazy var durationLabel: UILabel = {
        let durationLabel = UILabel(text: "00:00:00", textColor: WHITE, fontSize: 10)
        durationLabel.textAlignment = .right
        durationLabel.font = UIFont.systemFont(ofSize: 15)
        durationLabel.sizeToFit()
        return durationLabel
    }()
    
    lazy var playSlider: UISlider = {
        let playSlider = UISlider()
        playSlider.setThumbImage(ELPlayerImage(named: "video_sliderControl_small"), for: .normal)
        playSlider.minimumTrackTintColor = BLUE  // 从最小值滑向最大值时杆的颜色
        playSlider.maximumTrackTintColor = UIColor.clear // 从最大值滑向最小值时杆的颜色
        playSlider.maximumValue = 1.0
        playSlider.value = 0.0
        return playSlider
    }()
    
    private lazy var loadProgress: UIProgressView = {
        let loadProgress = UIProgressView()
        loadProgress.progressTintColor = UIColor.red
        loadProgress.trackTintColor = UIColor.darkGray
        loadProgress.progress = 0.0
        return loadProgress
    }()
    
    private lazy var fullScreenBtn: UIButton = {
        let fullScreenBtn = UIButton()
        fullScreenBtn.setImage(ELPlayerImage(named: "video_fullScreen"), for: .normal)
        fullScreenBtn.addTarget(self, action: #selector(clickFullScreenBtn(_:)), for: .touchUpInside)
        sizeToFit()
        return fullScreenBtn
    }()
}
