//
//  RemindViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/4/29.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit
import RealmSwift

class RemindViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var remindTableView: UITableView!
    
    let realm = try! Realm()
    var reminds = try! Realm().objects(Remind).sorted("id")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        remindTableView.delegate = self
        remindTableView.dataSource = self
        // 解决底部多余行问题
        remindTableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        remindTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let remindCell = tableView.dequeueReusableCellWithIdentifier("remindCell", forIndexPath: indexPath) as! RemindTableViewCell
        let remind = reminds[indexPath.row]
        remindCell.remind = remind
        let remindSwitch = remindCell.remindSwitch
        let remindTime = remindCell.timeLabel
        let remindRepeat = remindCell.repeatLabel
        let components = NSDateComponents()
        components.hour = remind.hour
        components.minute = remind.minute
        remindRepeat.text = remind.getRepeatDescription()
        remindTime.text = Utils.getHourAndMinute(components)
        remindSwitch.on = remind.enable
        // 解决左对齐问题
        remindCell.layoutMargins = UIEdgeInsetsZero
        remindCell.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressCell(_:))))
        return remindCell
    }
    
    func longPressCell(recognizer: UIGestureRecognizer) {
        if recognizer.state == .Began {
            let indexPath = remindTableView.indexPathForRowAtPoint(recognizer.locationInView(remindTableView))
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "编辑", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                self.navigateRemind(indexPath!)
            }))
            alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(UIAlertAction(title: "删除", style: UIAlertActionStyle.Destructive, handler: { (UIAlertAction) -> Void in
                try! self.realm.write {
                    self.realm.delete(self.reminds[indexPath!.row])
                }
                self.remindTableView.reloadData()
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminds.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 模拟闪动效果
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        navigateRemind(indexPath)
    }
    
    func navigateRemind(indexPath: NSIndexPath) {
        let addRemindViewController = storyboard?.instantiateViewControllerWithIdentifier("AddRemindViewController") as! AddRemindViewController
        addRemindViewController.remindId = reminds[indexPath.row].id
        navigationController?.pushViewController(addRemindViewController, animated: true)
    }
}
