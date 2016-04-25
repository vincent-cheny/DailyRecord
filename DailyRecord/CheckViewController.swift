//
//  CheckViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/4/25.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit
import RealmSwift

class CheckViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var industryContentTextView: UITextView!
    @IBOutlet weak var checkContentTextView: UITextView!
    
    var curIndustry: Industry!
    var curCheck: Industry!
    var checkType = ""
    var industryId = 0
    var checkId = 0
    var saveAlert :UIAlertController!
    let realm = try! Realm()
    var showDate = NSDate()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        titleButton.setTitleColor(UIColor.blackColor(), forState: .Disabled)
        titleButton.enabled = false
        if checkId > 0 {
            curCheck = realm.objects(Industry).filter("id = %d", checkId).first
            titleButton.setTitle(curCheck.type, forState: .Normal)
            checkContentTextView.text = curCheck.content
            showDate = NSDate(timeIntervalSince1970: curCheck.time)
            industryId = curCheck.bind_id
            curIndustry = realm.objects(Industry).filter("id = %d", industryId).first
        } else {
            curIndustry = realm.objects(Industry).filter("id = %d", industryId).first
            if curIndustry.type == "黑业" {
                titleButton.setTitle("黑业对治", forState: .Normal)
            } else if curIndustry.type == "白业" {
                titleButton.setTitle("白业对治", forState: .Normal)
            }
        }
        industryContentTextView.textColor = UIColor.lightGrayColor()
        industryContentTextView.editable = false
        industryContentTextView.text = curIndustry.content
        timeButton.setTitle(Utils.allInfoFromTime(showDate), forState: .Normal)
        checkContentTextView.delegate = self
        textViewDidEndEditing(checkContentTextView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = "详细"
            textView.textColor = UIColor.lightGrayColor()
        }
        textView.resignFirstResponder()
    }
    
    @IBAction func changeTime(sender: AnyObject) {
        DatePickerDialog().show("时间设置", doneButtonTitle: "确定", cancelButtonTitle: "取消", datePickerMode: .DateAndTime) {
            (date) -> Void in
            self.showDate = date
            self.timeButton.setTitle(Utils.allInfoFromTime(self.showDate), forState: .Normal)
        }
    }
    
    @IBAction func chooseTemplate(sender: AnyObject) {
        let templateViewController = storyboard?.instantiateViewControllerWithIdentifier("TemplateViewController") as! TemplateViewController
        templateViewController.templateFilterBtn.title = titleButton.titleForState(.Normal)!
        templateViewController.initWithClosure(getValueClosure)
        navigationController?.pushViewController(templateViewController, animated: true)
    }
    
    func getValueClosure(type: String, content: String) {
        titleButton.setTitle(type, forState: .Normal)
        if content == "" {
            checkContentTextView.text = "详细"
            checkContentTextView.textColor = UIColor.lightGrayColor()
        } else {
            checkContentTextView.text = content
            checkContentTextView.textColor = UIColor.blackColor()
        }
    }
    
    @IBAction func saveTemplate(sender: AnyObject) {
        saveAlert = UIAlertController(title: "请输入名称", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        saveAlert.addTextFieldWithConfigurationHandler(nil)
        saveAlert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            try! self.realm.write {
                let contentText = self.checkContentTextView.textColor == UIColor.lightGrayColor() ? "" : self.checkContentTextView.text
                let template = RecordTemplate(value: [RecordTemplate().incrementaId(), self.saveAlert.textFields!.first!.text!, self.titleButton.titleForState(.Normal)!, contentText]);
                self.realm.add(template)
            }
        }))
        saveAlert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(saveAlert, animated: true, completion: nil)
    }
    
    @IBAction func addCheck(sender: AnyObject) {
        let contentText = checkContentTextView.textColor == UIColor.lightGrayColor() ? "" : checkContentTextView.text
        if curCheck == nil {
            try! realm.write {
                let id = Industry().incrementaId()
                curIndustry.bind_id = id
                let check = Industry(value: [id, titleButton.titleForState(.Normal)!, contentText, showDate.timeIntervalSince1970, industryId]);
                realm.add(check)
            }
        } else {
            try! realm.write {
                curCheck.type = titleButton.titleForState(.Normal)!
                curCheck.content = contentText
                curCheck.time = showDate.timeIntervalSince1970
            }
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
}
