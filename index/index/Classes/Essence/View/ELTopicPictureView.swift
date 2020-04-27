//
//  ELTopicPictureView.swift
//  index
//
//  Created by Soul on 10/6/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit
import Kingfisher

class ELTopicPictureView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var topicHandy : ELTopicModel? {
        didSet {
            guard let topic = topicHandy else { return }
            self.plachImageView.isHidden = false
           
            //圆角 options:  .processor(processor)
//            let processor = DownsamplingImageProcessor(size: imageView.size)
//                >> RoundCornerImageProcessor(cornerRadius: 20)
            //options .scaleFactor(UIScreen.main.scale),.cacheOriginalImage,.transition(.fade(1))
            //菊花
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: URL(string: topic.image0 ?? ""), placeholder: UIImage(named: "plachImage"), options: [], progressBlock: nil) { (result) in
                self.plachImageView.isHidden = true
                
                switch result {
                case .success(let value):
                    self.imageView.image = value.image
                    
                    if topic.array.bigPicture {
                        let imageW = topic.array.middleFrame.size.width
                        let imageH = imageW * CGFloat(topic.height) / CGFloat(topic.width)
                        UIGraphicsBeginImageContext(CGSize(width: imageW, height: imageH))
                        self.imageView.image?.draw(in: CGRect(x: 0, y: 0, width: imageW, height: imageH))
                        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                        
                    }
                    
                case .failure(_): break
                    
                }
            }
            
            gifView.isHidden = !topic.is_gif
            
            if topic.array.bigPicture {
                seeBigPicBtn.isHidden = false
                imageView.contentMode = .scaleAspectFit
                imageView.clipsToBounds = true
            } else {
                seeBigPicBtn.isHidden = true
                imageView.contentMode = .scaleToFill
                imageView.clipsToBounds = false
                
            }
        }
        
    }
    
    var topic : user? {
        didSet {
            guard let topic = topic else { return }
            self.plachImageView.isHidden = false
            
            //圆角 options:  .processor(processor)
            //            let processor = DownsamplingImageProcessor(size: imageView.size)
            //                >> RoundCornerImageProcessor(cornerRadius: 20)
            //options .scaleFactor(UIScreen.main.scale),.cacheOriginalImage,.transition(.fade(1))
            //菊花
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: URL(string: topic.image0 ?? ""), placeholder: UIImage(named: "plachImage"), options: [], progressBlock: nil) { (result) in
                self.plachImageView.isHidden = true
                
                switch result {
                case .success(let value):
                    self.imageView.image = value.image
                    
                    if topic.array.bigPicture {
                        let imageW = topic.array.middleFrame.size.width
                        let imageH = imageW * CGFloat(topic.height?.int ?? 0) / CGFloat(topic.width?.int ?? 0)
                        UIGraphicsBeginImageContext(CGSize(width: imageW, height: imageH))
                        self.imageView.image?.draw(in: CGRect(x: 0, y: 0, width: imageW, height: imageH))
                        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                        
                    }
                    
                case .failure(_): break
                    
                }
            }
            
//            gifView.isHidden = !topic.is_gif
            
            if topic.array.bigPicture {
                seeBigPicBtn.isHidden = false
                imageView.contentMode = .scaleAspectFit
                imageView.clipsToBounds = true
            } else {
                seeBigPicBtn.isHidden = true
                imageView.contentMode = .scaleToFill
                imageView.clipsToBounds = false
                
            }
        }
        
    }
    
    
    private lazy var popoverAnimator = ELPopoverAnimator()
    
    @objc func seeBigPicture() {
        
        guard let topic = topic else { return }
        
        let seePicView = ELSeeBigPictureViewController(topic) { [weak self] (press) in
            self?.popoverAnimator.maskAlpha = press
        }
        
        // 3.设置转场的代理
        seePicView.transitioningDelegate = popoverAnimator
        popoverAnimator.presentedDelegate = self
        popoverAnimator.dismissDelegate = seePicView
        window?.rootViewController?.present(seePicView, animated: true, completion: nil)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        plachImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(50)
            make.left.right.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        gifView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.width.height.equalTo(31)
        }
        
        seeBigPicBtn.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    private func setUI() {
        addSubview(plachImageView)
        addSubview(imageView)
        addSubview(gifView)
        addSubview(seeBigPicBtn)
    }
    
    
    lazy var plachImageView = UIImageView(image: UIImage(named: "imageBackground"))
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(seeBigPicture))
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    lazy var gifView = UIImageView(image: UIImage(named: "common-gif"))
    
    lazy var seeBigPicBtn: UIButton = {
        let seeBigPicBtn = UIButton(type: UIButton.ButtonType.custom)
        seeBigPicBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        seeBigPicBtn.setTitle("点击查看大图", for: UIControl.State.normal)
        seeBigPicBtn.setImage(UIImage(named: "see-big-picture"), for: UIControl.State.normal)
        seeBigPicBtn.setBackgroundImage(UIImage(named: "see-big-picture-background"), for: UIControl.State.normal)
        seeBigPicBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        seeBigPicBtn.isEnabled = false
        seeBigPicBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        seeBigPicBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        return seeBigPicBtn
    }()
}

extension ELTopicPictureView : AnimatorPresentedDelegate {
    func startRect() -> CGRect {
        let frame = convert(imageView.frame, to: UIApplication.shared.keyWindow)
        return frame
    }
    
    func endRect() -> CGRect {
        guard let image = self.imageView.image else {return CGRect.zero}
        
        let w = UIScreen.main.bounds.width
        let h = w / image.size.width * image.size.height
        var y : CGFloat = 0
        if h > UIScreen.main.bounds.height {
            y = 0
        } else {
            y = (UIScreen.main.bounds.height - h) * 0.5
        }
        
        return CGRect(x: 0, y: y, width: w, height: h)
    }
    
    func backImageView() -> UIImageView {
        let ima = UIImageView()
        ima.image = self.imageView.image
        ima.contentMode = .scaleAspectFit
        ima.clipsToBounds = true
        return ima
    }
    
    
}
