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
        processTime(1)
    }
    
    @IBAction func minusDate(sender: AnyObject) {
        processTime(-1)
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
            self.updateTime(type)
        }))
    }
    
    func updateTime(type: String) {
        switch type {
        case "本周":
            timeLabel.text = Utils.getWeek(dateFormatter, date: NSDate())
        case "本月":
            timeLabel.text = Utils.getYearMonth(NSDate())
        case "本年":
            timeLabel.text = Utils.getYear(NSDate())
        default:
            break
        }
    }
    
    func processTime(diff: Int) {
        switch dateType.title! {
        case "本周":
            break
        case "本月":
            break
        case "本年":
            break
        default:
            break
        }
    }
}