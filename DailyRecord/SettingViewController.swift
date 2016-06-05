//
//  SettingViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/2/11.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit
import Realm

class SettingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false;
    }

    @IBAction func resetData(sender: AnyObject) {
        let alert = UIAlertController(title: "", message: "确认删除所有记录", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "确认", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            RecordTemplate().resetTemplate()
            Industry().resetIndustry()
            Remind().resetRemind()
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(true, forKey: Utils.needBlackCheck)
            defaults.setBool(false, forKey: Utils.needWhiteCheck)
            defaults.setBool(false, forKey: Utils.needDailySummary)
            defaults.setObject([20, 0], forKey: Utils.summaryTime)
            defaults.setInteger(4, forKey: Utils.timeSetting1)
            defaults.setInteger(8, forKey: Utils.timeSetting2)
            defaults.setInteger(10, forKey: Utils.timeSetting3)
            defaults.setInteger(13, forKey: Utils.timeSetting4)
            defaults.setInteger(17, forKey: Utils.timeSetting5)
            defaults.setInteger(21, forKey: Utils.timeSetting6)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
}