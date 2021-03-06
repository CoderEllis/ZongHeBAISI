



//
//  VideoListCell.swift
//  VideoPlayer
//
//  Created by Soul on 19/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class VideoListCell: UITableViewCell {
    
    var video : DemoVideoModel? {
        didSet {
            guard let video = video else {
                return
            }
            //options:渐变的方式显示
            frontCoverView.kf.setImage(with: URL(string: video.poster), placeholder: UIImage(named: PLACEHOLDER_VIDEO), options: [.transition(.fade(1))], progressBlock: nil) { (result) in
                
            }
            lengthLabel.text = getTimeLengthStr(length: video.length)
            typeLabel.text = video.typeString
            timeLabel.text = convertToDate(time: video.time)
            watchNumberLabel.text =  "\(video.view_number)"
            commentNumberLabel.text = "\(video.comment_number)"
//            titleLabel.text = video.time
            detailsLabel.text = video.detail
        }
        
    }
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUI() {
        backgroundColor = WHITE
        contentView.backgroundColor = WHITE
        selectionStyle = .none
        
        contentView.addSubview(frontCoverView)
        contentView.addSubview(lengthBackView)
        contentView.addSubview(lengthLabel)
        contentView.addSubview(typeBackView)
        contentView.addSubview(typeLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(watchView)
        contentView.addSubview(watchNumberLabel)
        contentView.addSubview(commentView)
        contentView.addSubview(commentNumberLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailsLabel)
        
        frontCoverView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(contentView)
            make.height.equalTo(ListCellHeight)
        }
        
        lengthBackView.snp.makeConstraints { (make) in
            make.leading.bottom.equalTo(frontCoverView)
            make.height.equalTo(27)
            make.width.equalTo(77)
        }
        lengthLabel.snp.makeConstraints { (make) in
            make.center.equalTo(lengthBackView)
        }
        typeBackView.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(15)
            make.top.equalTo(frontCoverView.snp.bottom).offset(30)
            make.height.equalTo(17)
            make.width.equalTo(36)
        }
        
        typeLabel.snp.makeConstraints { (make) in
            make.center.equalTo(typeBackView)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(typeBackView.snp.trailing).offset(7)
            make.centerY.equalTo(typeBackView)
        }
        
        commentNumberLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(contentView).offset(-15)
            make.centerY.equalTo(typeBackView)
        }
        commentView.snp.makeConstraints { (make) in
            make.trailing.equalTo(commentNumberLabel.snp.leading).offset(-7)
            make.centerY.equalTo(typeBackView)
        }
        
        watchNumberLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(commentView.snp.leading).offset(-15)
            make.centerY.equalTo(typeBackView)
        }
        watchView.snp.makeConstraints { (make) in
            make.trailing.equalTo(watchNumberLabel.snp.leading).offset(-7)
            make.centerY.equalTo(typeBackView)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView).offset(15)
            make.trailing.equalTo(contentView).offset(-15)
            make.top.equalTo(typeBackView.snp.bottom).offset(11)
            make.height.equalTo(18)
        }
        detailsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    private lazy var frontCoverView: UIImageView = {
        let frontCoverView = UIImageView()
        frontCoverView.contentMode = .scaleAspectFill
        frontCoverView.layer.masksToBounds = true
        return frontCoverView
    }()
    
    private lazy var lengthLabel = UILabel(text: "0′00″", textColor: WHITE, fontSize: 13)
    
    private lazy var lengthBackView: UIView = {
        let lengthBackView = UIView()
        lengthBackView.backgroundColor = RGB(r: 0x00, g: 0x00, b: 0x00, alpha: 1)
        return lengthBackView
    }()
    
    private lazy var typeLabel = UILabel(text: "Type", textColor: WHITE, fontSize: 13)
    
    private lazy var typeBackView: UIView = {
        let typeBackView = UIView()
        typeBackView.backgroundColor = BLUE
        return typeBackView
    }()
    
    private lazy var timeLabel = UILabel(text: "1970/01/01", textColor: GRAY_99, fontSize: 11)
    
    private lazy var watchView = UIImageView(image: UIImage(named: "list_watch"))
    
    private lazy var watchNumberLabel = UILabel(text: "0", textColor: GRAY_99, fontSize: 11)
    
    private lazy var commentView = UIImageView(image: UIImage(named: "list_comment"))
    
    private lazy var commentNumberLabel = UILabel(text: "0", textColor: GRAY_99, fontSize: 11)
    
    private lazy var titleLabel: UILabel = {
        let  titleLabel = UILabel(text: "Title", textColor: BLACK, fontSize: 16)
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        return titleLabel
    }()
    
    private lazy var detailsLabel: UILabel = {
        let detailsLabel = UILabel(text: "Details...", textColor: RGB(r: 0x33, g: 0x33, b: 0x33, alpha: 1), fontSize: 13)
        detailsLabel.numberOfLines = 0
        return detailsLabel
    }()
}
