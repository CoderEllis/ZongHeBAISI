//
//  MessageVC.swift
//  QR_Code
//
//  Created by Soul Ai on 15/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

import UIKit

class MessageVC: UIViewController {

    var data = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        let webView = UIWebView()
        webView.frame = UIScreen.main.bounds
        
        if data.contains("http") {
            webView.loadRequest(URLRequest.init(url: URL.init(string: data)!))
        }else {
            webView.loadHTMLString(data, baseURL: nil)
        }
        webView.isOpaque = false
        self.view.addSubview(webView)
        
    }
    

    

}
