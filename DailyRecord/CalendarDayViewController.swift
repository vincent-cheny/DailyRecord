//
//  CalendarDayViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/4/28.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit
class CalendarDayViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var dayTitle: UIButton!
    @IBOutlet weak var industryCollectionView: UICollectionView!
    
    var showDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        industryCollectionView.delegate = self
        industryCollectionView.dataSource = self
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let industryCalendarCell = collectionView.dequeueReusableCellWithReuseIdentifier("industryCalendarCell", forIndexPath: indexPath) as! IndustryCollectionViewCell
        return industryCalendarCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.whiteColor()
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.clearColor()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 0.0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSize(width: view.frame.width / 5, height: 50)
    }
}