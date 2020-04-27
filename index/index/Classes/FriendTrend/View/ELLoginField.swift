//
//  ELLoginField.swift
//  index
//
//  Created by Soul on 1/6/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import UIKit

class ELLoginField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = UIColor.purple
        tintColor = UIColor.red
        
        addTarget(self, action: #selector(textBegin), for: UIControl.Event.editingDidBegin)
        addTarget(self, action: #selector(textEnd), for: UIControl.Event.editingDidEnd)
        
        
//        placeholderColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //方法一
    func no1() {
        let attrs = [NSAttributedString.Key.foregroundColor : UIColor.white]
        attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: attrs)
    }
    
    
    @objc func textBegin() {
        placeholderColor = UIColor.yellow
    }
    
    @objc func textEnd() {
        placeholderColor = UIColor.blue
    }
    
}
