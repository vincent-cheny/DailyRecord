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
    let recordTemplates = try! Realm().objects(RecordTemplate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        templateTableView.delegate = self
        templateTableView.dataSource = self
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
        return templateCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordTemplates.count
    }
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let object = recordTemplates[indexPath.row]
//        cell.textLabel?.text = object.title
//        return cell
//    }
    
    @IBAction func templateFilter(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "全部", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.templateFilterBtn.title = "全部"
        }))
        alert.addAction(UIAlertAction(title: "黑业", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.templateFilterBtn.title = "黑业"
        }))
        alert.addAction(UIAlertAction(title: "黑业对治", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.templateFilterBtn.title = "黑业对治"
        }))
        alert.addAction(UIAlertAction(title: "白业", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.templateFilterBtn.title = "白业"
        }))
        alert.addAction(UIAlertAction(title: "白业对治", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.templateFilterBtn.title = "白业对治"
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}