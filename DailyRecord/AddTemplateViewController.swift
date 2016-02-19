//
//  AddTemplateViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/2/18.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit

class AddTemplateViewController: UIViewController {
    
    var templateId : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if templateId != 0 {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirm(sender: AnyObject) {
        
    }
    
    @IBAction func cancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}