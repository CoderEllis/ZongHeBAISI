//
//  PhotoCell.swift
//  allClick
//
//  Created by Soul on 7/7/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.layer.cornerRadius = 10
        userImage.layer.masksToBounds = true
        
    }
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userNmae: UILabel!
    
    
    @IBOutlet weak var numDou: UILabel!
    
    @IBOutlet weak var selectBtn: UIButton!
    
    @IBAction func selectBtn(_ sender: Any) {
        if (checkBlock != nil) {
            checkBlock!(self.items!)
        }
    }
    
    typealias CheckBlock = (_ model: ELTopic)->()
    
    var checkBlock : CheckBlock?
    
    
    var isSelect : Bool = false {
        didSet {
            selectBtn.isSelected = isSelect
        }
    }
    
    
    var items : ELTopic? {
        didSet {
            guard let model = items else {
                return
            }
            userImage.image = UIImage(named: model.userImage)
            userNmae.text = model.userName
            numDou.text = String(format: "%@豆豆", model.numDou)
        }
    }
    
    func didCheckBlock(_ block:@escaping CheckBlock) {
        checkBlock = block
    }
    
}
