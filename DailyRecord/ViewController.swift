//
//  ViewController.swift
//  DailyRecord
//
//  Created by Mi on 23/8/15.
//  Copyright (c) 2015年 LazyPanda. All rights reserved.
//

import UIKit
import RealmSwift
import PNChart

class ViewController: UIViewController {

    @IBOutlet weak var todayTime: UILabel!
    @IBOutlet weak var dayTime: UILabel!
    @IBOutlet weak var weekTime: UILabel!
    @IBOutlet weak var monthTime: UILabel!
    
    @IBOutlet weak var totalBlackLabel: UILabel!
    @IBOutlet weak var totalBlackCheckLabel: UILabel!
    @IBOutlet weak var totalWhiteLabel: UILabel!
    @IBOutlet weak var totalWhiteCheckLabel: UILabel!
    
    @IBOutlet weak var dayBlack: UILabel!
    @IBOutlet weak var dayBlackCheck: UILabel!
    @IBOutlet weak var dayWhite: UILabel!
    @IBOutlet weak var dayWhiteCheck: UILabel!
    
    @IBOutlet weak var weekBlack: UILabel!
    @IBOutlet weak var weekBlackCheck: UILabel!
    @IBOutlet weak var weekWhite: UILabel!
    @IBOutlet weak var weekWhiteCheck: UILabel!
    
    @IBOutlet weak var monthBlack: UILabel!
    @IBOutlet weak var monthBlackCheck: UILabel!
    @IBOutlet weak var monthWhite: UILabel!
    @IBOutlet weak var monthWhiteCheck: UILabel!
    
    @IBOutlet weak var pieChart: CustomPNPieChart!
    
