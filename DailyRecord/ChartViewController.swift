//
//  ChartViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/2/12.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit
import RealmSwift
import PNChart

class ChartViewController: UIViewController {
    
    @IBOutlet weak var dateType: UIBarButtonItem!
    @IBOutlet weak var chartType: UIBarButtonItem!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var pieChart: CustomPNPieChart!
    @IBOutlet weak var lineChart: PNLineChart!
    
    let realm = try! Realm()
    let dateFormatter = NSDateFormatter()
    var showDate = NSDate()
    var dateRange: [NSTimeInterval]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dateFormatter.dateFormat = "yyyy.M.d"
        updateTime(dateType.title!, diff: 0)
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
            self.updateChart()
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
            dateRange = Utils.getWeekRange(showDate)
            updateChart()
        case "本月":
            let monthComponent = NSDateComponents()
            monthComponent.month = diff;
            showDate = NSCalendar.currentCalendar().dateByAddingComponents(monthComponent, toDate: showDate, options: NSCalendarOptions())!
            timeLabel.text = Utils.getYearMonth(showDate)
            dateRange = Utils.getMonthRange(showDate)
            updateChart()
        case "本年":
            let yearComponent = NSDateComponents()
            yearComponent.year = diff;
            showDate = NSCalendar.currentCalendar().dateByAddingComponents(yearComponent, toDate: showDate, options: NSCalendarOptions())!
            timeLabel.text = Utils.getYear(showDate)
            dateRange = Utils.getYearRange(showDate)
            updateChart()
        default:
            break
        }
    }
    
    func updateChart() {
        let black = realm.objects(Industry).filter("type = '黑业' AND time BETWEEN {%@, %@}", dateRange[0], dateRange[1]).count
        let blackCheck = realm.objects(Industry).filter("type = '黑业对治' AND time BETWEEN {%@, %@}", dateRange[0], dateRange[1]).count
        let white = realm.objects(Industry).filter("type = '白业' AND time BETWEEN {%@, %@}", dateRange[0], dateRange[1]).count
        let whiteCheck = realm.objects(Industry).filter("type = '白业对治' AND time BETWEEN {%@, %@}", dateRange[0], dateRange[1]).count
        pieChart.hidden = true
        lineChart.hidden = true
        if black + blackCheck + white + whiteCheck > 0 {
            switch chartType.title! {
            case "饼状图":
                pieChart.hidden = false
                var dataItems = [PNPieChartDataItem]()
                if black > 0 {
                    dataItems.append(PNPieChartDataItem(value: CGFloat(black), color: UIColor.blackColor(), description: "黑业"))
                }
                if blackCheck > 0 {
                    dataItems.append(PNPieChartDataItem(value: CGFloat(blackCheck), color: UIColor.greenColor(), description: "黑业对治"))
                }
                if white > 0 {
                    dataItems.append(PNPieChartDataItem(value: CGFloat(white), color: UIColor.whiteColor(), description: "白业"))
                }
                if whiteCheck > 0 {
                    dataItems.append(PNPieChartDataItem(value: CGFloat(whiteCheck), color: UIColor.redColor(), description: "白业对治"))
                }
                pieChart.updateChartData(dataItems)
                pieChart.descriptionTextColor = UIColor.lightGrayColor()
                pieChart.descriptionTextFont  = UIFont.systemFontOfSize(11.0)
                pieChart.descriptionTextShadowColor = UIColor.clearColor()
                pieChart.displayAnimated = false
                pieChart.showAbsoluteValues = true
                pieChart.userInteractionEnabled = false
                pieChart.strokeChart()
                pieChart.legendStyle = PNLegendItemStyle.Stacked
                pieChart.legendFontColor = UIColor.lightGrayColor()
                pieChart.legendFont = UIFont.boldSystemFontOfSize(12.0)
                let legend = pieChart.getLegendWithMaxWidth(200)
                legend.frame = CGRect(x: 0, y: view.frame.width * 2 / 3, width: legend.frame.size.width, height: legend.frame.size.height)
                pieChart.addSubview(legend)
                break
            case "折线图":
                lineChart.hidden = false
            default:
                break
            }
        }
    }
    
}