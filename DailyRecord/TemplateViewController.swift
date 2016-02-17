//
//  TemplateViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/2/12.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit
import RealmSwift

class TemplateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var templateFilterBtn: UIBarButtonItem!
    @IBOutlet weak var templateTableView: UITableView!
    
    let realm = try! Realm()
    var recordTemplates = try! Realm().objects(RecordTemplate)
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        templateTableView.delegate = self
        templateTableView.dataSource = self
        // 解决底部多余行问题
        templateTableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let templateCell = tableView.dequeueReusableCellWithIdentifier("templateCell", forIndexPath: indexPath)
        let template = recordTemplates[indexPath.row]
        let imageView = templateCell.viewWithTag(1) as! UIImageView
        switch template.type {
        case "黑业":
            imageView.image = UIImage(named: "blackdot")
        case "白业":
            imageView.image = UIImage(named: "whitedot")
        case "黑业对治":
            imageView.image = UIImage(named: "greendot")
        case "白业对治":
            imageView.image = UIImage(named: "reddot")
        default:
            break
        }
        templateCell.textLabel?.text = template.title
        // 解决左对齐问题
        templateCell.layoutMargins = UIEdgeInsetsZero
        return templateCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordTemplates.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 模拟闪动效果
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func templateFilter(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        filterData(alert, filter: "全部")
        filterData(alert, filter: "黑业")
        filterData(alert, filter: "黑业对治")
        filterData(alert, filter: "白业")
        filterData(alert, filter: "白业对治")
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func filterData(alert: UIAlertController, filter: String) {
        alert.addAction(UIAlertAction(title: filter, style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.templateFilterBtn.title = filter
            if filter == "全部" {
                self.recordTemplates = self.realm.objects(RecordTemplate)
            } else {
                self.recordTemplates = self.realm.objects(RecordTemplate).filter("type = %@", filter)
            }
            self.templateTableView.reloadData()
        }))
    }
}