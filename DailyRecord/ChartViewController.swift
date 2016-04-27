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
                lineChart.displayAnimated = false
                lineChart.chartMarginLeft = 35
                lineChart.chartCavanHeight = lineChart.frame.height - 50
                var data01Array: [NSNumber]!
                var data02Array: [NSNumber]!
                var data03Array: [NSNumber]!
                var data04Array: [NSNumber]!
                switch dateType.title! {
                case "本周":
                    lineChart.setXLabels(["", "2", "", "4", "", "6", ""], withWidth: (view.frame.width - 75) / 8)
                    data01Array = getEveryDayData("黑业")
                    data02Array = getEveryDayData("黑业对治")
                    data03Array = getEveryDayData("白业")
                    data04Array = getEveryDayData("白业对治")
                case "本月":
                    lineChart.setXLabels(["", "", "", "", "", "", "", "", "", "10", "", "", "", "", "", "", "", "", "", "20", "", "", "", "", "", "", "", "", "", "30", ""], withWidth: (view.frame.width - 75) / 32)
                    data01Array = getEveryDayData("黑业")
                    data02Array = getEveryDayData("黑业对治")
                    data03Array = getEveryDayData("白业")
                    data04Array = getEveryDayData("白业对治")
                case "本年":
                    lineChart.setXLabels(["", "", "", "", "5", "", "", "", "", "10", "", ""], withWidth: (view.frame.width - 75) / 13)
                    data01Array = getEveryMonthData("黑业")
                    data02Array = getEveryMonthData("黑业对治")
                    data03Array = getEveryMonthData("白业")
                    data04Array = getEveryMonthData("白业对治")
                default:
                    break
                }
                lineChart.showCoordinateAxis = true
                lineChart.yFixedValueMin = 0.0
                lineChart.backgroundColor = UIColor.clearColor()
                lineChart.axisColor = UIColor.lightGrayColor()
                let data01 = PNLineChartData()
                data01.inflexionPointStyle = PNLineChartPointStyle.Circle;
                data01.inflexionPointWidth = 2
                data01.dataTitle = "黑业"
                data01.color = UIColor.blackColor()
                data01.itemCount = UInt(data01Array.count)
                data01.getData = { (index: UInt) -> PNLineChartDataItem in
                    let yValue = data01Array[Int(index)]
                    return PNLineChartDataItem.init(y: CGFloat(yValue))
                }
                let data02 = PNLineChartData()
                data02.inflexionPointStyle = PNLineChartPointStyle.Circle;
                data02.inflexionPointWidth = 2
                data02.dataTitle = "黑业对治"
                data02.color = UIColor.greenColor()
                data02.itemCount = UInt(data02Array.count)
                data02.getData = { (index: UInt) -> PNLineChartDataItem in
                    let yValue = data02Array[Int(index)]
                    return PNLineChartDataItem.init(y: CGFloat(yValue))
                }
                let data03 = PNLineChartData()
                data03.inflexionPointStyle = PNLineChartPointStyle.Circle;
                data03.inflexionPointWidth = 2
                data03.dataTitle = "白业"
                data03.color = UIColor.whiteColor()
                data03.itemCount = UInt(data03Array.count)
                data03.getData = { (index: UInt) -> PNLineChartDataItem in
                    let yValue = data03Array[Int(index)]
                    return PNLineChartDataItem.init(y: CGFloat(yValue))
                }
                let data04 = PNLineChartData()
                data04.inflexionPointStyle = PNLineChartPointStyle.Circle;
                data04.inflexionPointWidth = 2
                data04.dataTitle = "白业对治"
                data04.color = UIColor.redColor()
                data04.itemCount = UInt(data04Array.count)
                data04.getData = { (index: UInt) -> PNLineChartDataItem in
                    let yValue = data04Array[Int(index)]
                    return PNLineChartDataItem.init(y: CGFloat(yValue))
                }
                lineChart.chartData = [data01, data02, data03, data04]
                lineChart.strokeChart()
                lineChart.legendStyle = PNLegendItemStyle.Stacked
                lineChart.legendFont = UIFont.boldSystemFontOfSize(12.0)
                lineChart.legendFontColor = UIColor.lightGrayColor()
                let legend = lineChart.getLegendWithMaxWidth(320)
                legend.frame = CGRect(x: 100, y: view.frame.height - 200, width: legend.frame.size.width, height: legend.frame.size.height)
                view.addSubview(legend)
            default:
                break
            }
        }
    }
    
    func getEveryDayData(type: String) -> [NSNumber] {
        var result = [NSNumber]()
        let dayDuration = Double(60 * 60 * 24)
        var startDay = dateRange[0]
        while startDay < dateRange[1] {
            result.append(realm.objects(Industry).filter("type = %@ AND time BETWEEN {%@, %@}", type, startDay, startDay + dayDuration - 1).count)
            startDay += dayDuration
        }
        return result
    }
    
    func getEveryMonthData(type: String) -> [NSNumber] {
        var result = [NSNumber]()
        let calendar = NSCalendar.currentCalendar()
        let monthComponent = NSDateComponents()
        monthComponent.month = 1;
        var startDay = dateRange[0]
        while startDay < dateRange[1] {
            let nextStartDay = calendar.dateByAddingComponents(monthComponent, toDate: NSDate(timeIntervalSince1970: startDay), options: NSCalendarOptions())!.timeIntervalSince1970
            result.append(realm.objects(Industry).filter("type = %@ AND time BETWEEN {%@, %@}", type, startDay, nextStartDay - 1).count)
            startDay = nextStartDay
        }
        return result
    }
}