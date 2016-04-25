//
//  CheckSummaryViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/2/23.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit
import RealmSwift

class CheckSummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dateFilterBtn: UIBarButtonItem!
    @IBOutlet weak var typeFilterBtn: UIBarButtonItem!
    @IBOutlet weak var checkStateFilterBtn: UIBarButtonItem!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var industryAndCheckTabelView: UITableView!
    
    let dateFormatter = NSDateFormatter()
    var showDate = NSDate()
    
    let realm = try! Realm()
    var industrieAndChecks = try! Realm().objects(Industry).filter("type IN {'黑业', '白业'}").sorted("time")

    var dateRange: [NSTimeInterval]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dateFormatter.dateFormat = "yyyy.M.d"
        updateTime(dateFilterBtn.title!, diff: 0)
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
        if (industrieAndCheck.bind_id > 0) {
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
            if (industrieAndCheck.bind_id > 0) {
                checkImageView.image = UIImage(named: "greendot")
                checkType.textColor = UIColor.greenColor()
            } else {
                checkType.textColor = UIColor.lightGrayColor()
            }
        case "白业":
            industryImageView.image = UIImage(named: "whitedot")
            industryType.textColor = UIColor.whiteColor()
            if (industrieAndCheck.bind_id > 0) {
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
            self.updateTableView()
            self.industryAndCheckTabelView.reloadData()
        }))
    }
    
    func filterCheckState(alert: UIAlertController, filter: String) {
        alert.addAction(UIAlertAction(title: filter, style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.checkStateFilterBtn.title = filter
            self.updateTableView()
            self.industryAndCheckTabelView.reloadData()
        }))
    }
    
    func updateTime(type: String, diff: Int) {
        switch type {
        case "今日":
            let dayComponent = NSDateComponents()
            dayComponent.day = diff
            showDate = NSCalendar.currentCalendar().dateByAddingComponents(dayComponent, toDate: showDate, options: NSCalendarOptions())!
            timeLabel.text = Utils.getDay(showDate)
            dateRange = Utils.getDayRange(showDate)
            updateTableView()
            industryAndCheckTabelView.reloadData()
        case "本周":
            let weekComponent = NSDateComponents()
            weekComponent.day = diff * 7;
            showDate = NSCalendar.currentCalendar().dateByAddingComponents(weekComponent, toDate: showDate, options: NSCalendarOptions())!
            timeLabel.text = Utils.getWeek(dateFormatter, date: showDate)
            dateRange = Utils.getWeekRange(showDate)
            updateTableView()
            industryAndCheckTabelView.reloadData()
        case "本月":
            let monthComponent = NSDateComponents()
            monthComponent.month = diff;
            showDate = NSCalendar.currentCalendar().dateByAddingComponents(monthComponent, toDate: showDate, options: NSCalendarOptions())!
            timeLabel.text = Utils.getYearMonth(showDate)
            dateRange = Utils.getMonthRange(showDate)
            updateTableView()
            industryAndCheckTabelView.reloadData()
        default:
            break
        }
    }
    
    func updateTableView() {
        let filter = self.typeFilterBtn.title
        if filter == "全部" {
            switch checkStateFilterBtn.title! {
            case "全部业习":
                industrieAndChecks = self.realm.objects(Industry).filter("type IN {'黑业', '白业'} AND time BETWEEN {%@, %@}", dateRange[0], dateRange[1]).sorted("time")
            case "已对治":
                industrieAndChecks = self.realm.objects(Industry).filter("type IN {'黑业', '白业'} AND bind_id > 0 AND time BETWEEN {%@, %@}", dateRange[0], dateRange[1]).sorted("time")
            case "未对治":
                industrieAndChecks = self.realm.objects(Industry).filter("type IN {'黑业', '白业'} AND bind_id = 0 AND time BETWEEN {%@, %@}", dateRange[0], dateRange[1]).sorted("time")
            default:
                break
            }
        } else {
            switch checkStateFilterBtn.title! {
            case "全部业习":
                industrieAndChecks = self.realm.objects(Industry).filter("type = %@ AND time BETWEEN {%@, %@}", typeFilterBtn.title!, dateRange[0], dateRange[1]).sorted("time")
            case "已对治":
                industrieAndChecks = self.realm.objects(Industry).filter("bind_id > 0 AND type = %@ AND time BETWEEN {%@, %@}", typeFilterBtn.title!, dateRange[0], dateRange[1]).sorted("time")
            case "未对治":
                industrieAndChecks = self.realm.objects(Industry).filter("bind_id = 0 AND type = %@ AND time BETWEEN {%@, %@}", typeFilterBtn.title!, dateRange[0], dateRange[1]).sorted("time")
            default:
                break
            }
        }
    }
    
}