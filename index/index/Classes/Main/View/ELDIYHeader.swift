//
//  ELDIYHeader.swift
//  index
//
//  Created by Soul on 6/6/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit
import MJRefresh

class ELDIYHeader: MJRefreshHeader {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(kaiguan)
        addSubview(logo)
        
    }
    
    lazy var kaiguan = UISwitch()
    lazy var logo = UIImageView(image: UIImage(named: "jiantou"))
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        logo.x = self.width * 0.25
        logo.centerY = self.height * 0.5
        backgroundColor = UIColor.orange
        
        kaiguan.centerX = self.width * 0.5
        kaiguan.centerY = self.height * 0.5
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var state: MJRefreshState {
        
        didSet {
            if state == .idle {// 下拉可以刷新
                UIView.animate(withDuration: 0.25) { 
                    self.kaiguan.transform = CGAffineTransform.identity
                }
                
            } else if state == .pulling {// 松开立即刷新
                self.kaiguan.setOn(true, animated: true)
                UIView.animate(withDuration: 0.25) { 
                    self.kaiguan.transform = CGAffineTransform(rotationAngle: .pi * 2)
                }
                
            } else if state == .refreshing {// 正在刷新
                UIView.animate(withDuration: 0.25) { 
                    self.kaiguan.transform = CGAffineTransform(rotationAngle: .pi * 2)
                }
                
            }
            
        }
        
    }
}
