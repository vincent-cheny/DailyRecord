//
//  RemindTableViewCell.swift
//  DailyRecord
//
//  Created by ChenYong on 16/4/30.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit
import RealmSwift

class RemindTableViewCell: UITableViewCell {
    
    @IBOutlet weak var remindSwitch: UISwitch!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    
    var remind: Remind!
    let realm = try! Realm()
    
    @IBAction func switchRemindEnable(sender: UISwitch) {
        try! realm.write {
            remind.enable = sender.on
        }
    }
    
}