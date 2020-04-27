//
//  String-Extension.swift
//  index
//
//  Created by Soul on 14/6/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import Foundation

extension String {
    ///时间格式化
    func countTime() -> String {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formater.date(from: self) else {
            return "error"
        }
        
        if date.isThisYear() {
            if date.isToday() {
                let coms = Date().deltaFrom(date)
                if coms.hour! >= 1 {
                    return "\(coms.hour!)小时之前"
                    
                } else if coms.minute! > 1 {
                    return "\(coms.minute!)分钟之前"
                    
                } else {
                    return "刚刚"
                }
                
            } else if date.isYesterday() {
                formater.dateFormat = "昨天 HH:mm:ss"
                
                return formater.string(from: date)
            } else {
                formater.dateFormat = "MM-dd HH:mm:ss"
                
                return formater.string(from: date)
            }
        } else { // 非今年
            return self
        }
        
    }
}
