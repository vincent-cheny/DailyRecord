//
//  RemindViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/4/29.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit
import RealmSwift

class RemindViewController: UIViewController {
    
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
    }
}
