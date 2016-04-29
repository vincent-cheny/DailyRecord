//
//  CalendarDayViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/4/28.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit
import RealmSwift

class CalendarDayViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var dayTitle: UIButton!
    @IBOutlet weak var industryCollectionView: UICollectionView!
    
    var showDate = NSDate()
    let realm = try! Realm()
    let hourDuration = 60 * 60.0
    
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
        industryCollectionView.reloadData()
    }
    
    @IBAction func navigateNextDay(sender: AnyObject) {
        showDate = Utils.nextDay(showDate)
        dayTitle.setTitle(Utils.getDay(showDate), forState: .Normal)
        industryCollectionView.reloadData()
    }
    
    @IBAction func navigateToday(sender: AnyObject) {
        showDate = NSDate()
        dayTitle.setTitle(Utils.getDay(showDate), forState: .Normal)
        industryCollectionView.reloadData()
    }
    
    @IBAction func respondToRightSwipeGesture(sender: AnyObject) {
        showDate = Utils.lastDay(showDate)
        dayTitle.setTitle(Utils.getDay(showDate), forState: .Normal)
        industryCollectionView.reloadData()
    }
    
    @IBAction func respondToLeftSwipeGesture(sender: AnyObject) {
        showDate = Utils.nextDay(showDate)
        dayTitle.setTitle(Utils.getDay(showDate), forState: .Normal)
        industryCollectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let industryCalendarCell = collectionView.dequeueReusableCellWithReuseIdentifier("industryCalendarCell", forIndexPath: indexPath) as! IndustryCollectionViewCell
        let index = indexPath.row
        industryCalendarCell.industryLabel.text = ""
        switch index % 4 {
        case 0:
            industryCalendarCell.industryLabel.textColor = UIColor.blackColor()
            industryCalendarCell.industryLabel.text = getIndustryCount("黑业", timeIndex: index / 4)
        case 1:
            industryCalendarCell.industryLabel.textColor = UIColor.greenColor()
            industryCalendarCell.industryLabel.text = getIndustryCount("黑业对治", timeIndex: index / 4)
        case 2:
            industryCalendarCell.industryLabel.textColor = UIColor.whiteColor()
            industryCalendarCell.industryLabel.text = getIndustryCount("白业", timeIndex: index / 4)
        case 3:
            industryCalendarCell.industryLabel.textColor = UIColor.redColor()
            industryCalendarCell.industryLabel.text = getIndustryCount("白业对治", timeIndex: index / 4)
        default:
            break
        }
        return industryCalendarCell
    }
    
    func getIndustryCount(type: String, timeIndex: Int) -> String {
        var result = 0
        let dayRange = Utils.getDayRange(showDate)
        switch timeIndex {
        case 0:
            result = realm.objects(Industry).filter("type = %@ AND time BETWEEN {%@, %@}", type, dayRange[0] + 4 * hourDuration, dayRange[0] + 8 * hourDuration - 1).count
        case 1:
            result = realm.objects(Industry).filter("type = %@ AND time BETWEEN {%@, %@}", type, dayRange[0] + 8 * hourDuration, dayRange[0] + 10 * hourDuration - 1).count
        case 2:
            result = realm.objects(Industry).filter("type = %@ AND time BETWEEN {%@, %@}", type, dayRange[0] + 10 * hourDuration, dayRange[0] + 13 * hourDuration - 1).count
        case 3:
            result = realm.objects(Industry).filter("type = %@ AND time BETWEEN {%@, %@}", type, dayRange[0] + 13 * hourDuration, dayRange[0] + 17 * hourDuration - 1).count
        case 4:
            result = realm.objects(Industry).filter("type = %@ AND time BETWEEN {%@, %@}", type, dayRange[0] + 17 * hourDuration, dayRange[0] + 21 * hourDuration - 1).count
        case 5:
            result = realm.objects(Industry).filter("type = %@ AND (time BETWEEN {%@, %@} OR time BETWEEN {%@, %@})", type, dayRange[0] + 21 * hourDuration, dayRange[1], dayRange[0], dayRange[0] + 4 * hourDuration - 1).count
        default:
            break
        }
        if result == 0 {
            return ""
        } else {
            return String(result)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var type = ""
        let index = indexPath.row
        switch index % 4 {
        case 0:
            type = "黑业"
        case 1:
            type = "黑业对治"
        case 2:
            type = "白业"
        case 3:
            type = "白业对治"
        default:
            break
        }
        let industryCount = getIndustryCount(type, timeIndex: index / 4)
        if industryCount == "" {
            return
        }
        let industryContentDialogViewController = storyboard?.instantiateViewControllerWithIdentifier("IndustryContentDialogViewController") as! IndustryContentDialogViewController
        industryContentDialogViewController.industryType = type
        industryContentDialogViewController.showDate = showDate
        industryContentDialogViewController.initWithClosure(dismissViewClosure)
        presentViewController(industryContentDialogViewController, animated: true, completion: nil)
    }
    
    func dismissViewClosure(industryType: String, id: Int, isConfirm: Bool) {
        dismissViewControllerAnimated(true, completion: nil)
        if isConfirm {
            if (industryType == "黑业" || industryType == "白业") {
                let industryViewController = storyboard?.instantiateViewControllerWithIdentifier("IndustryViewController") as! IndustryViewController
                industryViewController.industryId = id
                navigationController?.pushViewController(industryViewController, animated: true)
            } else {
                let checkViewController = storyboard?.instantiateViewControllerWithIdentifier("CheckViewController") as! CheckViewController
                checkViewController.checkId = id
                navigationController?.pushViewController(checkViewController, animated: true)
            }
        }
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