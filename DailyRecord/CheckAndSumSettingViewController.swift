//
//  CheckAndSumSettingViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/4/22.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit

class CheckAndSumSettingViewController: UIViewController {
    
    @IBOutlet weak var blackSwitch: UISwitch!
    @IBOutlet weak var whiteSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        blackSwitch.on = true
        whiteSwitch.on = false
    }
    
    @IBAction func switchBlackCheck(sender: AnyObject) {
        if (blackSwitch.on) {
            
        }
    }
    
    @IBAction func switchWhiteCheck(sender: AnyObject) {
    }
    
}