//
//  ELMeViewController.swift
//  index
//
//  Created by Soul on 28/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit
import SwiftyJSON

private  let cols : Int = 4
private  let margin : CGFloat = 1
private  let ithemH = (ScreenWidth - (CGFloat(cols) - 1) * margin) / CGFloat(cols)
class ELMeViewController: UITableViewController {
    private let ELSquareCellID = "cell"
    private lazy var model = [ELSquareItem]()
    
    
    lazy var modelVM = ELSquareModelVM()    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupFootView()
        
        tableView.sectionHeaderHeight = 0
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        
        loadDate()
        //接受通知
        NotificationCenter.default.addObserver(self, selector: #selector(tabBarButtonDidRepeatClick), name: NSNotification.Name(rawValue: ELTabBarButtonDidRepeatClickNotification), object: nil)
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupNavBar() {
        let settingItem = UIBarButtonItem(itemWithimage: "mine-setting-icon", highImage: "mine-setting-icon-click", target: self, ation: #selector(setting))
        let nightItem = UIBarButtonItem(itemWithimage: "mine-moon-icon", selected: "mine-moon-icon-click", target: self, ation: #selector(night(_:)))
        navigationItem.rightBarButtonItems = [settingItem, nightItem]
        navigationItem.title = "我的"
    }
    
    @objc func setting() {
        let setting = ELSettingViewController()
        navigationController?.pushViewController(setting, animated: true)
        
    }
    
    @objc func night(_ night: UIButton) {
        night.isSelected = !night.isSelected
    } 
    
    //监听tabBarButton重复点击
    @objc func tabBarButtonDidRepeatClick() {
        if view.window == nil {return}
        printLog("重复点击")
    }
    
    //选中的静态 cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        print(cell?.frame as Any)
    }
    
    func setupFootView() {
        tableView.tableFooterView = collectionView
    }
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: ithemH, height: ithemH)
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 300), collectionViewLayout: layout)
        
        collectionView.backgroundColor = tableView.backgroundColor
        tableView.tableFooterView = collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isScrollEnabled = false
        collectionView.register(ELSquareCell.self, forCellWithReuseIdentifier: ELSquareCellID)
        
        return collectionView
    }()
   
    
    func loadDate() {
//        let parameters = [
//                          "a":"square",
//                          "c":"topic"]
//        NetworkTools.shareInstance.getRequest(param: parameters, successBlock: { (json) in
//            
//            var tempViewModel = [ELSquareItem]() //Array<ELSquareItem>
//           
//            if var data = json["square_list"].arrayObject {
//                
//                data.removeLast()
//                guard let sss = data as? [[String :Any]] else {
//                    return
//                }
//                for dic in sss {
//                    let model = ELSquareItem(dic)
//                    tempViewModel.append(model)
//                }
//            }
//            self.model = tempViewModel
//            self.resloveData()
//            let count = self.model.count
//            let rows = (count - 1) / cols + 1
//            self.collectionView.height = CGFloat(rows) * ithemH + CGFloat(rows) * margin
//            self.tableView.tableFooterView = self.collectionView
//            
//            self.collectionView.reloadData()
//            
//        }) { (error) in
//            printLog(error)
//        }
        modelVM.updateDataBlock =  { [weak self] in
            let count = self?.modelVM.square_list?.count
            let rows = (count! - 1) / cols + 1
            self?.collectionView.height = CGFloat(rows) * ithemH + CGFloat(rows) * margin
            self?.tableView.tableFooterView = self?.collectionView
            
            self?.collectionView.reloadData()
            
        }
        modelVM.squareRequestData(nil)
        
    }
    
    func resloveData() {
        // 判断下缺几个
        // 3 % 4 = 3 cols - 3 = 1
        // 5 % 4 = 1 cols - 1 = 3
        let count = model.count
        var exter = count % cols
        if exter != 0 {
            exter = cols - exter
            for _ in 0..<exter {
                let item = ELSquareItem([:])
                model.append(item)
            }
        }
    }
    
}


extension ELMeViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    //UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let item = model[indexPath.row]
//        if !(item.url?.contains("http"))! {
//            return
//        }
//        let webView = ELWebViewController()
//        webView.url = URL(string: item.url!)
//        navigationController?.pushViewController(webView, animated: true)
        
        let item = modelVM.square_list?[indexPath.row]
        if !(item?.url.contains("http"))! {
            return
        }
        let webView = ELWebViewController()
        webView.url = URL(string: (item?.url)!)
        navigationController?.pushViewController(webView, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return model.count
        return modelVM.square_list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ELSquareCellID, for: indexPath) as! ELSquareCell
//        cell.model = model[indexPath.row]
        cell.modelVM = modelVM.square_list?[indexPath.row]
        return cell
    }
    
    
}
