



//
//  ELRecommendVC.swift
//  index
//
//  Created by Soul on 2/6/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit
import MJRefresh
import HandyJSON
import SVProgressHUD

class ELRecommendVC: UIViewController {
    //懒加载数组
    private lazy var categories = [ELRecommendCategoryM]()
    
    // 字典泛型写法  || lazy var paramsss  = [String:Any]()
    private var params : Dictionary<String, Any> = [:]
    
    var model : ELRecommendCategoryM1? = nil
    
    private let categoryID = "category"
    private let userID = "user"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "推荐关注"
        view.backgroundColor = UIColor.white
        setUI()
        setupRefresh()
        loadCategories()
    }
    
    deinit {
        printLog("销毁了")
    }
    
    func loadCategories() {
        SVProgressHUD.setDefaultMaskType(.black)
        
        let paramenters = ["a":"category",
                           "c":"subscribe"]
        NetworkTools.shareInstance.getRequest(param: paramenters, successBlock: { (json) in
            SVProgressHUD.dismiss()
            
            if let mappedObject = JSONDeserializer<ELRecommendCategoryM>.deserializeModelArrayFrom(json: json["list"].description) {
                self.categories = (mappedObject as? [ELRecommendCategoryM])!
                self.categoryTableV.reloadData()
                self.categoryTableV.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableView.ScrollPosition.top)
                self.userTableV.mj_header.beginRefreshing()
            }
            
        }) { (error) in
            SVProgressHUD.showError(withStatus: "加载推荐信息失败!")
        }
        
//        ELNetTools.share.GET(url: ConstAPI.ELCommonURL, params: paramenters, success: { (json) in
//            self.model = try! JSONDecoder().decode(ELRecommendCategoryM1.self, from: json)
//            self.categoryTableV.reloadData()
//            self.categoryTableV.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UITableView.ScrollPosition.top)
////            self.userTableV.mj_header.beginRefreshing()
//            
//        }) { (_, _) in
//            SVProgressHUD.showError(withStatus: "加载推荐信息失败!")
//        }
        
        
    }
    
    
    func setupRefresh() {
        userTableV.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewUsers))
        userTableV.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreUsers))
        userTableV.mj_header.isAutomaticallyChangeAlpha = true
        userTableV.mj_footer.isHidden = true
    }
    
    @objc func loadNewUsers() {
        loadMoreUserss(true)
    }
    
    @objc func loadMoreUsers() {
        loadMoreUserss(false)
    }
    
    func loadMoreUserss(_ isNewData: Bool) {
        if isNewData {
            userTableV.mj_footer.endRefreshing()
        } else {
            userTableV.mj_header.endRefreshing()
        }
        
        var open = categories[(self.categoryTableV.indexPathForSelectedRow?.row)!]
        
        if isNewData {
            open.currentPage = 1
        } else {
            open.currentPage += 1
        }
        
        let paramenters = ["a":"list",
                           "c":"subscribe",
                           "category_id":"\(open.id ?? 0)",
            "page":"\(open.currentPage)"
            ] as [String: Any]
        
        params = paramenters
        categories[categoryTableV.indexPathForSelectedRow?.row ?? 0].currentPage = open.currentPage
        NetworkTools.shareInstance.getRequest(param: paramenters, successBlock: { (json) in
            
            if let mappedObject = JSONDeserializer<ELRecommendUserM>.deserializeModelArrayFrom(json: json["list"].description) as? [ELRecommendUserM] {
                
                if isNewData {
                    self.categories[(self.categoryTableV.indexPathForSelectedRow?.row)!].users = mappedObject
                    self.categories[(self.categoryTableV.indexPathForSelectedRow?.row)!].total = json["total"].intValue
                    
                    if !NSDictionary(dictionary: self.params).isEqual(to: paramenters) {
                        return
                    }
                    self.userTableV.mj_header.endRefreshing()
                    
                } else {
                    
                    self.categories[(self.categoryTableV.indexPathForSelectedRow?.row)!].users += mappedObject
                    
                }
                
                if !NSDictionary(dictionary: self.params).isEqual(to: paramenters) {
                    return
                }
                self.userTableV.reloadData()
                self.checkFooterState()
                
            }
        }) { (error) in
            if isNewData {
                SVProgressHUD.showError(withStatus: "加载推荐信息失败!")
                self.userTableV.mj_header.endRefreshing()
            } else {
                if !NSDictionary(dictionary: self.params).isEqual(to: paramenters) {
                    return
                }
                self.categories[(self.categoryTableV.indexPathForSelectedRow?.row)!].currentPage -= 1
                SVProgressHUD.showError(withStatus: "加载更多用户数据失败")
                self.userTableV.mj_footer.endRefreshing()
            }
            
        }
    }
    
    func checkFooterState() {
        let open = categories[(categoryTableV.indexPathForSelectedRow?.row)!]
        userTableV.mj_footer.isHidden = (open.count == 0) //没有数据的时候隐藏上拉
        if open.users.count == open.total {
            userTableV.mj_footer.endRefreshingWithNoMoreData()
        } else {
            userTableV.mj_footer.endRefreshing()
        }
    }
    
    func setUI() {
        view.addSubview(categoryTableV)
        view.addSubview(userTableV)
        
        categoryTableV.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalToSuperview()
            make.width.equalTo(90)
        }
        
        userTableV.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.right.trailing.equalToSuperview()
            make.left.equalTo(categoryTableV.snp.right)
        }
        
    }
    
    lazy var categoryTableV :  UITableView = {
        let categoryTableV = UITableView()
        categoryTableV.rowHeight = 50
        categoryTableV.separatorStyle = .none
        categoryTableV.delegate = self
        categoryTableV.dataSource = self
        categoryTableV.register(ELRecommendCategoryCell.self, forCellReuseIdentifier: categoryID)
        
        if #available(iOS 11.0, *) {
            categoryTableV.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        return categoryTableV
    }()
    
    lazy var userTableV : UITableView = {
        let userTableV = UITableView()
        userTableV.rowHeight = 70
        userTableV.delegate = self
        userTableV.dataSource = self
        userTableV.register(ELRecommendUserCell.self, forCellReuseIdentifier: userID)
        
        if #available(iOS 11.0, *) {
            userTableV.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        return userTableV
    }()
}

extension ELRecommendVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == categoryTableV {
            return categories.count
        } else {
            guard let row = categoryTableV.indexPathForSelectedRow?.row else {
                return 0
            }
            return categories[row].users.count 
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == categoryTableV {
            let cell = tableView.dequeueReusableCell(withIdentifier: categoryID, for: indexPath) as! ELRecommendCategoryCell
            cell.category = categories[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: userID, for: indexPath) as! ELRecommendUserCell
            let row = categoryTableV.indexPathForSelectedRow?.row
            
            cell.user = categories[row ?? 0].users[indexPath.row]
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == categoryTableV {
            userTableV.mj_header.endRefreshing()
            userTableV.mj_footer.endRefreshing()
            let open = categories[indexPath.row]
            if open.users.count > 0 {
                self.userTableV.reloadData()
            } else {
                userTableV.reloadData()
                userTableV.mj_header.beginRefreshing()
            }
        }
    }
    
    
    
}
