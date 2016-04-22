//
//  CheckAndSumSettingViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/4/22.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit

class CheckAndSumSettingViewController: UIViewController {
    
    let needBlackCheck: String = "needBlackCheck"
    let needWhiteCheck: String = "needWhiteCheck"
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var blackSwitch: UISwitch!
    @IBOutlet weak var whiteSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if defaults.objectForKey(needBlackCheck) == nil {
            defaults.setBool(true, forKey: needBlackCheck)
        }
        if defaults.objectForKey(needWhiteCheck) == nil {
            defaults.setBool(false, forKey: needWhiteCheck)
        }
        blackSwitch.on = defaults.boolForKey(needBlackCheck)
        whiteSwitch.on = defaults.boolForKey(needWhiteCheck)
    }
    
    @IBAction func switchBlackCheck(sender: AnyObject) {
        defaults.setBool(blackSwitch.on, forKey: needBlackCheck)
    }
    
    @IBAction func switchWhiteCheck(sender: AnyObject) {
        defaults.setBool(whiteSwitch.on, forKey: needWhiteCheck)
    }
    
}