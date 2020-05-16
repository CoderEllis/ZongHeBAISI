//
//  PersonDetailVC.swift
//  index
//
//  Created by Soul on 15/5/2020.
//  Copyright © 2020 Soul. All rights reserved.
//

import UIKit
import SnapKit


class PersonDetailVC: UIViewController {
    let greenH: CGFloat = 44.0
    let oriHeight: CGFloat = 200.0
    
    let cellID = "PersonDetailVC"
    var heightConstraint:Constraint? //保存约束的属性
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
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
    
    let navigation: UIView = {
        let navigation = UIView()
        navigation.backgroundColor = UIColor.white
        navigation.alpha = 0
        return navigation
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "个人详情页"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.sizeToFit()
        return label
    }()
    
    let backBtn: UIButton = {
        let backBtn = UIButton()
        backBtn.setTitle("返回", for: .normal)
        backBtn.titleLabel?.textColor = UIColor.black
        backBtn.setTitleColor(UIColor.black, for: .normal)
        backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return backBtn
    }()
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    func setUI() {
        view.addSubview(tableView)
        view.addSubview(conView)
        view.addSubview(greenView)
        
        view.addSubview(navigation)
        navigation.addSubview(label)
        navigation.addSubview(backBtn)
        
        conView.addSubview(bgImageView)
        conView.addSubview(iconImageView)
        
        tableView.snp.makeConstraints {
            $0.top.right.left.bottom.equalToSuperview()
        }
        
        navigation.snp.makeConstraints {
            $0.top.right.left.equalToSuperview()
            $0.height.equalTo(navigationHeight)
        }
        
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        backBtn.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.centerY.equalTo(label)
            $0.size.equalTo(CGSize(width: 40, height: 30))
            $0.trailing.greaterThanOrEqualTo(label.snp.leading)
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


extension PersonDetailVC: UITableViewDelegate, UITableViewDataSource {
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
        navigation.alpha = alpha
    }
    
}
