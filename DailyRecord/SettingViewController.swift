//
//  SettingViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/2/11.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit

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
        self.navigationController?.navigationBarHidden = false;
    }
    
}