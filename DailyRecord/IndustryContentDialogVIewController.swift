//
//  IndustryContentDialogVIewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/4/29.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit
import RealmSwift

class IndustryContentDialogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var industryContentTitle: UILabel!
    @IBOutlet weak var industryContentTableView: UITableView!
    
    typealias sendDismissViewClosure = (industryType: String, id: Int, isConfirm: Bool)->Void
    var myClosure: sendDismissViewClosure?
    
    let realm = try! Realm()
    var industryType = ""
    var industries: Results<Industry>!
    var showDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let dayRange = Utils.getDayRange(showDate)
        industries = try! Realm().objects(Industry).filter("type = %@ AND time BETWEEN {%@, %@}", industryType, dayRange[0], dayRange[1]).sorted("id")
        industryContentTitle.text = industryType
        industryContentTableView.delegate = self
        industryContentTableView.dataSource = self
        // 解决底部多余行问题
        industryContentTableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initWithClosure(closure: sendDismissViewClosure){
        myClosure = closure
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let industryContentCell = tableView.dequeueReusableCellWithIdentifier("industryContentCell", forIndexPath: indexPath)
        let industry = industries[indexPath.row]
        let content = industryContentCell.viewWithTag(1) as! UILabel
        content.text = industry.content
        // 解决左对齐问题
        industryContentCell.layoutMargins = UIEdgeInsetsZero
        return industryContentCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return industries.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 模拟闪动效果
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if myClosure != nil {
            myClosure!(industryType: industryType, id: industries[indexPath.row].id, isConfirm: true)
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        if myClosure != nil {
            myClosure!(industryType: "", id: 0, isConfirm: false)
        }
    }
}
