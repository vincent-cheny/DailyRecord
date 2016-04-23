//
//  CheckViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/2/23.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit

class CheckViewController: UIViewController {
    
    @IBOutlet weak var dateFilterBtn: UIBarButtonItem!
    @IBOutlet weak var typeFilterBtn: UIBarButtonItem!
    @IBOutlet weak var checkStateFilterBtn: UIBarButtonItem!
    @IBOutlet weak var timeLabel: UILabel!
    
    let dateFormatter = NSDateFormatter()
    var showDate = NSDate()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        timeLabel.text = Utils.getDay(showDate)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false;
    }
    
    @IBAction func plusDate(sender: AnyObject) {
        updateTime(dateFilterBtn.title!, diff: 1)
    }
    
    @IBAction func minusDate(sender: AnyObject) {
        updateTime(dateFilterBtn.title!, diff: -1)
    }
    
    @IBAction func dateFilter(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        filterDate(alert, filter: "今日")
        filterDate(alert, filter: "本周")
        filterDate(alert, filter: "本月")
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func typeFilter(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        filterType(alert, filter: "全部")
        filterType(alert, filter: "黑业")
        filterType(alert, filter: "白业")
        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func checkStateFilter(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        filterCheckState(alert, filter: "全部业习")
        filterCheckState(alert, filter: "已对治")
        filterCheckState(alert, filter: "未对治")
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func filterDate(alert: UIAlertController, filter: String) {
        alert.addAction(UIAlertAction(title: filter, style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.dateFilterBtn.title = filter
            self.showDate = NSDate()
            self.updateTime(filter, diff: 0)
        }))
    }
    
    func filterType(alert: UIAlertController, filter: String) {
        alert.addAction(UIAlertAction(title: filter, style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.typeFilterBtn.title = filter
//            self.updateRecordTemplates(filter)
//            self.templateTableView.reloadData()
        }))
    }
    
    func filterCheckState(alert: UIAlertController, filter: String) {
        alert.addAction(UIAlertAction(title: filter, style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.checkStateFilterBtn.title = filter
//            self.updateRecordTemplates(filter)
//            self.templateTableView.reloadData()
        }))
    }
    
    func updateTime(type: String, diff: Int) {
        switch type {
        case "今日":
            let dayComponent = NSDateComponents()
            dayComponent.day = diff
            showDate = NSCalendar.currentCalendar().dateByAddingComponents(dayComponent, toDate: showDate, options: NSCalendarOptions())!
            timeLabel.text = Utils.getDay(showDate)
        case "本周":
            let weekComponent = NSDateComponents()
            weekComponent.day = diff * 7;
            showDate = NSCalendar.currentCalendar().dateByAddingComponents(weekComponent, toDate: showDate, options: NSCalendarOptions())!
            timeLabel.text = Utils.getWeek(dateFormatter, date: showDate)
        case "本月":
            let monthComponent = NSDateComponents()
            monthComponent.month = diff;
            showDate = NSCalendar.currentCalendar().dateByAddingComponents(monthComponent, toDate: showDate, options: NSCalendarOptions())!
            timeLabel.text = Utils.getYearMonth(showDate)
        default:
            break
        }
    }
    
    func updateIndustry() {
        
    }
    
}