//
//  ELTagBtn.swift
//  index
//
//  Created by Soul on 18/6/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELTagBtn: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        setImage(UIImage(named: "chose_tag_close_icon"), for: UIControl.State.normal)
        layer.masksToBounds = true
        layer.cornerRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRect(x: 0, y: 0, width: imageView?.frame.size.width ?? 0, height: imageView?.frame.size.height ?? 0)
        titleLabel?.frame = CGRect(x: 0, y: imageView?.frame.size.height ?? 0 + ELMarin, width: imageView?.frame.size.width ?? 0, height: 20)
    }
    
}
