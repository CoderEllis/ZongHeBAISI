//
//  VideoCommentView.swift
//  VideoPlayer
//
//  Created by Soul on 20/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class VideoCommentView: UIView {

    var commentCallBack : (()->())?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.yellow
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        backgroundColor = WHITE
        
        addSubview(commentLabel)
        addSubview(commentNumberLabel)
        addSubview(closeBtn)
        addSubview(iconView)
        addSubview(commentInputBackView)
        addSubview(placeholderLabel)
        addSubview(tableView)
        
        commentLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(15)
        }
        
        commentNumberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(commentLabel.snp.right).offset(10)
            make.centerY.equalTo(commentLabel)
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-5)
            make.width.height.equalTo(40)
            make.centerY.equalTo(commentLabel)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(commentLabel.snp.bottom).offset(18)
            make.left.equalToSuperview().offset(15)
            make.height.width.equalTo(36)
        }
        
        commentInputBackView.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(36)
        }
        
        placeholderLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(commentInputBackView)
            make.left.equalTo(commentInputBackView).offset(20)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = BACKGROUND_COLOR
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.leading.bottom.trailing.equalToSuperview()
        }
        
    }
    
    // MARK: - Action
    
    @objc private func comment() {
        if commentCallBack != nil {
            commentCallBack!()
        }
    }
    
    @objc private func clickCloseBtn() {
        UIView.animate(withDuration: 0.25) { 
            self.y = ScreenHeight
        }

    }
    
    
    // MARK: - Lazy Load
    
    private lazy var commentLabel = UILabel(text: "评论", textColor: GRAY, fontSize: 13)
    
    private lazy var commentNumberLabel = UILabel(text: "0", textColor: GRAY_99, fontSize: 11)
    
    private lazy var closeBtn: UIButton = {
        let closeBtn = UIButton()
        closeBtn.setImage(UIImage(named: "video_commentClose"), for: .normal)
        closeBtn.addTarget(self, action: #selector(self.clickCloseBtn), for: .touchUpInside)
        return closeBtn
    }()
    
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.image = UIImage(named: "cat")
        return iconView
    }()
    
    private lazy var commentInputBackView: UIView = {
        let commentInputBackView = UIView()
        commentInputBackView.backgroundColor = RGB(r: 0xf1, g: 0xf2, b: 0xfd, alpha: 1)
        commentInputBackView.layer.cornerRadius = 18
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.comment))
        commentInputBackView.addGestureRecognizer(tap)
        return commentInputBackView
    }()
    
    private lazy var placeholderLabel = UILabel(text: "说点什么吧!", textColor: GRAY_99, fontSize: 13)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = WHITE
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(VideoCommentCell.self, forCellReuseIdentifier: "CommentCell")
        
        
        return tableView
    }()
}

extension VideoCommentView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! VideoCommentCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
