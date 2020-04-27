//
//  ELSeeBigPictureViewController.swift
//  index
//
//  Created by Soul on 14/6/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELSeeBigPictureViewController: UIViewController {
    
//    var picURLs : URL
//    var topic : ELTopicModel
    
    var topic : user
    
    
    //转场蒙版View背景回调
    typealias bgTransitionMask  = (_ scale: CGFloat) -> ()
    var originFrameCallback: bgTransitionMask
    
    init(_ topic: user, back: @escaping bgTransitionMask) {
        self.originFrameCallback = back
        self.topic = topic
        super.init(nibName: nil, bundle: nil)
        //设置modal样式 跳转方式
        modalPresentationStyle = .custom
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("ELSeeBigPictureViewController----销毁")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        view.addSubview(picView)
        picView.picURL = topic
    }
    
    lazy var picView: containerView = {
        let picView  = containerView(frame: view.bounds)
        picView.delegate = self
        return picView
    }()
}

extension ELSeeBigPictureViewController : PhotoBrowserViewCellDelegate {
    @objc private func closeBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    
    func imageViewOneClickClose() {
        closeBtnClick()
    }
    
    //长安手势
    func imageViewLongClick() {
        
    }
    
    func panChangedCallback(_ scale: CGFloat) {
        let alpha = scale * scale
        self.originFrameCallback(alpha)
//        self.coverStatusBar(scale > 0.95)
    }
    
    func panReleasedCallback(_ isDown: Bool) {
        if isDown {
            closeBtnClick()
        } else {
            self.originFrameCallback(1.0)
        }
    }
    
}

extension ELSeeBigPictureViewController: AnimatorDismissDelegate {
    func imageViewForDimissView() -> UIImageView {
        return picView.imageView
    }
    
    
}
