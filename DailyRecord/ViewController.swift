//
//  ViewController.swift
//  DailyRecord
//
//  Created by Mi on 23/8/15.
//  Copyright (c) 2015年 LazyPanda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var todayTime: UILabel!
    @IBOutlet weak var dayTime: UILabel!
    @IBOutlet weak var weekTime: UILabel!
    @IBOutlet weak var monthTime: UILabel!
    
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
        var today = NSDate()
        let interval = NSTimeZone.systemTimeZone().secondsFromGMTForDate(today);
        today = today.dateByAddingTimeInterval(NSTimeInterval(interval))
        
        let todayDate = dateFormatter.stringFromDate(today)
        todayTime.text = todayDate
        dayTime.text = todayDate
        let calendar = NSCalendar.currentCalendar()
        calendar.firstWeekday = 2
        
        var startOfWeek : NSDate?;
        calendar.rangeOfUnit(.WeekOfYear, startDate: &startOfWeek, interval: nil, forDate: today)
        let weekComponet = NSDateComponents()
        weekComponet.day = 6
        let endOfWeek = calendar.dateByAddingComponents(weekComponet, toDate: startOfWeek!, options: NSCalendarOptions())
        weekTime.text = dateFormatter.stringFromDate(startOfWeek!) + "-" + dateFormatter.stringFromDate(endOfWeek!)
        
        var startOfMonth : NSDate?
        calendar.rangeOfUnit(.Month, startDate: &startOfMonth, interval: nil, forDate: today)
        let monthComponent = NSDateComponents()
        monthComponent.month = 1;
        let endOfMonth = calendar.dateByAddingComponents(monthComponent, toDate: startOfMonth!, options: NSCalendarOptions())?.dateByAddingTimeInterval(-1)
        monthTime.text = dateFormatter.stringFromDate(startOfMonth!) + "-" + dateFormatter.stringFromDate(endOfMonth!)
    }
}

