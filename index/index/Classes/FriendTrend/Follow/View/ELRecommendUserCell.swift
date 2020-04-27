//
//  ELRecommendUserCell.swift
//  index
//
//  Created by Soul on 2/6/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELRecommendUserCell: UITableViewCell {
    var user : ELRecommendUserM? {
        didSet {
            guard let user = user else { return }
            nameLabel.text = user.screen_name
            iconView.setHeader(headerUrl: user.header!)
            if user.fans_count! >= 10000 {
                fansCountLbl.text = String(format: "%.1f万人关注",CGFloat(user.fans_count!) / 10000.0) 
            } else {
                fansCountLbl.text = String(format: "%zd人关注", user.fans_count!)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        addSubview(iconView)
        addSubview(nameLabel)
        addSubview(fansCountLbl)
        addSubview(followBtn)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
            make.left.equalToSuperview().offset(10)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(10)
        }
        
        fansCountLbl.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(10)
        }
        
        followBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(55)
        }
    }
    
    lazy var iconView = UIImageView()
    lazy var nameLabel : UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 17)
        return nameLabel
    }()
    
    lazy var fansCountLbl : UILabel = {
        let fansCountLbl = UILabel()
        fansCountLbl.font = UIFont.systemFont(ofSize: 13)
        return fansCountLbl
    }()
    
    lazy var followBtn : UIButton = {
        let followBtn = UIButton()
        followBtn.setTitle("+ 关注", for: UIControl.State.normal)
        followBtn.setTitleColor(UIColor.red, for: UIControl.State.normal)
        followBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        followBtn.setBackgroundImage(UIImage(named: "FollowBtnBg"), for: UIControl.State.normal)
        return followBtn
    }()
}
