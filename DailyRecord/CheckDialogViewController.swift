//
//  CheckDialogViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/4/22.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit
import RealmSwift

class CheckDialogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var checkTemplateTableView: UITableView!
    @IBOutlet weak var checkTextView: UITextView!
    
    typealias sendConfirmAndPopViewClosure = (checkContent: String, isConfirm: Bool)->Void
    var myClosure: sendConfirmAndPopViewClosure?
    
    var checkType = ""
    let realm = try! Realm()
    var checkTemplates: Results<RecordTemplate>!
    var industryId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        checkTextView.delegate = self;
        checkTemplates = try! Realm().objects(RecordTemplate).filter("type = %@", checkType).sorted("id")
        checkTemplateTableView.delegate = self
        checkTemplateTableView.dataSource = self
        // 解决底部多余行问题
        checkTemplateTableView.tableFooterView = UIView(frame: CGRectZero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initWithClosure(closure: sendConfirmAndPopViewClosure){
        myClosure = closure
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        // 键盘弹起处理
        let frame: CGRect = textView.frame
        let offset: CGFloat = frame.origin.y - self.view.frame.size.height + 416
        if offset > 0  {
            self.view.frame = CGRectMake(0.0, -offset, self.view.frame.size.width, self.view.frame.size.height)
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        // 键盘收起处理
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let checkTemplateCell = tableView.dequeueReusableCellWithIdentifier("checkTemplateCell", forIndexPath: indexPath)
        let checkTemplate = checkTemplates[indexPath.row]
        let imageView = checkTemplateCell.viewWithTag(1) as! UIImageView
        let title = checkTemplateCell.viewWithTag(2) as! UILabel
        let type = checkTemplateCell.viewWithTag(3) as! UILabel
        let content = checkTemplateCell.viewWithTag(4) as! UILabel
        title.text = checkTemplate.title
        type.text = checkTemplate.type
        content.text = checkTemplate.content
        switch checkTemplate.type {
        case "黑业对治":
            imageView.image = UIImage(named: "greendot")
            title.textColor = UIColor.greenColor()
            type.textColor = UIColor.greenColor()
        case "白业对治":
            imageView.image = UIImage(named: "reddot")
            title.textColor = UIColor.redColor()
            type.textColor = UIColor.redColor()
        default:
            break
        }
        // 解决左对齐问题
        checkTemplateCell.layoutMargins = UIEdgeInsetsZero
        return checkTemplateCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkTemplates.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 模拟闪动效果
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        checkTextView.text = checkTemplates[indexPath.row].content
    }
    
    @IBAction func confirm(sender: AnyObject) {
        if myClosure != nil {
            myClosure!(checkContent: checkTextView.text, isConfirm: true)
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        if myClosure != nil {
            myClosure!(checkContent: "", isConfirm: false)
        }
    }
    
}