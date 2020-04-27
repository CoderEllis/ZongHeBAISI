

//
//  ELSubTagViewController.swift
//  index
//
//  Created by Soul on 26/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON

class ELSubTagViewController: UITableViewController {
    private let ELSubTagCellID = "cell"
    
    lazy var viewModel = ELSubTagViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(ELSubTagCell.self, forCellReuseIdentifier: ELSubTagCellID)
//        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        title = "推荐标签"
        tableView.backgroundColor = UIColor.gray
        
        setupLoadData()
    }
    
    func setupLoadData() {
        viewModel.updateDataBlock = { [unowned self] in
            self.tableView.reloadData()
        }
        viewModel.refreshDataSource()
    }
    
    

   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.subTagModel?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ELSubTagCellID) as! ELSubTagCell
        cell.elsubTagModel = viewModel.subTagModel?[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
