//
//  CalendarDayViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/4/28.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit
class CalendarDayViewController: UIViewController {
    
    @IBOutlet weak var dayTitle: UIButton!
    
    var showDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dayTitle.setTitle(Utils.getDay(showDate), forState: .Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func navigateDayRecord(sender: AnyObject) {
        let recordViewController = storyboard?.instantiateViewControllerWithIdentifier("RecordViewController") as! RecordViewController
        recordViewController.dateFilterBtn.title = "今日"
        recordViewController.showDate = showDate
        navigationController?.pushViewController(recordViewController, animated: true)
    }
    
    @IBAction func navigateLastDay(sender: AnyObject) {
        showDate = Utils.lastDay(showDate)
        dayTitle.setTitle(Utils.getDay(showDate), forState: .Normal)
    }
    
    @IBAction func navigateNextDay(sender: AnyObject) {
        showDate = Utils.nextDay(showDate)
        dayTitle.setTitle(Utils.getDay(showDate), forState: .Normal)
    }
    
    @IBAction func navigateToday(sender: AnyObject) {
        showDate = NSDate()
        dayTitle.setTitle(Utils.getDay(showDate), forState: .Normal)
    }
}