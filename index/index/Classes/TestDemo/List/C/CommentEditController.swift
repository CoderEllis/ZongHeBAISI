//
//  CommentEditController.swift
//  VideoPlayer
//
//  Created by Soul on 20/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class CommentEditController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = WHITE
        setupUI()
        setupEvent()
        textView.becomeFirstResponder()
    }
    
    deinit {
        print("CommentEditController deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.setBackgroundImage(UIImage.colorImage(color: RGB(r: 0xf6, g: 0xf7, b: 0xf8, alpha: 1)), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .default
        }
    }
    
    func setupUI() {
        navigationController?.navigationBar.layer.shadowColor = RGB(r: 0xee, g: 0xee, b: 0xee, alpha: 1).cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        navigationController?.navigationBar.layer.shadowOpacity = 1
        navigationController?.navigationBar.layer.shadowRadius = 0.5
        
        navigationItem.titleView = naviTitleLabel(title: "评论")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .done, target: self, action: #selector(sendComment))
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "video_commentClose", title: "", target: self, action: #selector(close))
        
        view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(5)
             make.bottom.right.equalToSuperview().offset(-5)
        }
        
        view.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(13)
            make.leading.equalToSuperview().offset(9)
        }
    }

    private func setupEvent() {
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChanged), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    // MARK: - Action
    
    @objc private func sendComment() {
        
    }
    
    @objc private func close() {
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Event
    
    @objc private func textViewDidChanged() {
        if textView.text?.count == 0 {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
    }
    func naviTitleLabel(title: String) -> UILabel {
        let titleLabel = UILabel(text: title, textColor: BLACK_26, fontSize: 16)
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        titleLabel.sizeToFit()
        return titleLabel
    }
    
    // MARK: - Lazy Load
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = BLACK
        return textView
    }()
    
    private lazy var placeholderLabel = UILabel(text: "此时此刻的感想......", textColor: GRAY_99, fontSize: 15)
    
}
