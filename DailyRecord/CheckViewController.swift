//
//  CheckViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/2/23.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit
import RealmSwift

class CheckViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dateFilterBtn: UIBarButtonItem!
    @IBOutlet weak var typeFilterBtn: UIBarButtonItem!
    @IBOutlet weak var checkStateFilterBtn: UIBarButtonItem!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var industryAndCheckTabelView: UITableView!
    
    let dateFormatter = NSDateFormatter()
    var showDate = NSDate()
    
    let realm = try! Realm()
    var industrieAndChecks = try! Realm().objects(Industry).sorted("time")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dateFormatter.dateFormat = "yyyy.M.d"
        timeLabel.text = Utils.getDay(showDate)
        industryAndCheckTabelView.delegate = self
        industryAndCheckTabelView.dataSource = self
        // 解决底部多余行问题
        industryAndCheckTabelView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let industryAndCheckCell = tableView.dequeueReusableCellWithIdentifier("industryAndCheckCell", forIndexPath: indexPath)
        let industrieAndCheck = industrieAndChecks[indexPath.row]
        let industryImageView = industryAndCheckCell.viewWithTag(1) as! UIImageView
        let industryType = industryAndCheckCell.viewWithTag(2) as! UILabel
        let industryDate = industryAndCheckCell.viewWithTag(3) as! UILabel
        let industryContent = industryAndCheckCell.viewWithTag(4) as! UILabel
        let checkImageView = industryAndCheckCell.viewWithTag(5) as! UIImageView
        let checkType = industryAndCheckCell.viewWithTag(6) as! UILabel
        let checkDate = industryAndCheckCell.viewWithTag(7) as! UILabel
        let checkContent = industryAndCheckCell.viewWithTag(8) as! UILabel
        industryType.text = industrieAndCheck.type
        industryDate.text = Utils.getShortDay(NSDate(timeIntervalSince1970: industrieAndCheck.time))
        industryContent.text = industrieAndCheck.content
        if (industrieAndCheck.check_id > 0) {
            checkImageView.hidden = false
            checkDate.hidden = false
            checkContent.hidden = false
            
//            checkType.text = industrieAndCheck.type
//            checkDate.text = Utils.getShortDay(NSDate(timeIntervalSince1970: industrieAndCheck.time))
//            checkContent.text = industrieAndCheck.content
        } else {
            checkImageView.hidden = true
            checkDate.hidden = true
            checkContent.hidden = true
            checkType.text = "未对治"
        }
        switch industrieAndCheck.type {
        case "黑业":
            industryImageView.image = UIImage(named: "blackdot")
            industryType.textColor = UIColor.blackColor()
            if (industrieAndCheck.check_id > 0) {
                checkImageView.image = UIImage(named: "greendot")
                checkType.textColor = UIColor.greenColor()
            } else {
                checkType.textColor = UIColor.lightGrayColor()
            }
        case "白业":
            industryImageView.image = UIImage(named: "whitedot")
            industryType.textColor = UIColor.whiteColor()
            if (industrieAndCheck.check_id > 0) {
                checkImageView.image = UIImage(named: "reddot")
                checkType.textColor = UIColor.redColor()
            } else {
                checkType.textColor = UIColor.lightGrayColor()
            }
        default:
            break
        }
        // 解决左对齐问题
        industryAndCheckCell.layoutMargins = UIEdgeInsetsZero
        industryAndCheckCell.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressCell(_:))))
        return industryAndCheckCell
    }
    
    func longPressCell(recognizer: UIGestureRecognizer) {
        if recognizer.state == .Began {
            let indexPath = industryAndCheckTabelView.indexPathForRowAtPoint(recognizer.locationInView(industryAndCheckTabelView))
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "编辑", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
            }))
            alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return industrieAndChecks.count
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