//
//  ViewController.swift
//  DailyRecord
//
//  Created by Mi on 23/8/15.
//  Copyright (c) 2015年 LazyPanda. All rights reserved.
//

import UIKit
import RealmSwift

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
        totalBlackLabel.text = String(realm.objects(Industry).filter("type = '黑业'").count)
        totalBlackCheckLabel.text = String(realm.objects(Industry).filter("type = '黑业对治'").count)
        totalWhiteLabel.text = String(realm.objects(Industry).filter("type = '白业'").count)
        totalWhiteCheckLabel.text = String(realm.objects(Industry).filter("type = '白业对治'").count)
        
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
    }
    
    @IBAction func navigateBlack(sender: AnyObject) {
        let industryViewController = storyboard?.instantiateViewControllerWithIdentifier("IndustryViewController") as! IndustryViewController
        industryViewController.industry = "黑业"
        navigationController?.pushViewController(industryViewController, animated: true)
    }
    
    @IBAction func navigateWhite(sender: AnyObject) {
        let industryViewController = storyboard?.instantiateViewControllerWithIdentifier("IndustryViewController") as! IndustryViewController
        industryViewController.industry = "白业"
        navigationController?.pushViewController(industryViewController, animated: true)
    }
    
    @IBAction func navigateBlackCheck(sender: AnyObject) {
        let checkViewController = storyboard?.instantiateViewControllerWithIdentifier("CheckViewController") as! CheckViewController
        navigationController?.pushViewController(checkViewController, animated: true)
    }
    
    @IBAction func navigateWhiteCheck(sender: AnyObject) {
        let checkViewController = storyboard?.instantiateViewControllerWithIdentifier("CheckViewController") as! CheckViewController
        navigationController?.pushViewController(checkViewController, animated: true)
    }
}

