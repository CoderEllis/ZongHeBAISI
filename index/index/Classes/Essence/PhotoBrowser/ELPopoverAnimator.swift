//
//  PopoverAnimator.swift
//  index
//
//  Created by Soul on 15/6/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

// 面向协议开发
protocol AnimatorPresentedDelegate: NSObjectProtocol {
    func startRect() -> CGRect
    func endRect() -> CGRect
    func backImageView() -> UIImageView
}

protocol AnimatorDismissDelegate: NSObjectProtocol {
    func imageViewForDimissView() -> UIImageView
}

class ELPopoverAnimator: NSObject {
    
    weak var presentedDelegate : AnimatorPresentedDelegate?
    weak var dismissDelegate : AnimatorDismissDelegate?
    
    private var isPresented : Bool = false
    
    private weak var presentCtrl: ELPresentationController?
    ///蒙版透明
    public var maskAlpha: CGFloat {
        set {
            presentCtrl?.alpha = newValue
        }
        get {
            return presentCtrl?.alpha ?? 0
        }
    }
    
    deinit {
        print("PhotoBrowserAnimator----销毁")
    }
}

//UIPresentationController
// MARK:- 自定义转场代理的方法
extension ELPopoverAnimator : UIViewControllerTransitioningDelegate {
    //弹出的控制器
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentation = ELPresentationController(presentedViewController: presented, presenting: presenting)
        presentCtrl = presentation
        return presentation
    }
    
    // 目的:自定义弹出的动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    // 目的:自定义消失的动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}


// MARK:- 弹出和消失动画代理的方法
extension ELPopoverAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(transitionContext) : animationForDismissView(transitionContext) 
    }
    
    
    ///自定义弹出动画
    func animationForPresentedView(_ transitionContext: UIViewControllerContextTransitioning) {
        // 0.nil值校验
        guard let presentedDelegate = presentedDelegate else {
            return
        }
        
        //1.取出弹出的View
        let presentedView = transitionContext.view(forKey: .to)!
        
        // 2.将prensentedView添加到containerView中
        transitionContext.containerView.addSubview(presentedView)
        
        // 3.获取执行动画的imageView
        let startRect = presentedDelegate.startRect()
        let imageView = presentedDelegate.backImageView()
        transitionContext.containerView.addSubview(imageView)
        imageView.frame = startRect
        
        // 4.执行动画
        presentedView.alpha = 0.0
        transitionContext.containerView.backgroundColor = UIColor.black
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView.frame = presentedDelegate.endRect()
        }) { (_) in
            imageView.removeFromSuperview()
            presentedView.alpha = 1.0
            transitionContext.containerView.backgroundColor = UIColor.clear
            transitionContext.completeTransition(true) //告诉上下文完成动画
        }
    }
    
    ///自定义消失动画
    func animationForDismissView(_ transitionContext: UIViewControllerContextTransitioning) {
        
        guard let dismissDelegate = dismissDelegate,let presentedDelegate = presentedDelegate else {
            return
        }
        
        let dismissView = transitionContext.view(forKey: .from)
        dismissView?.removeFromSuperview()
        
        // 2.获取执行动画的ImageView
        let imageView = dismissDelegate.imageViewForDimissView()
        transitionContext.containerView.addSubview(imageView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            imageView.frame = presentedDelegate.startRect()
            
        }) { (_) in
            imageView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
