//
//  CalendarViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/2/12.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var dayColelectionView: UICollectionView!
    @IBOutlet weak var monthTitle: UIButton!
    
    var showDate = NSDate()
    let todayColor = UIColor.init(red: 10 / 255.0, green: 0 / 255.0, blue: 200 / 255.0, alpha: 80 / 255.0)
    var unhighlightColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dayColelectionView.delegate = self
        dayColelectionView.dataSource = self
        monthTitle.setTitle(Utils.getYearMonth(showDate), forState: .Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false;
    }
    
    @IBAction func navigateToday(sender: AnyObject) {
        showDate = NSDate()
        monthTitle.setTitle(Utils.getYearMonth(showDate), forState: .Normal)
        dayColelectionView.reloadData()
    }
    
    @IBAction func navigateLastMonth(sender: AnyObject) {
        showDate = Utils.lastMonth(showDate)
        monthTitle.setTitle(Utils.getYearMonth(showDate), forState: .Normal)
        dayColelectionView.reloadData()
    }
    
    @IBAction func navigateNextMonth(sender: AnyObject) {
        showDate = Utils.nextMonth(showDate)
        monthTitle.setTitle(Utils.getYearMonth(showDate), forState: .Normal)
        dayColelectionView.reloadData()
    }
    
    @IBAction func navigateMonthRecord(sender: AnyObject) {
        let recordViewController = storyboard?.instantiateViewControllerWithIdentifier("RecordViewController") as! RecordViewController
        recordViewController.dateFilterBtn.title = "本月"
        recordViewController.showDate = showDate
        navigationController?.pushViewController(recordViewController, animated: true)
    }
    
    @IBAction func respondToRightSwipeGesture(sender: AnyObject) {
        showDate = Utils.lastMonth(showDate)
        monthTitle.setTitle(Utils.getYearMonth(showDate), forState: .Normal)
        dayColelectionView.reloadData()
    }
    
    @IBAction func respondToLeftSwipeGesture(sender: AnyObject) {
        showDate = Utils.nextMonth(showDate)
        monthTitle.setTitle(Utils.getYearMonth(showDate), forState: .Normal)
        dayColelectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let dayCalendarCell = collectionView.dequeueReusableCellWithReuseIdentifier("dayCalendarCell", forIndexPath: indexPath) as! DayCollectionViewCell
        dayCalendarCell.backgroundColor = UIColor.clearColor()
        let index = indexPath.row
        let firstWeekdayInMonth = Utils.firstWeekdayInMonth(showDate)
        let totalDaysInMonth = Utils.totalDaysInMonth(showDate)
        let lastMonth = Utils.lastMonth(showDate)
        let nextMonth = Utils.nextMonth(showDate)
        let totalDaysInLastMonth = Utils.totalDaysInMonth(lastMonth)
        let calendar = NSCalendar.currentCalendar()
        var showDayComponents: NSDateComponents
        let dayValue: NSInteger
        if index < firstWeekdayInMonth {
            showDayComponents = calendar.components([.Year, .Month], fromDate: lastMonth)
            dayValue = totalDaysInLastMonth - firstWeekdayInMonth + index + 1
            dayCalendarCell.dayLabel.textColor = UIColor.lightGrayColor()
            dayCalendarCell.dayLabel.text = String(dayValue)
        } else if index >= firstWeekdayInMonth + totalDaysInMonth {
            showDayComponents = calendar.components([.Year, .Month], fromDate: nextMonth)
            dayValue = index - firstWeekdayInMonth - totalDaysInMonth + 1
            dayCalendarCell.dayLabel.textColor = UIColor.lightGrayColor()
            dayCalendarCell.dayLabel.text = String(dayValue)
        } else {
            showDayComponents = calendar.components([.Year, .Month], fromDate: showDate)
            dayValue = index - firstWeekdayInMonth + 1
            dayCalendarCell.dayLabel.textColor = UIColor.blackColor()
            dayCalendarCell.dayLabel.text = String(dayValue)
        }
        showDayComponents.day = dayValue
        let todayComponents = calendar.components([.Year, .Month, .Day], fromDate: NSDate())
        if showDayComponents == todayComponents {
            dayCalendarCell.backgroundColor = todayColor
            dayCalendarCell.dayLabel.textColor = UIColor.whiteColor()
        }
        return dayCalendarCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        let firstWeekdayInMonth = Utils.firstWeekdayInMonth(showDate)
        let totalDaysInMonth = Utils.totalDaysInMonth(showDate)
        let lastMonth = Utils.lastMonth(showDate)
        let nextMonth = Utils.nextMonth(showDate)
        let totalDaysInLastMonth = Utils.totalDaysInMonth(lastMonth)
        let calendar = NSCalendar.currentCalendar()
        var showDayComponents: NSDateComponents
        let dayValue: NSInteger
        if index < firstWeekdayInMonth {
            showDayComponents = calendar.components([.Year, .Month], fromDate: lastMonth)
            dayValue = totalDaysInLastMonth - firstWeekdayInMonth + index + 1
        } else if index >= firstWeekdayInMonth + totalDaysInMonth {
            showDayComponents = calendar.components([.Year, .Month], fromDate: nextMonth)
            dayValue = index - firstWeekdayInMonth - totalDaysInMonth + 1
        } else {
            showDayComponents = calendar.components([.Year, .Month], fromDate: showDate)
            dayValue = index - firstWeekdayInMonth + 1
        }
        showDayComponents.day = dayValue
        let calendarDayViewController = storyboard?.instantiateViewControllerWithIdentifier("CalendarDayViewController") as! CalendarDayViewController
        calendarDayViewController.showDate = NSCalendar.currentCalendar().dateFromComponents(showDayComponents)!
        navigationController?.pushViewController(calendarDayViewController, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        unhighlightColor = cell?.backgroundColor
        cell?.backgroundColor = UIColor.whiteColor()
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = unhighlightColor
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 0.0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSize(width: view.frame.width / 7, height: 50)
    }
    
}