
//
//  VideoUserInputCell.swift
//  VideoPlayer
//
//  Created by Soul on 20/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class VideoUserInputCell: UITableViewCell {
    
    var commentCallBack : (()->())?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        backgroundColor = WHITE
//        contentView.backgroundColor = WHITE
        selectionStyle = .none
        
        let toplineView = UIView()
        toplineView.backgroundColor = BACKGROUND_COLOR
        addSubview(toplineView)
        toplineView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(5)
        }
        
        addSubview(commentLabel)
        addSubview(commentNumberLabel)
        addSubview(iconView)
        addSubview(commentInputBackView)
        addSubview(placeholderLabel)
        
        commentLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(15)
            make.height.equalTo(15)
        }
        
        commentNumberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(commentLabel.snp.right).offset(10)
            make.centerY.equalTo(commentLabel)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(commentLabel.snp.bottom).offset(18)
            make.left.equalTo(commentLabel)
            make.width.height.equalTo(36)
        }
        
        commentInputBackView.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(36)
        }
        
        placeholderLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(commentInputBackView)
             make.left.equalTo(commentInputBackView).offset(20)
        }
        
    }
    
    
    // MARK: - Action
    
    @objc private func comment() {
        if commentCallBack != nil {
            commentCallBack!()
        }
    }
    
    lazy var commentLabel = UILabel(text: "评论", textColor: GRAY, fontSize: 13)
    
    private lazy var commentNumberLabel = UILabel(text: "0", textColor: GRAY_99, fontSize: 11)
    
    lazy var iconView : UIImageView = {
        let iconView = UIImageView()
        iconView.image = UIImage(named: "cat")
        return iconView
    }()
    
    lazy var commentInputBackView : UIView = {
        let  commentInputBackView = UIView()
        commentInputBackView.backgroundColor = RGB(r: 0xf1, g: 0xf2, b: 0xfd, alpha: 1)
        commentInputBackView.layer.cornerRadius = 18
        let tap = UITapGestureRecognizer(target: self, action: #selector(comment))
        commentInputBackView.addGestureRecognizer(tap)
        return commentInputBackView
    }()
    
    private lazy var placeholderLabel = UILabel(text: "说点什么吧!", textColor: GRAY_99, fontSize: 13)
}
