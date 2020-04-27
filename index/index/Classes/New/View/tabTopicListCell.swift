//
//  tabTopicListCell.swift
//  index
//
//  Created by Soul on 6/7/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class tabTopicListCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //cell 间距设置
    override var frame: CGRect {
        didSet {
            var newFrame = frame
            newFrame.size.height -= ELMarin
            super.frame = newFrame
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(10)
            make.width.height.equalTo(35)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView)
            make.left.equalTo(profileImageView.snp.right).offset(20)
        }
        
        passTimeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(profileImageView)
            make.left.equalTo(profileImageView.snp.right).offset(20)
        }
        
        moreBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(30)
        }
        
        text_label.snp.makeConstraints { (make) in
            make.left.equalTo(profileImageView)
            make.right.equalTo(moreBtn)
            make.top.equalTo(passTimeLabel.snp.bottom).offset(10)
        }
        
        topCmtView.snp.makeConstraints { (make) in
            make.left.right.equalTo(text_label)
            make.bottom.equalTo(bottomCmtView.snp.top).offset(-10)
        }
        
        hotCmtLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
        }
        
        topCmtLabel.snp.makeConstraints { (make) in
            make.bottom.right.left.equalToSuperview()
            make.top.equalTo(hotCmtLabel.snp.bottom)
        }
        
        bottomCmtView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(35)
        }
        
        bgImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        zanBtn.snp.makeConstraints { (make) in
            make.top.equalTo(bgImageView.snp.bottom)
            make.left.bottom.equalToSuperview()
            make.right.equalTo(bgImageView0.snp.left)
        }
        
        bgImageView0.snp.makeConstraints { (make) in
            make.top.equalTo(bgImageView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalTo(1)
        }
        
        caiBtn.snp.makeConstraints { (make) in
            make.top.equalTo(bgImageView.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.equalTo(bgImageView0.snp.right)
            make.right.equalTo(bgImageView1.snp.left)
            make.width.equalTo(zanBtn)
        }
        
        bgImageView1.snp.makeConstraints { (make) in
            make.top.equalTo(bgImageView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalTo(1)
        }
        
        repostBtn.snp.makeConstraints { (make) in
            make.top.equalTo(bgImageView.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.equalTo(bgImageView1.snp.right)
            make.right.equalTo(bgImageView2.snp.left)
            make.width.equalTo(zanBtn)
        }
        
        bgImageView2.snp.makeConstraints { (make) in
            make.top.equalTo(bgImageView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalTo(1)
        }
        
        commentBtn.snp.makeConstraints { (make) in
            make.top.equalTo(bgImageView.snp.bottom)
            make.bottom.right.equalToSuperview()
            make.left.equalTo(bgImageView2.snp.right)
            make.width.equalTo(zanBtn)
        }
        
    }
    
    func setUI() {
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(passTimeLabel)
        addSubview(moreBtn)
        addSubview(text_label)
        
        addSubview(topCmtView)
        topCmtView.addSubview(hotCmtLabel)
        topCmtView.addSubview(topCmtLabel)
        
        addSubview(bottomCmtView)
        bottomCmtView.addSubview(bgImageView)
        bottomCmtView.addSubview(bgImageView0)
        bottomCmtView.addSubview(bgImageView1)
        bottomCmtView.addSubview(bgImageView2)
        bottomCmtView.addSubview(zanBtn)
        bottomCmtView.addSubview(caiBtn)
        bottomCmtView.addSubview(repostBtn)
        bottomCmtView.addSubview(commentBtn)
    }
    
    lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        return profileImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 17)
        nameLabel.textColor = UIColor.darkText
        return nameLabel
    }()
    
    lazy var passTimeLabel: UILabel = {
        let passTimeLabel = UILabel()
        passTimeLabel.font = UIFont.systemFont(ofSize: 14)
        passTimeLabel.textColor = UIColor.lightGray
        return passTimeLabel
    }()
    
    lazy var moreBtn: UIButton = {
        let moreBtn = UIButton(type: UIButton.ButtonType.custom)
        moreBtn.setImage(UIImage(named: "cellmorebtnnormal"), for: UIControl.State.normal)
        return moreBtn
    }()
    
    lazy var text_label: UILabel = {
        let text_label = UILabel()
        text_label.font = UIFont.systemFont(ofSize: 15)
        text_label.textAlignment = .left
        text_label.textColor = UIColor.darkText
        text_label.numberOfLines = 0
        return text_label
    }()
    
    lazy var topCmtView = UIView()
    
    lazy var hotCmtLabel: UILabel = {
        let hotCmtLabel = UILabel()
        hotCmtLabel.text = "最热评论"
        hotCmtLabel.font = UIFont.systemFont(ofSize: 17)
        hotCmtLabel.textColor = UIColor.red
        return hotCmtLabel
    }()
    
    lazy var topCmtLabel: UILabel = {
        let topCmtLabel = UILabel()
        topCmtLabel.text = "评论内容评论内容评论内容评论内容评论内容评评论内容评论内容评论内容评论内评论内容评论内容评论内容评论内评论内容评论内容评论内容评论内评论内容评论内容评论内容评论内评论内容评论内容评论内容评论内评论内容评论内容评论内容评论内"
        topCmtLabel.font = UIFont.systemFont(ofSize: 16)
        topCmtLabel.textColor = UIColor.darkText
        topCmtLabel.numberOfLines = 0
        return topCmtLabel
    }()
    
    lazy var bottomCmtView = UIView()
    
    lazy var bgImageView = UIImageView(image: UIImage(named: "cell-content-line"))
    lazy var bgImageView0 = UIImageView(image: UIImage(named: "cell-content-line"))
    lazy var bgImageView1 = UIImageView(image: UIImage(named: "cell-content-line"))
    lazy var bgImageView2 = UIImageView(image: UIImage(named: "cell-content-line"))
    
    lazy var zanBtn: UIButton = {
        let zanBtn = UIButton(type: UIButton.ButtonType.custom)
        zanBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        zanBtn.setTitle("赞", for: UIControl.State.normal)
        zanBtn.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        zanBtn.setImage(UIImage(named: "mainCellDing"), for: UIControl.State.normal)
        zanBtn.setImage(UIImage(named: "mainCellDingClick"), for: UIControl.State.highlighted)
        zanBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        zanBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        return zanBtn
    }()
    
    lazy var caiBtn: UIButton = {
        let caiBtn = UIButton(type: UIButton.ButtonType.custom)
        caiBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        caiBtn.setTitle("踩", for: UIControl.State.normal)
        caiBtn.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        caiBtn.setImage(UIImage(named: "mainCellCai"), for: UIControl.State.normal)
        caiBtn.setImage(UIImage(named: "mainCellCaiClick"), for: UIControl.State.highlighted)
        caiBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        caiBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        return caiBtn
    }()
    
    lazy var repostBtn: UIButton = {
        let repostBtn = UIButton(type: UIButton.ButtonType.custom)
        repostBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        repostBtn.setTitle("转发", for: UIControl.State.normal)
        repostBtn.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        repostBtn.setImage(UIImage(named: "mainCellShare"), for: UIControl.State.normal)
        repostBtn.setImage(UIImage(named: "mainCellShareClick"), for: UIControl.State.highlighted)
        repostBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        repostBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        return repostBtn
    }()
    
    lazy var commentBtn: UIButton = {
        let commentBtn = UIButton(type: UIButton.ButtonType.custom)
        commentBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        commentBtn.setTitle("评论", for: UIControl.State.normal)
        commentBtn.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        commentBtn.setImage(UIImage(named: "mainCellComment"), for: UIControl.State.normal)
        commentBtn.setImage(UIImage(named: "mainCellCommentClick"), for: UIControl.State.highlighted)
        commentBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        commentBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        return commentBtn
    }()

}
