//
//  TopicListCell.swift
//  index
//
//  Created by Soul on 22/6/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class TopicListCell: UICollectionViewCell {
    private let TopicListCellID = "cell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tabbleView)
    }
    
    var models : String? {
        didSet {
            guard models != nil else {
                return
            }
            
            tabbleView.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tabbleView: UITableView = {
        let tabbleView = UITableView()
        tabbleView.frame = bounds
        tabbleView.dataSource = self
        tabbleView.delegate = self
        tabbleView.register(tabTopicListCell.self, forCellReuseIdentifier: TopicListCellID)
        return tabbleView
    }()
    
}

extension TopicListCell : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TopicListCellID, for: indexPath)
//        cell.textLabel?.text = String(format: "%@ - %zd", self.models ?? "", indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    
}
