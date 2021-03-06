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
    static let needDailySummary: String = "needDailySummary"
    static let summaryTime: String = "summaryTime"
    static let remindCategory: String = "remindCategory"
    static let dailySummaryCategory: String = "dailySummaryCategory"
    static let timeSetting1: String = "timeSetting1"
    static let timeSetting2: String = "timeSetting2"
    static let timeSetting3: String = "timeSetting3"
    static let timeSetting4: String = "timeSetting4"
    static let timeSetting5: String = "timeSetting5"
    static let timeSetting6: String = "timeSetting6"
    
    static func descriptionFromTime(date: NSDate) -> String {
        let defaults = NSUserDefaults.standardUserDefaults()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Hour, fromDate: date)
        let hour = components.hour
        switch hour {
        case defaults.integerForKey(timeSetting1)...defaults.integerForKey(timeSetting2) - 1:
            return "晨起"
        case defaults.integerForKey(timeSetting2)...defaults.integerForKey(timeSetting3) - 1:
            return "早饭后"
        case defaults.integerForKey(timeSetting3)...defaults.integerForKey(timeSetting4) - 1:
            return "午饭前"
        case defaults.integerForKey(timeSetting4)...defaults.integerForKey(timeSetting5) - 1:
            return "下午"
        case defaults.integerForKey(timeSetting5)...defaults.integerForKey(timeSetting6) - 1:
            return "晚殿"
        default:
            return "睡前"
        }
    }
    
    static func allInfoFromTime(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy.M.d HH:mm"
        let todayDate = dateFormatter.stringFromDate(date)
        let todayDescription = descriptionFromTime(date);
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
    
    static func firstWeekdayInMonth(date: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        calendar.firstWeekday = 2
        var startOfMonth : NSDate?
        calendar.rangeOfUnit(.Month, startDate: &startOfMonth, interval: nil, forDate: date)
        return calendar.ordinalityOfUnit(.Weekday, inUnit: .WeekOfMonth, forDate: startOfMonth!)
    }
    
    static func totalDaysInMonth(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().rangeOfUnit(.Day, inUnit: .Month, forDate: date).length
    }
    
    static func lastMonth(date: NSDate) -> NSDate {
        let monthComponent = NSDateComponents()
        monthComponent.month = -1;
        return NSCalendar.currentCalendar().dateByAddingComponents(monthComponent, toDate: date, options: NSCalendarOptions())!
    }
    
    static func nextMonth(date: NSDate) -> NSDate {
        let monthComponent = NSDateComponents()
        monthComponent.month = 1;
        return NSCalendar.currentCalendar().dateByAddingComponents(monthComponent, toDate: date, options: NSCalendarOptions())!
    }
    
    static func lastDay(date: NSDate) -> NSDate {
        let dayComponent = NSDateComponents()
        dayComponent.day = -1;
        return NSCalendar.currentCalendar().dateByAddingComponents(dayComponent, toDate: date, options: NSCalendarOptions())!
    }
    
    static func nextDay(date: NSDate) -> NSDate {
        let dayComponent = NSDateComponents()
        dayComponent.day = 1;
        return NSCalendar.currentCalendar().dateByAddingComponents(dayComponent, toDate: date, options: NSCalendarOptions())!
    }
    
    static func getHourAndMinute(components: NSDateComponents) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.stringFromDate(NSCalendar.currentCalendar().dateFromComponents(components)!)
    }
    
    static func getWeekday(date: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        calendar.firstWeekday = 2
        return calendar.ordinalityOfUnit(.Weekday, inUnit: .WeekOfMonth, forDate: date)
    }
    
    static func getFireDate(components: NSDateComponents) -> NSDate {
        let today = NSDate()
        let fireDateMinutes = components.hour * 60 + components.minute
        let calendar = NSCalendar.currentCalendar()
        let todayComponents = calendar.components([.Hour, .Minute], fromDate: today)
        let todayMinutes = todayComponents.hour * 60 + todayComponents.minute
        if fireDateMinutes > todayMinutes {
            return calendar.dateBySettingHour(components.hour, minute: components.minute, second: 0, ofDate: today, options: NSCalendarOptions())!
        } else {
            return calendar.dateBySettingHour(components.hour, minute: components.minute, second: 0, ofDate: nextDay(today), options: NSCalendarOptions())!
        }
    }
    
    static func getRepeatsDescription(repeats: [Bool]) -> String {
        var description = ""
        if repeats[0] {
            description += "周一 "
        }
        if repeats[1] {
            description += "周二 "
        }
        if repeats[2] {
            description += "周三 "
        }
        if repeats[3] {
            description += "周四 "
        }
        if repeats[4] {
            description += "周五 "
        }
        if repeats[5] {
            description += "周六 "
        }
        if repeats[6] {
            description += "周日 "
        }
        if description == "" {
            return "不重复"
        } else {
            return description
        }
    }
    
    static func openRemindNotification(remind: Remind) {
        if remind.monday || remind.tuesday || remind.wednesday || remind.thursday || remind.friday || remind.saturday || remind.sunday {
            if remind.monday {
                openRemindNotification(remind, weekday: 1)
            }
            if remind.tuesday {
                openRemindNotification(remind, weekday: 2)
            }
            if remind.wednesday {
                openRemindNotification(remind, weekday: 3)
            }
            if remind.thursday {
                openRemindNotification(remind, weekday: 4)
            }
            if remind.friday {
                openRemindNotification(remind, weekday: 5)
            }
            if remind.saturday {
                openRemindNotification(remind, weekday: 6)
            }
            if remind.sunday {
                openRemindNotification(remind, weekday: 7)
            }
        }
    }
    
    static func openRemindNotification(remind: Remind, weekday: Int) {
        let calendar = NSCalendar.currentCalendar()
        let notification = UILocalNotification()
        notification.alertBody = remind.content
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.category = remindCategory
        notification.repeatInterval = .Weekday
        notification.userInfo = ["id": remind.id]
        let remindComponents = NSDateComponents()
        remindComponents.hour = remind.hour
        remindComponents.minute = remind.minute
        let today = NSDate()
        let todayWeekday = getWeekday(today)
        if todayWeekday == weekday {
            notification.fireDate = getFireDate(remindComponents)
        } else if todayWeekday < weekday {
            let diffComponets = NSDateComponents()
            diffComponets.day = weekday - todayWeekday
            notification.fireDate = calendar.dateBySettingHour(remindComponents.hour, minute: remindComponents.minute, second: 0, ofDate: calendar.dateByAddingComponents(diffComponets, toDate: today, options: NSCalendarOptions())!, options: NSCalendarOptions())!
        } else {
            let diffComponets = NSDateComponents()
            diffComponets.day = weekday - todayWeekday + 7
            notification.fireDate = calendar.dateBySettingHour(remindComponents.hour, minute: remindComponents.minute, second: 0, ofDate: calendar.dateByAddingComponents(diffComponets, toDate: today, options: NSCalendarOptions())!, options: NSCalendarOptions())!
        }
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    static func cancelRemindNotification(remind: Remind) {
        if remind.monday || remind.tuesday || remind.wednesday || remind.thursday || remind.friday || remind.saturday || remind.sunday {
            let application = UIApplication.sharedApplication()
            let notifications = application.scheduledLocalNotifications!
            for notification in notifications {
                var userInfo = notification.userInfo
                if userInfo != nil {
                    let id = userInfo!["id"] as! Int
                    if remind.id == id {
                        //Cancelling local notification
                        application.cancelLocalNotification(notification)
                    }
                }
            }
        }
    }
    
}