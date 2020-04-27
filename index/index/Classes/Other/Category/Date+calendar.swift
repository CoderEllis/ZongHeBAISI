//
//  NSDate+calendar.swift
//  index
//
//  Created by Soul on 14/6/2019.
//  Copyright © 2019 Soul. All rights reserved.
//

import Foundation

extension Date {
    
    /// 时间差
    ///
    /// - Parameter fromDate: 起始时间
    /// - Returns: 对象
    func deltaFrom(_ fromDate: Date) -> DateComponents {
        //创建日历对象
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]        
        return calendar.dateComponents(unit, from: fromDate, to: self)
    }
    
    
    /// 是否是同一年
    ///
    /// - Returns: Bool
    func isThisYear() -> Bool {
        let calendar = Calendar.current
        let nowYear = calendar.component(.year, from: Date())
        let selfYear = calendar.component(.year, from: self)
        return nowYear == selfYear
    }
    
    /// 是否是今天的时间
    ///
    /// - Returns: Bool
    func isToday() -> Bool {
        
        let calendar = Calendar.current
        return calendar.isDateInToday(self)
        
//        let currentTime = Date().timeIntervalSince1970
//        let selfTime = self.timeIntervalSince1970
//        return (currentTime - selfTime) <= (24 * 60 * 60)
        
//        let fmt = DateFormatter()
//        fmt.dateFormat = "yyyy-MM-dd"
//        return fmt.string(from: Date()).elementsEqual(fmt.string(from: self))
    }
    
    /// 是否是昨天的时间
    ///
    /// - Returns: Bool
    func isYesterday() -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInYesterday(self)
        
//        let fmt = DateFormatter()
//        fmt.dateFormat = "yyyy-MM-dd"
//        let nowDate = fmt.date(from: fmt.string(from: Date()))!
//        let selfDate = fmt.date(from: fmt.string(from: self))!
//        let calendar = Calendar.current
//        let unit : Set<Calendar.Component> = [.year, .month, .day]
//        let cmps = calendar.dateComponents(unit, from: selfDate, to: nowDate)
//        
//        return cmps.year == 0 && cmps.month == 0 && cmps.day == 1
        
    }
    
}
