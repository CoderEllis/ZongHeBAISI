//
//  VideoAuthorInfoCell.swift
//  VideoPlayer
//
//  Created by Soul on 20/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class VideoAuthorInfoCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        backgroundColor = WHITE
        contentView.backgroundColor = WHITE
        selectionStyle = .none
        
        let lineView = UIView()
        lineView.backgroundColor = BACKGROUND_COLOR
        contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalTo(contentView)
            make.height.equalTo(5)
        }
        
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(followBtn)
        
        iconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView).offset(5)
            make.left.equalTo(contentView).offset(15)
            make.width.height.equalTo(36)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView).offset(5)
            make.left.equalTo(iconView.snp.right).offset(10)
        }
        
        followBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(iconView)
            make.right.equalTo(contentView).offset(-15)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
    }
    
    // MARK: - Action
    
    @objc private func clickFollowBtn() {
        print("follow")
    }
    
    private lazy var iconView: UIImageView  = {
        let iconView = UIImageView(image: UIImage(named: "jinx"))
        return iconView
    }()
    
    private lazy var nameLabel = UILabel(text: "Name", textColor: BLACK, fontSize: 14)
    
    private lazy var followBtn: UIButton = {
        let followBtn = UIButton()
        followBtn.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        followBtn.layer.cornerRadius = 15
        followBtn.layer.masksToBounds = true
        followBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        followBtn.setTitle("关注", for: .normal)
        followBtn.setTitleColor(WHITE, for: .normal)
        followBtn.setBackgroundImage(UIImage.colorImage(color: BLUE, size: followBtn.size), for: .normal)
        followBtn.setBackgroundImage(UIImage.colorImage(color: RGB(r: 0x00, g: 0x56, b: 0xff, alpha: 0.8), size: followBtn.size), for: .highlighted)
        followBtn.addTarget(self, action: #selector(clickFollowBtn), for: .touchUpInside)
        followBtn.sizeToFit()
        return followBtn 
    }()

}
