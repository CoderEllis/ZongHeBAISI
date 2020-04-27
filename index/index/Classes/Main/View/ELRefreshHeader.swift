//
//  ELRefreshHeader.swift
//  index
//
//  Created by Soul on 6/6/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit
import MJRefresh

class ELRefreshHeader: MJRefreshNormalHeader {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stateLabel.textColor = UIColor.magenta
        stateLabel.font = UIFont.systemFont(ofSize: 17)
        setTitle("下拉刷新~~", for: MJRefreshState.idle)
        setTitle("松开🐴上刷新", for: MJRefreshState.pulling)
        setTitle("稍等会儿...正在刷新", for: MJRefreshState.refreshing)
        backgroundColor = UIColor.white
        // 隐藏时间
        lastUpdatedTimeLabel.isHidden = false
        // 自动切换透明度
        isAutomaticallyChangeAlpha = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
