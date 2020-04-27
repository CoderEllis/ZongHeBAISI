

//
//  ELWebViewController.swift
//  index
//
//  Created by Soul on 29/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit
import WebKit

class ELWebViewController: UIViewController {

    var url : URL? {
        didSet {
            guard let url = url else {
                return
            }
            //// 展示网页
            let request = URLRequest(url: url) 
            webView.load(request)
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        addObserver()
        
    }
    
    // KVO监听属性改变
    /*
     Observer:观察者
     KeyPath:观察webView哪个属性
     options:NSKeyValueObservingOptionNew:观察新值改变
     
     KVO注意点.一定要记得移除 dealloc
     */
    func addObserver() {
        webView.addObserver(self, forKeyPath: "canGoBack", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "goForward", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = contentView.bounds
        
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "canGoBack")
        webView.removeObserver(self, forKeyPath: "goForward")
        webView.removeObserver(self, forKeyPath: "title")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        backItem.isEnabled = webView.canGoBack
        forwardItem.isEnabled = webView.canGoForward
        title = webView.title
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = webView.estimatedProgress > 1
    }
    
    
    func setUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(toolBar)
        toolBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        view.addSubview(contentView)
        contentView.backgroundColor = UIColor.red
        contentView.addSubview(progressView)
        contentView.addSubview(webView)
        
        contentView.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(toolBar.snp.top)
        }
        
        progressView.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(contentView)
            make.height.equalTo(2)
        }
        
    }
    
    
    
    lazy var webView = WKWebView()
    lazy var progressView = UIProgressView()
    lazy var contentView = UIView()
    
    lazy var toolBar : UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.items = [backItem,forwardItem,nilItem,refreshItem]
        return toolBar
    }()
    
    lazy var backItem : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Yellow_3D_arrow_left"), style: UIBarButtonItem.Style.done, target: self, action: #selector(goBack))
    
    lazy var forwardItem : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Yellow_3D_arrow_right"), style: UIBarButtonItem.Style.done, target: self, action: #selector(goForward))
    
    lazy var refreshItem : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Yellow_3D_arrow_refresh"), style: UIBarButtonItem.Style.done, target: self, action: #selector(reload))
    
    lazy var nilItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    
    
    
    @objc func goBack() {
        webView.goBack()
    }
    
    @objc func goForward() {
        webView.goForward()
    }
    
    @objc func reload() {
        webView.reload()
    }
    
}
