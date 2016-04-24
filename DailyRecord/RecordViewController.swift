//
//  RecordViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/4/24.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit
import RealmSwift

class RecordViewController: UIViewController {//, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dateFilterBtn: UIBarButtonItem!
    
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
    }
    
    @IBAction func search(sender: AnyObject) {
        DatePickerDialog().show("请选择查询日期", doneButtonTitle: "确定", cancelButtonTitle: "取消", datePickerMode: .Date) {
            (date) -> Void in

        }
    }
    
    @IBAction func filterDate(sender: AnyObject) {
    }
}