//
//  CheckAndSumSettingViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/4/22.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit

class CheckAndSumSettingViewController: UIViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var blackSwitch: UISwitch!
    @IBOutlet weak var whiteSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if defaults.objectForKey(Utils.needBlackCheck) == nil {
            defaults.setBool(true, forKey: Utils.needBlackCheck)
        }
        if defaults.objectForKey(Utils.needWhiteCheck) == nil {
            defaults.setBool(false, forKey: Utils.needWhiteCheck)
        }
        blackSwitch.on = defaults.boolForKey(Utils.needBlackCheck)
        whiteSwitch.on = defaults.boolForKey(Utils.needWhiteCheck)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func switchBlackCheck(sender: AnyObject) {
        defaults.setBool(blackSwitch.on, forKey: Utils.needBlackCheck)
    }
    
    @IBAction func switchWhiteCheck(sender: AnyObject) {
        defaults.setBool(whiteSwitch.on, forKey: Utils.needWhiteCheck)
    }
    
}