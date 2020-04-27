//
//  CollVC.swift
//  allClick
//
//  Created by Soul on 7/7/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class CollVC: UIView {
    let reuseIdentifierID = "cell"
    
    lazy var selectArray = Array<ELTopic>()
    
    var dataArray : [ELTopic]? {
        didSet {
            guard dataArray != nil else {
                return
            }
            collectionView.reloadData()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerVC.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.center.equalToSuperview()
        }
        
        allClick.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(10)
            make.width.equalTo(30)
            make.height.equalTo(40)
        }
        
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15)
            make.size.equalTo(CGSize(width: 100, height: 20))
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(allClick.snp.bottom).offset(15)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(containerVC.snp.width)
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 200, height: 20))
        }
        
        bottomBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(40)
            make.top.equalTo(pageControl.snp.bottom).offset(15)
        }
        
        cancel.snp.makeConstraints { (make) in
            make.top.equalTo(containerVC.snp.bottom).offset(10)
            make.centerX.equalTo(containerVC)
        }
    }
    
    private func setUI() {
        addSubview(containerVC)
        containerVC.backgroundColor = UIColor.white
        containerVC.layer.cornerRadius = 15
        containerVC.layer.masksToBounds = true
        
        containerVC.addSubview(allClick)
        containerVC.addSubview(label)
        containerVC.addSubview(collectionView)
        containerVC.addSubview(pageControl)
        containerVC.addSubview(bottomBtn)
        addSubview(cancel)
    }
    
    lazy var containerVC = UIView()
    
    lazy var allClick: allBtn = {
        let allClick = allBtn()
        allClick.setTitle("全选", for: .normal)
        allClick.setTitleColor(UIColor.black, for: .normal)
        allClick.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        allClick.setImage(UIImage(named: "btn_allchoice_n"), for: .normal)
        allClick.setImage(UIImage(named: "btn_allchoice_s"), for: .selected)
        allClick.addTarget(self, action: #selector(allChoose(_:)), for: .touchUpInside)
        return allClick
    }()
    
    @objc func allChoose(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            
            guard let dataArray = self.dataArray else {return}
            selectArray = dataArray
            
            print("全选-----\(selectArray.count)")
        } else {
            print("全部取消")
            selectArray.removeAll()
        }
        collectionView.reloadData()
    }
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "附近用户"
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let itemWH = (ScreenWidth - 20) / 3
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = true
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifierID)
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.gray
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPage = 0
        pageControl.hidesForSinglePage = true //单页隐藏
        return pageControl
    }()
    
    lazy var bottomBtn: UIButton = {
        let bottomBtn = UIButton()
        bottomBtn.backgroundColor = UIColor.green
        bottomBtn.setTitle("建群 (花费豆豆241个)", for: .normal)
        bottomBtn.setTitleColor(UIColor.white, for: .normal)
        bottomBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        bottomBtn.addTarget(self, action: #selector(newQun), for: .touchUpInside)
        return bottomBtn
    }()
    
    @objc func newQun() {
        print("建群")
    }
    
    lazy var cancel: UIButton = {
        let cancel = UIButton()
//        cancel.setImage(UIImage(named: "btn_allchoice_s"), for: .normal)
        cancel.setTitle("✘", for: .normal)
        cancel.setTitleColor(UIColor.white, for: .normal)
        cancel.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        cancel.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        return cancel
    }()
    
    @objc func cancelClick() {
        print("取消")
        self.removeFromSuperview()
    }
    
    deinit {
        print("View销毁")
    }
}


extension CollVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = dataArray?.count ?? 0
        let page = count / 10 + 1
        pageControl.numberOfPages = page
        return page * 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierID, for: indexPath) as! PhotoCell
        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.gray : UIColor.green
        cell.isHidden = false
        let row = indexPath.row    // 一维数组的位置
        let page = row / 9         //  页数
        let i = row % 9            // 9宫格里 格数
        let x = i / 3              //9宫格里 行数
        let y = i % 3              //9宫格里 列数
        let index = (x + y * 3) + (page * 9)
        
        if index >= dataArray?.count ?? 0 {
            cell.isHidden = true
            return cell
        }
        let item = dataArray?[index]
        
        if item != nil {
            cell.items = item
            cell.isSelect = selectArray.contains(item!)
        }
        
//        cell.items = dataArray?[indexPath.row]
        
        cell.didCheckBlock { [weak self] (model) in
            
            guard let `self` = self else { return }
            
            if self.selectArray.contains(model) {
                
                self.selectArray.removeAll(where: { $0 == model })
                print("----删除1个-----共选中\(self.selectArray.count)个")
                print(self.selectArray)
            } else {
                
                self.selectArray.append(model)
                print("----添加1个-----共选中\(String(describing: self.selectArray.count))个")
            }
            self.selectNotAll()
            self.collectionView.reloadData()
        }
        
        return cell
    }
    
    func selectNotAll() {
        allClick.isSelected = selectArray.count == dataArray?.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width + 0.5
        pageControl.currentPage = Int(page) //当前页
    }
    
}
