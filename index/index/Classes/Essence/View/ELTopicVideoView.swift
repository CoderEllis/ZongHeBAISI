//
//  ELTopicVideoView.swift
//  index
//
//  Created by Soul on 10/6/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELTopicVideoView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
       
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //        translatesAutoresizingMaskIntoConstraints = false
        setUI()
    }
    
    var topicHandy : ELTopicModel? {
        didSet {
            guard let topic = topicHandy else { return }
            self.plachImageView.isHidden = false
            
            imageView.kf.setImage(with: URL(string: topic.image1 ?? topic.image2 ?? ""), placeholder: UIImage(named: "plachImage"), options: [.transition(.fade(1))], progressBlock: nil) { (result) in
                self.plachImageView.isHidden = true
            }
            playcountLabel.text = playCount(topic.playcount)
            timeLabel.text = String(format: "%02zd:%02zd", topic.videotime / 60, topic.videotime % 60)
        }
    }
    
    
    var topic : user? {
        didSet {
            guard let topic = topic else { return }
            self.plachImageView.isHidden = false
            
            imageView.kf.setImage(with: URL(string: topic.image1 ?? topic.image2 ?? ""), placeholder: UIImage(named: "plachImage"), options: [.transition(.fade(1))], progressBlock: nil) { (result) in
                self.plachImageView.isHidden = true
            }
            playcountLabel.text = playCount(topic.playcount?.int ?? 0)
            timeLabel.text = String(format: "%02zd:%02zd", topic.videotime?.int ?? 0 / 60, topic.videotime?.int ?? 0 % 60)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func setUI() {
        addSubview(plachImageView)
        addSubview(imageView)
        addSubview(playBtn)
        addSubview(playcountLabel)
        addSubview(timeLabel)
        plachImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(50)
            make.left.right.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        playBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        playcountLabel.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
        }
        timeLabel.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
        }
    }
    
    @objc func playBtn(_ playBtn: UIButton) {
        playBtn.isSelected = !playBtn.isSelected
    }
    
    lazy var plachImageView = UIImageView(image: UIImage(named: "imageBackground"))
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(seeBigPicture))
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    lazy var playBtn: UIButton = {
        let playBtn = UIButton(type: UIButton.ButtonType.custom)
        playBtn.setImage(UIImage(named: "video-play"), for: UIControl.State.normal)
        playBtn.addTarget(self, action: #selector(playBtn(_:)), for: UIControl.Event.touchUpInside)
        return playBtn
    }()
    
    lazy var playcountLabel: UILabel = {
        let playcountLabel = UILabel()
        playcountLabel.text = "4343播放"
        playcountLabel.textColor = UIColor.darkText
        playcountLabel.font = UIFont.systemFont(ofSize: 17)
        return playcountLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.text = "03:20"
        timeLabel.textColor = UIColor.darkText
        timeLabel.font = UIFont.systemFont(ofSize: 17)
        return timeLabel
    }()
    

    @objc private func seeBigPicture() {
        NotificationCenter.default.post(name: NSNotification.Name(ELTopicVideoViewClickNotification), object: nil)
    }
}
