//
//  VideoRecommendMediaCell.swift
//  VideoPlayer
//
//  Created by Soul on 20/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

let recommendMediaWidth = (ScreenWidth-30-5)*0.5
let recommendMediaHeight = recommendMediaWidth*(750/1334)

class VideoRecommendMediaCell: UITableViewCell {

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
            make.top.leading.trailing.equalTo(contentView)
            make.height.equalTo(5)
        }
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(15)
            make.leading.equalTo(contentView).offset(15)
            make.height.equalTo(15)
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.bottom.trailing.equalTo(contentView)
        }
    }
    
    // MARK: - Lazy Load
    
    private lazy var titleLabel = UILabel(text: "精彩片段", textColor: BLUE, fontSize: 13)
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: recommendMediaWidth, height: recommendMediaHeight+39.5)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = WHITE
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(VideoRecommendMediaItem.self, forCellWithReuseIdentifier: "RecommendMediaItem")
        return collectionView
    }()
    
    
}


extension VideoRecommendMediaCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendMediaItem", for: indexPath) as! VideoRecommendMediaItem
        return cell
    }
    
    
}








// MARK: - VideoRecommendMediaItem
class VideoRecommendMediaItem: UICollectionViewCell {
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set up
    
    private func setupUI() {
        backgroundColor = WHITE
        contentView.backgroundColor = WHITE
        
        contentView.addSubview(mediaFrontView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(timeBackView)
        contentView.addSubview(timeLabel)
        
        mediaFrontView.snp.makeConstraints { (make) in
            make.top.left.trailing.equalTo(contentView)
            make.height.equalTo(recommendMediaHeight)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(mediaFrontView.snp.bottom).offset(10)
            make.height.equalTo(15)
        }
        
        timeBackView.snp.makeConstraints { (make) in
            make.trailing.bottom.equalTo(mediaFrontView)
            make.width.equalTo(34)
            make.height.equalTo(18)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.center.equalTo(timeBackView)
        }
    }
    
    // MARK: - Lazy Load
    
    private lazy var mediaFrontView: UIImageView = {
        let mediaFrontView = UIImageView()
        mediaFrontView.contentMode = .scaleAspectFill
        mediaFrontView.image = UIImage(named: "seven")
        return mediaFrontView
    }()
    
    private lazy var titleLabel = UILabel(text: "Title", textColor: BLACK, fontSize: 13)
    
    private lazy var timeBackView: UIView = {
        let timeBackView = UIView()
        timeBackView.backgroundColor = RGB(r: 0x00, g: 0x00, b: 0x00, alpha: 0.7)
        return timeBackView
    }()
    
    private lazy var timeLabel = UILabel(text: "00:00", textColor: WHITE, fontSize: 10)
}
