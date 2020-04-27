//
//  ELPublishViewController.swift
//  index
//
//  Created by Soul on 26/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELPublishViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBase()
        view.addSubview(textView)
    }
    
    private func setupBase() {
        view.backgroundColor = UIColor.white
        title = "发表段子"
        navigationItem.leftBarButtonItem = UIBarButtonItem(itemColor: UIColor.black, highColor: UIColor.red, target: self, ation: #selector(cancel), title: "取消")
        navigationItem.rightBarButtonItem = UIBarButtonItem(itemColor: UIColor.black, highColor: UIColor.red, target: self, ation: #selector(post), title: "发表")
        navigationController?.navigationBar.layoutIfNeeded()
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func post() {
        
    }
    
    lazy var textView: ELPlaceholderTextV = {
        let textView = ELPlaceholderTextV()
        textView.frame = view.bounds
        textView.placeholder = "写下你的奇趣怪谈⏎"
        textView.placeholderColor = UIColor.magenta
        textView.delegate = self
        return textView
    }()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.rightBarButtonItem?.isEnabled = false
        view.endEditing(true)
        textView.becomeFirstResponder()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.resignFirstResponder()
        view.endEditing(true)
    }
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}


// MARK: - UITextViewDelegate
extension ELPublishViewController: UITextViewDelegate {
    
}
