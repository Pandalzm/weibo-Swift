//
//  NSDate+Panda.swift
//  Weibo-Swift
//
//  Created by PandaLZMing on 16/1/25.
//  Copyright © 2016年 PandaLZMing. All rights reserved.
//

import Foundation


extension NSDate {

    func isToday() -> Bool {
        if fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24 { return false }
        return NSDate().day == self.day
    }
    
    func isYesterday() -> Bool {
        let added = self.dateByAddingDays(1)
        return added.isToday()
    }
    
    func dateByAddingDays(days: Int) -> NSDate {
        let aTimeInterval:NSTimeInterval = self.timeIntervalSinceReferenceDate + NSTimeInterval(86400 * days)
        return NSDate(timeIntervalSinceReferenceDate: aTimeInterval)
    
    }
    
    var day: Int {
        get {
            return NSCalendar.currentCalendar().component(.Day, fromDate: self)
        }
    }
    
    var year: Int {
        get {
            return NSCalendar.currentCalendar().component(.Year, fromDate: self)
        }
    }
    
    var month: Int {
        get {
            return NSCalendar.currentCalendar().component(.Month, fromDate: self)
        }
    }


}