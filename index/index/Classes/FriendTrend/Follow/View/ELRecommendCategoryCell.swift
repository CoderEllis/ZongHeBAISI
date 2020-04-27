//
//  ELRecommendCategoryCell.swift
//  index
//
//  Created by Soul on 2/6/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELRecommendCategoryCell: UITableViewCell {
    
    var category : ELRecommendCategoryM? {
        didSet {
            guard let category = category else { return }
            textLabel?.text = category.name
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        indexView.isHidden = !selected
        textLabel?.textColor = selected ? indexView.backgroundColor : RGBcolor(RGB: 78)
    }
    
    
    func setUI() {
        backgroundColor = RGBcolor(RGB: 244)
        selectionStyle = .none
        clipsToBounds = true
        textLabel?.font = UIFont.systemFont(ofSize: 12)
        addSubview(indexView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.y = 2
        textLabel?.height = contentView.height - 2 * (textLabel?.y)!
        
        indexView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(5)
        }
    }
    
    lazy var indexView : UIView = {
        let indexView = UIView()
        indexView.backgroundColor = RGB(r: 219, g: 21, b: 26, alpha: 1)
        return indexView
    }()
    
}