    @IBOutlet weak var remindTitle: UILabel!
    @IBOutlet weak var remindContent: UILabel!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "title_bar"), forBarMetrics: .Default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true;
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy.M.d"
        let today = NSDate()
        let todayDate = dateFormatter.stringFromDate(today)
        todayTime.text = todayDate
        dayTime.text = todayDate
        weekTime.text = Utils.getWeek(dateFormatter, date: today)
        monthTime.text = Utils.getMonth(dateFormatter, date: today)
        
        let totalBlack = realm.objects(Industry).filter("type = '黑业'").count
        let totalBlackCheck = realm.objects(Industry).filter("type = '黑业对治'").count
        let totalWhite = realm.objects(Industry).filter("type = '白业'").count
        let totalWhiteCheck = realm.objects(Industry).filter("type = '白业对治'").count
        
        totalBlackLabel.text = String(totalBlack)
        totalBlackCheckLabel.text = String(totalBlackCheck)
        totalWhiteLabel.text = String(totalWhite)
        totalWhiteCheckLabel.text = String(totalWhiteCheck)
        
        if totalBlack + totalBlackCheck + totalWhite + totalWhiteCheck > 0 {
            pieChart.updateChartData([PNPieChartDataItem(value: CGFloat(totalBlack), color: UIColor.blackColor()), PNPieChartDataItem(value: CGFloat(totalBlackCheck), color: UIColor.greenColor()), PNPieChartDataItem(value: CGFloat(totalWhite), color: UIColor.whiteColor()), PNPieChartDataItem(value: CGFloat(totalWhiteCheck), color: UIColor.redColor())])
            pieChart.displayAnimated = false
            pieChart.userInteractionEnabled = false
            pieChart.hideValues = true
            pieChart.strokeChart()
        }
        
        let dayRange = Utils.getDayRange(today)
        dayBlack.text = String(realm.objects(Industry).filter("type = '黑业' AND time BETWEEN {%@, %@}", dayRange[0], dayRange[1]).count)
        dayBlackCheck.text = String(realm.objects(Industry).filter("type = '黑业对治' AND time BETWEEN {%@, %@}", dayRange[0], dayRange[1]).count)
        dayWhite.text = String(realm.objects(Industry).filter("type = '白业' AND time BETWEEN {%@, %@}", dayRange[0], dayRange[1]).count)
        dayWhiteCheck.text = String(realm.objects(Industry).filter("type = '白业对治' AND time BETWEEN {%@, %@}", dayRange[0], dayRange[1]).count)
        
        let weekRange = Utils.getWeekRange(today)
        weekBlack.text = String(realm.objects(Industry).filter("type = '黑业' AND time BETWEEN {%@, %@}", weekRange[0], weekRange[1]).count)
        weekBlackCheck.text = String(realm.objects(Industry).filter("type = '黑业对治' AND time BETWEEN {%@, %@}", weekRange[0], weekRange[1]).count)
        weekWhite.text = String(realm.objects(Industry).filter("type = '白业' AND time BETWEEN {%@, %@}", weekRange[0], weekRange[1]).count)
        weekWhiteCheck.text = String(realm.objects(Industry).filter("type = '白业对治' AND time BETWEEN {%@, %@}", weekRange[0], weekRange[1]).count)
        
        let monthRange = Utils.getMonthRange(today)
        monthBlack.text = String(realm.objects(Industry).filter("type = '黑业' AND time BETWEEN {%@, %@}", monthRange[0], monthRange[1]).count)
        monthBlackCheck.text = String(realm.objects(Industry).filter("type = '黑业对治' AND time BETWEEN {%@, %@}", monthRange[0], monthRange[1]).count)
        monthWhite.text = String(realm.objects(Industry).filter("type = '白业' AND time BETWEEN {%@, %@}", monthRange[0], monthRange[1]).count)
        monthWhiteCheck.text = String(realm.objects(Industry).filter("type = '白业对治' AND time BETWEEN {%@, %@}", monthRange[0], monthRange[1]).count)
        
        //提醒逻辑
        let weekday = Utils.getWeekday(today)
        let components = NSCalendar.currentCalendar().components([.Hour, .Minute], fromDate: today)
        let todayMinutes = 24 * 60 * weekday + components.hour * 60 + components.minute
        
        let totalReminds = realm.objects(Remind)
        let enableReminds = realm.objects(Remind).filter("enable = true AND (monday = true || tuesday = true || wednesday = true || thursday = true || friday = true || saturday = true || sunday = true)")
        let sortedReminds = enableReminds.sort { (remind1, remind2) -> Bool in
            let remind1MinMinutes = getRemindMinMinutes(remind1, todayMinutes: todayMinutes)
            let remind2MinMinutes = getRemindMinMinutes(remind2, todayMinutes: todayMinutes)
            if remind1MinMinutes != remind2MinMinutes {
                return remind1MinMinutes < remind2MinMinutes
            } else {
                return remind1.id > remind2.id
            }
        }
        if totalReminds.count == 0 {
            remindTitle.text = "提醒"
            remindContent.text = "标签"
        } else if enableReminds.count == 0 {
            remindTitle.text = "没有提醒"
            remindContent.text = ""
        } else {
            let components = NSDateComponents()
            components.hour = sortedReminds[0].hour
            components.minute = sortedReminds[0].minute
            remindTitle.text = getRemindMinWeekday(sortedReminds[0], todayMinutes: todayMinutes) + " " + Utils.getHourAndMinute(components)
            remindContent.text = sortedReminds[0].content
        }
    }
    
    func getRemindMinMinutes(remind: Remind, todayMinutes: Int) -> Int {
        var minMinutes = 0
        if remind.monday {
            let diffMinutes = getDiffMinutes(remind, weekday: 1, todayMinutes: todayMinutes)
            if minMinutes == 0 || diffMinutes < minMinutes {
                minMinutes = diffMinutes
            }
        }
        if remind.tuesday {
            let diffMinutes = getDiffMinutes(remind, weekday: 2, todayMinutes: todayMinutes)
            if minMinutes == 0 || diffMinutes < minMinutes {
                minMinutes = diffMinutes
            }
        }
        if remind.wednesday {
            let diffMinutes = getDiffMinutes(remind, weekday: 3, todayMinutes: todayMinutes)
            if minMinutes == 0 || diffMinutes < minMinutes {
                minMinutes = diffMinutes
            }
        }
        if remind.thursday {
            let diffMinutes = getDiffMinutes(remind, weekday: 4, todayMinutes: todayMinutes)
            if minMinutes == 0 || diffMinutes < minMinutes {
                minMinutes = diffMinutes
            }
        }
        if remind.friday {
            let diffMinutes = getDiffMinutes(remind, weekday: 5, todayMinutes: todayMinutes)
            if minMinutes == 0 || diffMinutes < minMinutes {
                minMinutes = diffMinutes
            }
        }
        if remind.saturday {
            let diffMinutes = getDiffMinutes(remind, weekday: 6, todayMinutes: todayMinutes)
            if minMinutes == 0 || diffMinutes < minMinutes {
                minMinutes = diffMinutes
            }
        }
        if remind.sunday {
            let diffMinutes = getDiffMinutes(remind, weekday: 7, todayMinutes: todayMinutes)
            if minMinutes == 0 || diffMinutes < minMinutes {
                minMinutes = diffMinutes
            }
        }
        return minMinutes
    }
    
    func getDiffMinutes(remind: Remind, weekday: Int, todayMinutes: Int) -> Int {
        let remindMinutes = 24 * 60 * weekday + remind.hour * 60 + remind.minute
        if remindMinutes > todayMinutes {
            return remindMinutes - todayMinutes
        } else {
            return remindMinutes - todayMinutes + 24 * 60 * 7
        }
    }
    
    func getRemindMinWeekday(remind: Remind, todayMinutes: Int) -> String {
        var minMinutes = 0
        var minWeekday = ""
        if remind.monday {
            let diffMinutes = getDiffMinutes(remind, weekday: 1, todayMinutes: todayMinutes)
            if minMinutes == 0 || diffMinutes < minMinutes {
                minMinutes = diffMinutes
                minWeekday = "周一"
            }
        }
        if remind.tuesday {
            let diffMinutes = getDiffMinutes(remind, weekday: 2, todayMinutes: todayMinutes)
            if minMinutes == 0 || diffMinutes < minMinutes {
                minMinutes = diffMinutes
                minWeekday = "周二"
            }
        }
        if remind.wednesday {
            let diffMinutes = getDiffMinutes(remind, weekday: 3, todayMinutes: todayMinutes)
            if minMinutes == 0 || diffMinutes < minMinutes {
                minMinutes = diffMinutes
                minWeekday = "周三"
            }
        }
        if remind.thursday {
            let diffMinutes = getDiffMinutes(remind, weekday: 4, todayMinutes: todayMinutes)
            if minMinutes == 0 || diffMinutes < minMinutes {
                minMinutes = diffMinutes
                minWeekday = "周四"
            }
        }
        if remind.friday {
            let diffMinutes = getDiffMinutes(remind, weekday: 5, todayMinutes: todayMinutes)
            if minMinutes == 0 || diffMinutes < minMinutes {
                minMinutes = diffMinutes
                minWeekday = "周五"
            }
        }
        if remind.saturday {
            let diffMinutes = getDiffMinutes(remind, weekday: 6, todayMinutes: todayMinutes)
            if minMinutes == 0 || diffMinutes < minMinutes {
                minMinutes = diffMinutes
                minWeekday = "周六"
            }
        }
        if remind.sunday {
            let diffMinutes = getDiffMinutes(remind, weekday: 7, todayMinutes: todayMinutes)
            if minMinutes == 0 || diffMinutes < minMinutes {
                minMinutes = diffMinutes
                minWeekday = "周日"
            }
        }
        return minWeekday
    }
    
    @IBAction func navigateBlack(sender: AnyObject) {
        let industryViewController = storyboard?.instantiateViewControllerWithIdentifier("IndustryViewController") as! IndustryViewController
        industryViewController.industryType = "黑业"
        navigationController?.pushViewController(industryViewController, animated: true)
    }
    
    @IBAction func navigateWhite(sender: AnyObject) {
        let industryViewController = storyboard?.instantiateViewControllerWithIdentifier("IndustryViewController") as! IndustryViewController
        industryViewController.industryType = "白业"
        navigationController?.pushViewController(industryViewController, animated: true)
    }
    
    @IBAction func navigateBlackCheck(sender: AnyObject) {
        let checkSummaryViewController = storyboard?.instantiateViewControllerWithIdentifier("CheckSummaryViewController") as! CheckSummaryViewController
        checkSummaryViewController.typeFilterBtn.title = "黑业"
        navigationController?.pushViewController(checkSummaryViewController, animated: true)
    }
    
    @IBAction func navigateWhiteCheck(sender: AnyObject) {
        let checkSummaryViewController = storyboard?.instantiateViewControllerWithIdentifier("CheckSummaryViewController") as! CheckSummaryViewController
        checkSummaryViewController.typeFilterBtn.title = "白业"
        navigationController?.pushViewController(checkSummaryViewController, animated: true)
    }
    
    @IBAction func searchDay(sender: AnyObject) {
        let recordViewController = storyboard?.instantiateViewControllerWithIdentifier("RecordViewController") as! RecordViewController
        recordViewController.dateFilterBtn.title = "今日"
        navigationController?.pushViewController(recordViewController, animated: true)
    }
    
    @IBAction func searchWeek(sender: AnyObject) {
        let recordViewController = storyboard?.instantiateViewControllerWithIdentifier("RecordViewController") as! RecordViewController
        recordViewController.dateFilterBtn.title = "本周"
        navigationController?.pushViewController(recordViewController, animated: true)
    }
    
    @IBAction func searchMonth(sender: AnyObject) {
        let recordViewController = storyboard?.instantiateViewControllerWithIdentifier("RecordViewController") as! RecordViewController
        recordViewController.dateFilterBtn.title = "本月"
        navigationController?.pushViewController(recordViewController, animated: true)
    }
    
    @IBAction func navigateRemind(sender: AnyObject) {
        
    }
}

