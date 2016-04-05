//
//  ChartViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/2/12.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController {
    
    @IBOutlet weak var dateType: UIBarButtonItem!
    @IBOutlet weak var chartType: UIBarButtonItem!

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
    
    @IBAction func plusDate(sender: AnyObject) {
        
    }
    
    @IBAction func minusDate(sender: AnyObject) {
        
    }
    
    @IBAction func switchChartType(sender: AnyObject) {
        
    }
    
    @IBAction func switchDateType(sender: AnyObject) {
        
    }
}