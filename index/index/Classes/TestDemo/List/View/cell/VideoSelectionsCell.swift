//
//  VideoSelectionsCell.swift
//  VideoPlayer
//
//  Created by Soul on 20/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class VideoSelectionsCell: UITableViewCell {

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
        
        contentView.addSubview(selectionsLabel)
        contentView.addSubview(numberLabel)
        contentView.addSubview(collectionView)
        
        selectionsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(15)
            make.left.equalTo(contentView).offset(15)
            make.height.equalTo(15)
        }
        
        numberLabel.snp.makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-15)
            make.centerY.equalTo(selectionsLabel)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(selectionsLabel.snp.bottom).offset(10)
            make.left.right.equalTo(contentView)
            make.height.equalTo(60)
        }
        
    }

    
    
    // MARK: - Lazy load
    
    private lazy var selectionsLabel = UILabel(text: "选集", textColor: BLUE, fontSize: 13)
    
    private lazy var numberLabel = UILabel(text: "共18集", textColor: GRAY_99, fontSize: 11)
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 60, height: 60)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = WHITE
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.scrollsToTop = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(VideoSelectionsItem.self, forCellWithReuseIdentifier: "SelectionsItem")
        return collectionView
    }()
    
}

extension VideoSelectionsCell : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectionsItem", for: indexPath) as! VideoSelectionsItem
        cell.index = indexPath.item + 1
        return cell
    }
    
    
    
    
}


// MARK: - SelectionsItem

class VideoSelectionsItem: UICollectionViewCell {
    
    var index: Int = 0 {
        didSet {
            titleLabel.text = "\(index)"
        }
    }
    
    var _selected: Bool = false
    
    override var isSelected: Bool {
        set {
            _selected = newValue
            if _selected == true {
                titleLabel.textColor = RGB(r: 0xf1, g: 0xf1, b: 0xf9, alpha: 1)
                backView.backgroundColor = RGB(r: 0x32, g: 0x31, b: 0x36, alpha: 1)
            } else {
                titleLabel.textColor = RGB(r: 0x32, g: 0x31, b: 0x36, alpha: 1)
                backView.backgroundColor =  RGB(r: 0xf1, g: 0xf1, b: 0xf9, alpha: 1)
            }
            
        }
        
        get {
            return _selected
        }
    }
    
    
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
        
        contentView.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalTo(contentView)
        }
    }
    
    // MARK: - Lazy load
    
    private lazy var titleLabel = UILabel(text: "0", textColor: RGB(r: 0x32, g: 0x31, b: 0x36, alpha: 1), fontSize: 13)
    
    private lazy var backView: UIView = {
        let backView = UIView()
        backView.backgroundColor = RGB(r: 0xf1, g: 0xf1, b: 0xf9, alpha: 1)
        backView.layer.cornerRadius = 30
        return backView
    }()
    
}
