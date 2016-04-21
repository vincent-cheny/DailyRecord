//
//  CalendarViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/2/12.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var dayView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateDayView();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false;
    }
    
    func updateDayView() {
        for dayViewRow in dayView.subviews {
            for dayViewItem in dayViewRow.subviews {
                (dayViewItem as! UIButton).setTitle("ddd", forState: .Normal)
            }
        }
    }
}