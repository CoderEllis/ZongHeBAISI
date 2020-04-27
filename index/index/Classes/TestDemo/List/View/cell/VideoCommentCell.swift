//
//  VideoCommentCell.swift
//  VideoPlayer
//
//  Created by Soul on 20/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class VideoCommentCell: UITableViewCell {

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
        
        addSubview(iconView)
        addSubview(nameLabel)
        addSubview(timeLabel)
        addSubview(likeNumberLabel)
        addSubview(likeBtn)
        addSubview(commentLabel)
        
        iconView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(15)
            make.width.height.equalTo(36)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.left.equalTo(iconView.snp.right).offset(10)
            make.height.equalTo(13)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.bottom.equalTo(iconView)
            make.height.equalTo(11)
        }
        
        commentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeLabel)
            make.top.equalTo(timeLabel.snp.bottom).offset(12)
            make.right.equalToSuperview().offset(-15)
        }
        
        likeNumberLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(nameLabel)
        }
        
        likeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(likeNumberLabel.snp.left).offset(-5)
            make.centerY.equalTo(likeNumberLabel)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = BACKGROUND_COLOR
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
    }
    
    // MARK: - Action
    
    @objc private func like() {
        print("like")
    }
    
    
    // MARK: - Lazy Load
    
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.image = UIImage(named: "jinx")
        return iconView
    }()
    
    private lazy var nameLabel = UILabel(text: "Name", textColor: BLACK, fontSize: 13)
    
    private lazy var timeLabel = UILabel(text: "1分钟前", textColor: GRAY_99, fontSize: 11)
    
    private lazy var likeNumberLabel = UILabel(text: "0", textColor: GRAY_99, fontSize: 11)
    
    private lazy var likeBtn: UIButton = {
        let likeBtn = UIButton()
        likeBtn.setImage(UIImage(named: "video_comment_like"), for: .normal)
        likeBtn.addTarget(self, action: #selector(self.like), for: .touchUpInside)
        return likeBtn
    }()
    
    private lazy var commentLabel: UILabel = {
        let commentLabel = UILabel(text: "Comment...", textColor: BLACK, fontSize: 13)
        commentLabel.numberOfLines = 0
        return commentLabel
    }()

}
