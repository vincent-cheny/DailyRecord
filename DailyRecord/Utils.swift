//
//  Utils.swift
//  DailyRecord
//
//  Created by ChenYong on 16/4/4.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

class Utils {
    static func descriptionFromTime(date: NSDate) -> String {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Hour, fromDate: date)
        let hour = components.hour
        switch hour {
        case 4-7:
            return "晨起"
        case 8-9:
            return "早饭后"
        case 10-12:
            return "午饭前"
        case 13-16:
            return "下午"
        case 17-20:
            return "晚殿"
        default:
            return "睡前"
        }
    }
    
    static func allInfoFromTime(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy.M.d HH:mm"
        let todayDate = dateFormatter.stringFromDate(date)
        let todayDescription = Utils.descriptionFromTime(date);
        return todayDate + " " + todayDescription;
    }
}