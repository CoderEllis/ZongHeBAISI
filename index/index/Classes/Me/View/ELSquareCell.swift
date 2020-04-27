//
//  ELSquareCell.swift
//  index
//
//  Created by Soul on 28/5/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELSquareCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var model : ELSquareItem? {
        didSet{
            guard let model = model else {
                return
            }
            label.text = model.name 
            imageView.setHeader(headerUrl: model.icon ?? "")
        }
    }
    
    var modelVM : Square? {
        didSet{
            guard let model = modelVM else {
                return
            }
            label.text = model.name 
            imageView.setHeader(headerUrl: model.icon)
        }
    }
    
    
    
    func setUI() {
        backgroundColor = UIColor.white
        addSubview(imageView)
        addSubview(label)
        
        imageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
        }
        
        label.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-5)
            make.centerX.equalToSuperview()
        }
        
    }
    
    
    lazy var imageView = UIImageView()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
}
