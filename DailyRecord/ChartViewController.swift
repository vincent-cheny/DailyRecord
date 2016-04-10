//
//  ChartViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/2/12.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController {
    
    @IBOutlet weak var dateType: UIBarButtonItem!
    @IBOutlet weak var chartType: UIBarButtonItem!
    @IBOutlet weak var timeLabel: UILabel!
    
    let dateFormatter = NSDateFormatter()
    var showDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dateFormatter.dateFormat = "yyyy.M.d"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false;
        timeLabel.text = Utils.getWeek(dateFormatter, date: NSDate())
    }
    
    @IBAction func plusDate(sender: AnyObject) {
        updateTime(dateType.title!, diff: 1)
    }
    
    @IBAction func minusDate(sender: AnyObject) {
        updateTime(dateType.title!, diff: -1)
    }
    
    @IBAction func switchChartType(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        addChartType(alert, type: "饼状图")
        addChartType(alert, type: "折线图")
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func switchDateType(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        addDateType(alert, type: "本周")
        addDateType(alert, type: "本月")
        addDateType(alert, type: "本年")
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func addChartType(alert: UIAlertController, type: String) {
        alert.addAction(UIAlertAction(title: type, style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.chartType.title = type
        }))
    }
    
    func addDateType(alert: UIAlertController, type: String) {
        alert.addAction(UIAlertAction(title: type, style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.dateType.title = type
            self.showDate = NSDate()
            self.updateTime(type, diff: 0)
        }))
    }
    
    func updateTime(type: String, diff: Int) {
        switch type {
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
        case "本年":
            let yearComponent = NSDateComponents()
            yearComponent.year = diff;
            showDate = NSCalendar.currentCalendar().dateByAddingComponents(yearComponent, toDate: showDate, options: NSCalendarOptions())!
            timeLabel.text = Utils.getYear(showDate)
        default:
            break
        }
    }
    
}