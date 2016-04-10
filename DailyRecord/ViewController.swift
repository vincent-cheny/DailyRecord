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
        let today = NSDate()
        let todayDate = dateFormatter.stringFromDate(today)
        todayTime.text = todayDate
        dayTime.text = todayDate
        weekTime.text = Utils.getWeek(dateFormatter, date: today)
        monthTime.text = Utils.getMonth(dateFormatter, date: today)
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

