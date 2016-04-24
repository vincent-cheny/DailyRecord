//
//  RecordViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/4/24.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit
import RealmSwift

class RecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dateFilterBtn: UIBarButtonItem!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var industryTableView: UITableView!
    
    let dateFormatter = NSDateFormatter()
    var showDate = NSDate()
    
    let realm = try! Realm()
    var industries = try! Realm().objects(Industry).sorted("id")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dateFormatter.dateFormat = "yyyy.M.d"
        updateTime(dateFilterBtn.title!, diff: 0)
        industryTableView.delegate = self
        industryTableView.dataSource = self
        // 解决底部多余行问题
        industryTableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false;
        industryTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let industryCell = tableView.dequeueReusableCellWithIdentifier("industryCell", forIndexPath: indexPath)
        let industry = industries[indexPath.row]
        let imageView = industryCell.viewWithTag(1) as! UIImageView
        let type = industryCell.viewWithTag(2) as! UILabel
        let date = industryCell.viewWithTag(3) as! UILabel
        let content = industryCell.viewWithTag(4) as! UILabel
        type.text = industry.type
        date.text = Utils.getDay(NSDate(timeIntervalSince1970: industry.time))
        content.text = industry.content
        switch industry.type {
        case "黑业":
            imageView.image = UIImage(named: "blackdot")
            type.textColor = UIColor.blackColor()
        case "白业":
            imageView.image = UIImage(named: "whitedot")
            type.textColor = UIColor.whiteColor()
        case "黑业对治":
            imageView.image = UIImage(named: "greendot")
            type.textColor = UIColor.greenColor()
        case "白业对治":
            imageView.image = UIImage(named: "reddot")
            type.textColor = UIColor.redColor()
        default:
            break
        }
        // 解决左对齐问题
        industryTableView.layoutMargins = UIEdgeInsetsZero
        industryTableView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(TemplateViewController.longPressCell(_:))))
        return industryCell
    }
    
    func longPressCell(recognizer: UIGestureRecognizer) {
        if recognizer.state == .Began {
            let indexPath = industryTableView.indexPathForRowAtPoint(recognizer.locationInView(industryTableView))
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "编辑", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
            }))
            alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(UIAlertAction(title: "删除", style: UIAlertActionStyle.Destructive, handler: { (UIAlertAction) -> Void in
                try! self.realm.write {
                    self.realm.delete(self.industries[indexPath!.row])
                }
                self.industryTableView.reloadData()
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return industries.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 模拟闪动效果
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func plusDate(sender: AnyObject) {
        updateTime(dateFilterBtn.title!, diff: 1)
    }
    
    @IBAction func minusDate(sender: AnyObject) {
        updateTime(dateFilterBtn.title!, diff: -1)
    }
    
    @IBAction func search(sender: AnyObject) {
        DatePickerDialog().show("请选择查询日期", doneButtonTitle: "确定", cancelButtonTitle: "取消", datePickerMode: .Date) {
            (date) -> Void in

        }
    }
    
    @IBAction func dateFilter(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        filterDate(alert, filter: "今日")
        filterDate(alert, filter: "本周")
        filterDate(alert, filter: "本月")
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func filterDate(alert: UIAlertController, filter: String) {
        alert.addAction(UIAlertAction(title: filter, style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.dateFilterBtn.title = filter
            self.showDate = NSDate()
            self.updateTime(filter, diff: 0)
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
}