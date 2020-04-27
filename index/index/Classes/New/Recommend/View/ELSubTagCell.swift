//
//  ELSubTagCell.swift
//  index
//
//  Created by Soul on 26/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit
import SnapKit


class ELSubTagCell: UITableViewCell {
    var elsubTagModel: ELSubTagModel? {
        didSet {
            guard let model = elsubTagModel else {return}
            nameView.text = model.theme_name
            resolveNum(number: model.sub_number!)
            iocmView.setHeader(headerUrl: model.image_list!)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    //cell间距
    override var frame: CGRect {
        didSet {
            var newFrame = frame
            newFrame.size.height -= 1
            super.frame = newFrame
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    
    func resolveNum(number: Int) {
        var numStr : String?
        
        if number > 10000 {
            numStr = String(format: "%zd万人订阅", number / 10000)
        } else {
            numStr = String(format: "%zd人订阅", number)
        }
        numView.text = numStr
    }
    
    
    
    
    
    func setUI() {
        addSubview(iocmView)
        addSubview(nameView)
        addSubview(numView)
        addSubview(subscribe)
        
        iocmView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        nameView.snp.makeConstraints { (make) in
            make.top.equalTo(iocmView)
            make.left.equalTo(iocmView.snp.right).offset(10)
        }
        
        numView.snp.makeConstraints { (make) in
            make.leading.equalTo(nameView)
            make.bottom.equalTo(iocmView)
        }
        
        subscribe.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
        }
    }
    
    lazy var iocmView = UIImageView()
    
    lazy var nameView : UILabel = {
        let nameView = UILabel()
        nameView.font = UIFont.systemFont(ofSize: 17)
        nameView.text = "2222222"
        return nameView
    }()
    
    lazy var numView : UILabel = {
        let numView = UILabel()
        numView.font = UIFont.systemFont(ofSize: 13)
        numView.textColor = UIColor.magenta
        numView.text = "11111111"
        return numView
    }()
    
    lazy var subscribe : UIButton = {
        let subscribe = UIButton(type: .custom)
        subscribe.setTitle("+ 订阅", for: .normal)
        subscribe.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        subscribe.setTitleColor(UIColor.red, for: UIControl.State.normal)
        //设置边框
        subscribe.layer.borderColor = UIColor.purple.cgColor
        subscribe.layer.borderWidth = 1.5
        subscribe.setBackgroundImage(UIImage(named: "tagButtonBG"), for: .normal)
        subscribe.sizeToFit()
        return subscribe
    }()
    
   
    
}
