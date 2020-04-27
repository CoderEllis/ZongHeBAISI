//
//  ELPresentationController.swift
//  index
//
//  Created by Soul on 15/6/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELPresentationController: UIPresentationController {
    /// 蒙板 alpha
    var alpha : CGFloat? {
        didSet {
            guard let alpha = alpha else {return}
            maskView.alpha = alpha
        }
    }
    
    var backgroundColor: UIColor = UIColor.black
    // 蒙版View
    private lazy var maskView: UIView = {
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.alpha = 0
        return view
    }()
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let containerView = self.containerView else { return }
        
        containerView.addSubview(maskView)
        maskView.frame = containerView.bounds
        maskView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (_) in
            self.maskView.alpha = 1
        }, completion: nil)
    }
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (_) in
            self.maskView.alpha = 0
        }, completion: nil)
    }
}
