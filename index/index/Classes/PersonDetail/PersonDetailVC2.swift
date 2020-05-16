//
//  PersonDetailVC.swift
//  index
//
//  Created by Soul on 15/5/2020.
//  Copyright © 2020 Soul. All rights reserved.
//

import UIKit
import SnapKit

///有二级导航的时候别用这种 返回会导致主界面导航条bug
class PersonDetailVC2: UIViewController {
    let greenH: CGFloat = 44.0
    let oriHeight: CGFloat = 200.0
    
    let cellID = "PersonDetailVC"
    var heightConstraint:Constraint? //保存约束的属性
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        let label = UILabel()
        label.text = "个人详情页"
        label.sizeToFit()
        label.textColor = UIColor.init(white: 0, alpha: 0)
        navigationItem.titleView = label
    }
    
    lazy var conView :UIView = {
        let conView = UIView()
        conView.clipsToBounds = true
        return conView
    }()
    
    lazy var greenView :UIView = {
        let vc = UIView()
        vc.backgroundColor = .green
        return vc
    }()
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView(image: UIImage(named: "bg"))
        bgImageView.contentMode = .scaleAspectFill
        return bgImageView
    }()
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView(image: UIImage(named: "cat"))
        return iconImageView
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: oriHeight + greenH, left: 0, bottom: 0, right: 0)
        return tableView
    }()
      
    func setUI() {
        view.addSubview(tableView)
        view.addSubview(conView)
        view.addSubview(greenView)
        
        conView.addSubview(bgImageView)
        conView.addSubview(iconImageView)
        
        tableView.snp.makeConstraints {
            $0.top.right.left.bottom.equalToSuperview()
        }
        
        conView.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
            heightConstraint = $0.height.equalTo(oriHeight).constraint //保存约束
        }
        greenView.snp.makeConstraints {
            $0.top.equalTo(conView.snp.bottom)
            $0.right.left.equalToSuperview()
            $0.height.equalTo(greenH)
        }
        
        bgImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.center.equalToSuperview()
        }
        
    }
    
}


extension PersonDetailVC2: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = "---> \(indexPath.row)"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let oriOfftY = -(greenH + oriHeight)
        
        let offset = scrollView.contentOffset.y - oriOfftY
        
        var h = oriHeight - offset
        if h < navigationHeight {
            h = navigationHeight
        }
        self.heightConstraint?.update(offset: h)
        
        var alpha = offset * 1 / (oriHeight - navigationHeight)
        if alpha >= 1 {
            alpha = 0.99
        }
        
        let titleL = navigationItem.titleView as? UILabel
        titleL?.textColor = UIColor.init(white: 0, alpha: alpha)
        
        let alphaColor = UIColor.init(white: 1, alpha: alpha)
        //把颜色生成图片
        let alphaImage = UIImage.colorImage(color: alphaColor)
        navigationController?.navigationBar.setBackgroundImage(alphaImage, for: .default)
        
    }
    
}
