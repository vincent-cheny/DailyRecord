//
//  Utils.swift
//  DailyRecord
//
//  Created by ChenYong on 16/4/4.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

class Utils {
    
    static let isInitialized: String = "isInitialized"
    static let needBlackCheck: String = "needBlackCheck"
    static let needWhiteCheck: String = "needWhiteCheck"
    
    static func descriptionFromTime(date: NSDate) -> String {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Hour, fromDate: date)
        let hour = components.hour
        switch hour {
        case 4...7:
            return "晨起"
        case 8...9:
            return "早饭后"
        case 10...12:
            return "午饭前"
        case 13...16:
            return "下午"
        case 17...20:
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
    
    static func getYear(date: NSDate) -> String {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Year, fromDate: date)
        return String(components.year) + "年"
    }
    
    static func getYearMonth(date: NSDate) -> String {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month], fromDate: date)
        return String(components.year) + "年" + String(components.month) + "月"
    }
    
    static func getDay(date: NSDate) -> String {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day], fromDate: date)
        return String(components.year) + "年" + String(components.month) + "月" + String(components.day) + "日"
    }
    
    static func getShortDay(date: NSDate) -> String {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day], fromDate: date)
        return String(components.year) + "." + String(components.month) + "." + String(components.day)
    }
    
    static func getWeek(dateFormatter: NSDateFormatter, date: NSDate) -> String {
        let calendar = NSCalendar.currentCalendar()
        calendar.firstWeekday = 2
        var startOfWeek : NSDate?;
        calendar.rangeOfUnit(.WeekOfYear, startDate: &startOfWeek, interval: nil, forDate: date)
        let weekComponet = NSDateComponents()
        weekComponet.day = 7
        let endOfWeek = calendar.dateByAddingComponents(weekComponet, toDate: startOfWeek!, options: NSCalendarOptions())?.dateByAddingTimeInterval(-1)
        return dateFormatter.stringFromDate(startOfWeek!) + "-" + dateFormatter.stringFromDate(endOfWeek!)
    }
    
    static func getMonth(dateFormatter: NSDateFormatter, date: NSDate) -> String {
        let calendar = NSCalendar.currentCalendar()
        var startOfMonth : NSDate?
        calendar.rangeOfUnit(.Month, startDate: &startOfMonth, interval: nil, forDate: date)
        let monthComponent = NSDateComponents()
        monthComponent.month = 1;
        let endOfMonth = calendar.dateByAddingComponents(monthComponent, toDate: startOfMonth!, options: NSCalendarOptions())?.dateByAddingTimeInterval(-1)
        return dateFormatter.stringFromDate(startOfMonth!) + "-" + dateFormatter.stringFromDate(endOfMonth!)
    }
    
    static func getDayRange(date: NSDate) -> [NSTimeInterval] {
        let calendar = NSCalendar.currentCalendar()
        var startOfDay : NSDate?
        calendar.rangeOfUnit(.Day, startDate: &startOfDay, interval: nil, forDate: date)
        let dayComponet = NSDateComponents()
        dayComponet.day = 1
        let endOfDay = calendar.dateByAddingComponents(dayComponet, toDate: startOfDay!, options: NSCalendarOptions())?.dateByAddingTimeInterval(-1)
        return [startOfDay!.timeIntervalSince1970, endOfDay!.timeIntervalSince1970]
    }
    
    static func getWeekRange(date: NSDate) -> [NSTimeInterval] {
        let calendar = NSCalendar.currentCalendar()
        calendar.firstWeekday = 2
        var startOfWeek : NSDate?;
        calendar.rangeOfUnit(.WeekOfYear, startDate: &startOfWeek, interval: nil, forDate: date)
        let weekComponet = NSDateComponents()
        weekComponet.day = 7
        let endOfWeek = calendar.dateByAddingComponents(weekComponet, toDate: startOfWeek!, options: NSCalendarOptions())?.dateByAddingTimeInterval(-1)
        return [startOfWeek!.timeIntervalSince1970, endOfWeek!.timeIntervalSince1970]
    }
    
    static func getMonthRange(date: NSDate) -> [NSTimeInterval] {
        let calendar = NSCalendar.currentCalendar()
        var startOfMonth : NSDate?
        calendar.rangeOfUnit(.Month, startDate: &startOfMonth, interval: nil, forDate: date)
        let monthComponent = NSDateComponents()
        monthComponent.month = 1;
        let endOfMonth = calendar.dateByAddingComponents(monthComponent, toDate: startOfMonth!, options: NSCalendarOptions())?.dateByAddingTimeInterval(-1)
        return [startOfMonth!.timeIntervalSince1970, endOfMonth!.timeIntervalSince1970]
    }
    
    static func getYearRange(date: NSDate) -> [NSTimeInterval] {
        let calendar = NSCalendar.currentCalendar()
        var startOfYear : NSDate?
        calendar.rangeOfUnit(.Year, startDate: &startOfYear, interval: nil, forDate: date)
        let yearComponent = NSDateComponents()
        yearComponent.year = 1;
        let endOfYear = calendar.dateByAddingComponents(yearComponent, toDate: startOfYear!, options: NSCalendarOptions())?.dateByAddingTimeInterval(-1)
        return [startOfYear!.timeIntervalSince1970, endOfYear!.timeIntervalSince1970]
    }
}