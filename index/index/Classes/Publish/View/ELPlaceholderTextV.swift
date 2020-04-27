//
//  ELPlaceholderTextV.swift
//  index
//
//  Created by Soul on 20/6/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELPlaceholderTextV: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        alwaysBounceVertical = true
        
        setupUI()
        
    }
    
    
    open var placeholder : String? {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    open var placeholderColor : UIColor? {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    
//    override var text: String! {
//        didSet {
//            textDidChange()
//        }
//    }
    
    override var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
    
//    override var font: UIFont? {
//        didSet {
//            placeholderLabel.font = font
//            setNeedsLayout()
//        }
//    }
    
    @objc func textDidChange() {
        placeholderLabel.isHidden = self.hasText
        setNeedsDisplay()
    }
    
    private func setupUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
        font = UIFont.systemFont(ofSize: 15)
        addSubview(placeholderLabel)
        delegate = self
    }
    
    func updatePlaceholderLabelSize() {
        let maxSize = CGSize(width: ScreenWidth - 2 * placeholderLabel.x , height: CGFloat(MAXFLOAT))
        if placeholder != nil {
            placeholderLabel.size = (placeholder! as NSString).boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font ?? UIFont.systemFont(ofSize: 15)], context: nil).size
        } 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.width = self.width - 2 * placeholderLabel.x
        placeholderLabel.sizeToFit()
    }
    private lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.numberOfLines = 0
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.font = font
        placeholderLabel.text = "写下点什么吧..."
        placeholderLabel.frame.origin = CGPoint(x: 4, y: 7)
        return placeholderLabel
    }()
}


// MARK: - UITextViewDelegate
extension ELPlaceholderTextV: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.location > 99 {
            return false
        } else {
            return true
        }
    }
}
