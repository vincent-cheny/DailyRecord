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
    var recordTemplates = try! Realm().objects(RecordTemplate).filter("type != ''")
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
        alert.addAction(UIAlertAction(title: "全部", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.templateFilterBtn.title = "全部"
            self.recordTemplates = self.realm.objects(RecordTemplate).filter("type != ''")
            self.templateTableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "黑业", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.templateFilterBtn.title = "黑业"
            self.recordTemplates = self.realm.objects(RecordTemplate).filter("type = '黑业'")
            self.templateTableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "黑业对治", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.templateFilterBtn.title = "黑业对治"
            self.recordTemplates = self.realm.objects(RecordTemplate).filter("type = '黑业对治'")
            self.templateTableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "白业", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.templateFilterBtn.title = "白业"
            self.recordTemplates = self.realm.objects(RecordTemplate).filter("type = '白业'")
            self.templateTableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "白业对治", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.templateFilterBtn.title = "白业对治"
            self.recordTemplates = self.realm.objects(RecordTemplate).filter("type = '白业对治'")
            self.templateTableView.reloadData()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}