//
//  VideoInfoCell.swift
//  VideoPlayer
//
//  Created by Soul on 20/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class VideoInfoCell: UITableViewCell {

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
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(nextView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(15)
            make.top.equalTo(lineView.snp.bottom).offset(18)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.bottom.equalTo(contentView).offset(-18)
            make.right.equalTo(nextView.snp.left).offset(-10)
        }
        nextView.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-15)
            make.centerY.equalTo(contentView).offset(5)
        }
    }
    
    // MARK: - Lazy Load
    
    private lazy var titleLabel = UILabel(text: "Title", textColor: BLACK, fontSize: 14)
    
    private lazy var detailLabel = UILabel(text: "Details...", textColor: GRAY_99, fontSize: 12)
    
    private lazy var nextView = UIImageView(image: UIImage(named: "video_next"))
}
