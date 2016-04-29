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
    
    @IBAction func switchDailySummary(sender: AnyObject) {
        defaults.setBool(dailySummarySwitch.on, forKey: Utils.needDailySummary)
    }
    
    @IBAction func setSummaryTime(sender: AnyObject) {
        DatePickerDialog().show("请选择时间", doneButtonTitle: "确定", cancelButtonTitle: "取消", defaultDate: NSCalendar.currentCalendar().dateFromComponents(getSummaryComponents())!, datePickerMode: .Time) {
            (date) -> Void in
            let components = NSCalendar.currentCalendar().components([.Hour, .Minute], fromDate: date)
            self.summaryTimeLabel.text = Utils.getHourAndMinute(components)
            self.defaults.setObject([components.hour, components.minute], forKey: Utils.summaryTime)
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