//
//  ELNewViewController.swift
//  index
//
//  Created by Soul on 25/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELNewViewController: UIViewController {
    private let TopicListCellId = "TopicListCell"
    
    var titleUnderline : UIView!
    
    ///上一次点击的标题按钮
    var previousClickedTitleButton : UIButton!
    
    /// titleView滑动
    public var isTitleViewScrollEnabled: Bool = true
    
    var modules = ["政治", "社会", "体育", "娱乐",
                   "政治2", "社会2", "体育2", "娱乐2",
                    "政治3", "社会3", "体育3", "娱乐3"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        setupNavBar()
        view.addSubview(pageScrollView)
        view.addSubview(collectionView)
        setupTitleButtons()
        setupTitleUnderline()
    }
    
    fileprivate func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(itemWithimage: "MainTagSubIcon", highImage: "MainTagSubIconClick", target: self, ation:  #selector(tagClick))
        navigationItem.title = "新帖"
    }
    
    @objc fileprivate func tagClick() {
        let subTag = ELSubTagViewController()
        navigationController?.pushViewController(subTag, animated: true)
    }
    
    
    //标题栏按钮
    private func setupTitleButtons() {
        let count = modules.count
        var x :CGFloat = 0
        var titleButtonW :CGFloat = 0
        let titleButtonH :CGFloat = pageScrollView.height
        for i in 0..<count {
            let titleButton = ELTitleButton()
            titleButton.tag = i
            
            titleButton.addTarget(self, action: #selector(titleButtonClick(_:)), for: UIControl.Event.touchUpInside)
            titleButton.setTitle(modules[i], for: UIControl.State.normal)
            
            
            if isTitleViewScrollEnabled {
//                titleButtonW = (modules[i] as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0), options: .usesFontLeading, attributes: [NSAttributedString.Key.font : titleButton.titleLabel?.font as Any], context: nil).width + ELTitleViewH
                titleButtonW = view.bounds.width / 5
                x = CGFloat(i) * titleButtonW
                pageScrollView.contentSize.width += titleButtonW
            } else {
                titleButtonW = view.bounds.width / CGFloat(count)
                x = CGFloat(i) * titleButtonW
            }
            
            titleButton.frame = CGRect(x: x, y: 0, width: titleButtonW, height: titleButtonH)
            pageScrollView.addSubview(titleButton)
        }
        
    }
    
    //点击标题按钮
    @objc func titleButtonClick(_ titleButton: ELTitleButton) {
        
        if previousClickedTitleButton == titleButton {
            printLog("重复点击")
        }
        dealtitleButtonClick(titleButton: titleButton)
        
    }
    
    ///处理标题按钮点击
    private func dealtitleButtonClick(titleButton: ELTitleButton) {
        previousClickedTitleButton.isSelected = false
        titleButton.isSelected = true
        
        previousClickedTitleButton = titleButton
        let index = titleButton.tag
        adjustLabelPosition(titleButton)
        UIView.animate(withDuration: 0.25, animations: { 
            self.titleUnderline.width = (titleButton.titleLabel?.width)! + ELMarin
            self.titleUnderline.centerX = titleButton.centerX
//            let offsetX = self.collectionView.width * CGFloat(index)
//            self.collectionView.contentOffset = CGPoint(x: offsetX, y: self.collectionView.contentOffset.y)
            
            let indexPath = IndexPath(item: index, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }) { (_) in
            
            
        }
    }
    
    private func adjustLabelPosition(_ targetLabel : ELTitleButton) {
        
        var offsetX = targetLabel.center.x - view.bounds.width * 0.5
        
        if offsetX < 0 {
            offsetX = 0
        }
        if offsetX > pageScrollView.contentSize.width - pageScrollView.bounds.width {
            offsetX = pageScrollView.contentSize.width - pageScrollView.bounds.width
        }
        
        pageScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        
    }
    
    lazy var conView = UIView()
    
    lazy var pageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 88, width: view.width, height: ELTitleViewH)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    
    // 标题下划线
    private func setupTitleUnderline() {
        guard let firstTitleButton = pageScrollView.subviews.first as? ELTitleButton else {
            return
        }
        let titleUnderline = UIView()
        titleUnderline.height = 2
        titleUnderline.y = pageScrollView.height - titleUnderline.height
        titleUnderline.backgroundColor = firstTitleButton.titleColor(for: UIControl.State.selected)
        pageScrollView.addSubview(titleUnderline)
        self.titleUnderline = titleUnderline
        
        //进来就显示下划线和选中第一个
        firstTitleButton.isSelected = true
        previousClickedTitleButton = firstTitleButton
        firstTitleButton.titleLabel?.sizeToFit() // 让label根据文字内容计算尺寸
        self.titleUnderline.width = firstTitleButton.titleLabel!.width
        self.titleUnderline.centerX = firstTitleButton.centerX
        
    }
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = view.bounds.size
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.frame = CGRect(x: 0, y: 88 + ELTitleViewH, width: view.bounds.width, height: view.bounds.height)
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.red
        // 不允许自动修改UIScrollView的内边距
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        collectionView.register(TopicListCell.self, forCellWithReuseIdentifier: TopicListCellId)
        return collectionView
    }()
}


extension ELNewViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicListCellId, for: indexPath) as! TopicListCell
        cell.models = modules[indexPath.item]
        return cell
    }
    
    //UICollectionViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        printLog("\(Int(scrollView.contentOffset.x / scrollView.frame.width))")
        
        let index : Int = Int(scrollView.contentOffset.x / scrollView.width)
        let titleButton = pageScrollView.subviews[index] as! ELTitleButton
        dealtitleButtonClick(titleButton: titleButton)
        
    }
    
    
}
