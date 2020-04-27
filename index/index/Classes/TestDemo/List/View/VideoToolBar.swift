//
//  VideoToolBar.swift
//  VideoPlayer
//
//  Created by Soul on 20/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class VideoToolBar: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func setUI() {
        backgroundColor = WHITE
        addSubview(likeBtn)
        addSubview(commentBtn)
        addSubview(shareBtn)
        addSubview(reportBtn)
        
        likeBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        commentBtn.snp.makeConstraints { (make) in
            make.left.equalTo(likeBtn.snp.right).offset(5)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        shareBtn.snp.makeConstraints { (make) in
            make.left.equalTo(commentBtn.snp.right).offset(5)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        reportBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-5)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        let lineView = UIView()
        addSubview(lineView)
        lineView.backgroundColor = BACKGROUND_COLOR
        lineView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }

    
    // MARK: - Action
    
    @objc private func clickLikeBtn() {
        
    }
    
    @objc private func clickCommentBtn() {
        
    }
    
    @objc private func clickShareBtn() {
        
    }
    
    @objc private func clickReportBtn() {
        
    }
    
    
    lazy var likeBtn : UIButton = {
       let  likeBtn = UIButton()
        likeBtn.setImage(UIImage(named: "video_like"), for: .normal)
        likeBtn.addTarget(self, action: #selector(clickLikeBtn), for: .touchUpInside)
        return likeBtn
    }()
    
    lazy var commentBtn : UIButton = {
        let  commentBtn = UIButton()
        commentBtn.setImage(UIImage(named: "video_comment1"), for: .normal)
        commentBtn.addTarget(self, action: #selector(clickCommentBtn), for: .touchUpInside)
        return commentBtn
    }()
    
    lazy var shareBtn : UIButton = {
        let  shareBtn = UIButton()
        shareBtn.setImage(UIImage(named: "video_share"), for: .normal)
        shareBtn.addTarget(self, action: #selector(clickShareBtn), for: .touchUpInside)
        return shareBtn
    }()
    
    lazy var reportBtn : UIButton = {
        let  reportBtn = UIButton()
        reportBtn.setImage(UIImage(named: "video_report"), for: .normal)
        reportBtn.addTarget(self, action: #selector(clickReportBtn), for: .touchUpInside)
        return reportBtn
    }()
    
}
