//
//  CheckAndSumSettingViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/4/22.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit

class CheckAndSumSettingViewController: UIViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var blackSwitch: UISwitch!
    @IBOutlet weak var whiteSwitch: UISwitch!
    @IBOutlet weak var dailySummarySwitch: UISwitch!
    @IBOutlet weak var summaryTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        blackSwitch.on = defaults.boolForKey(Utils.needBlackCheck)
        whiteSwitch.on = defaults.boolForKey(Utils.needWhiteCheck)
        dailySummarySwitch.on = defaults.boolForKey(Utils.needDailySummary)
        summaryTimeLabel.text = Utils.getHourAndMinute(getSummaryComponents())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func switchBlackCheck(sender: AnyObject) {
        defaults.setBool(blackSwitch.on, forKey: Utils.needBlackCheck)
    }
    
    @IBAction func switchWhiteCheck(sender: AnyObject) {
        defaults.setBool(whiteSwitch.on, forKey: Utils.needWhiteCheck)
    }
    
    @IBAction func switchDailySummary(sender: UISwitch) {
        defaults.setBool(dailySummarySwitch.on, forKey: Utils.needDailySummary)
        if sender.on {
            openNotification()
        } else {
            cancelNotification()
        }
    }
    
    func cancelNotification() {
        let application = UIApplication.sharedApplication()
        let notifications = application.scheduledLocalNotifications!
        for notification in notifications {
            if notification.category == Utils.dailySummaryCategory {
                //Cancelling local notification
                application.cancelLocalNotification(notification)
            }
        }
    }
    
    func openNotification() {
        let notification = UILocalNotification()
        notification.alertBody = "每日总结" // text that will be displayed in the notification
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.category = Utils.dailySummaryCategory
        notification.repeatInterval = .Day
        notification.fireDate = Utils.getFireDate(getSummaryComponents())
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    @IBAction func setSummaryTime(sender: AnyObject) {
        DatePickerDialog().show("请选择时间", doneButtonTitle: "确定", cancelButtonTitle: "取消", defaultDate: NSCalendar.currentCalendar().dateFromComponents(getSummaryComponents())!, datePickerMode: .Time) {
            (date) -> Void in
            let components = NSCalendar.currentCalendar().components([.Hour, .Minute], fromDate: date)
            self.summaryTimeLabel.text = Utils.getHourAndMinute(components)
            self.defaults.setObject([components.hour, components.minute], forKey: Utils.summaryTime)
            if self.dailySummarySwitch.on {
                self.cancelNotification()
                self.openNotification()
            }
        }
    }
    
    func getSummaryComponents() -> NSDateComponents {
        let components = NSDateComponents()
        let summaryTime = defaults.objectForKey(Utils.summaryTime) as! [Int]
        components.hour = summaryTime[0]
        components.minute = summaryTime[1]
        return components
    }
}