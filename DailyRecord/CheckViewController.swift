//
//  CheckViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/2/23.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit

class CheckViewController: UIViewController {
    
    @IBOutlet weak var dateFilterBtn: UIBarButtonItem!
    @IBOutlet weak var typeFilterBtn: UIBarButtonItem!
    @IBOutlet weak var checkStateFilterBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false;
    }
    
    @IBAction func dateFilter(sender: AnyObject) {
        
    }
    
    @IBAction func typeFilter(sender: AnyObject) {
        
    }

    @IBAction func checkStateFilter(sender: AnyObject) {
        
    }
    
}