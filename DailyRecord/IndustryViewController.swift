//
//  IndustryViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/2/23.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit
import RealmSwift

class IndustryViewController: UIViewController, UITextViewDelegate {
    
    var industry = ""
    let realm = try! Realm()
    var saveAlert :UIAlertController!
    var showDate = NSDate()
    
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        titleButton.setTitle(industry, forState: .Normal)
        timeButton.setTitle(Utils.allInfoFromTime(showDate), forState: .Normal)
        contentTextView.delegate = self
        textViewDidEndEditing(contentTextView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false;
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
    
    @IBAction func swithType(sender: AnyObject) {
        let alert = UIAlertController(title: "选择业习", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        addType(alert, type: "黑业")
        addType(alert, type: "白业")
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func addType(alert: UIAlertController, type: String) {
        alert.addAction(UIAlertAction(title: type, style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.titleButton.setTitle(type, forState: .Normal)
        }))
    }
    
    @IBAction func changeTime(sender: AnyObject) {
        DatePickerDialog().show("时间设置", doneButtonTitle: "确定", cancelButtonTitle: "取消", datePickerMode: .DateAndTime) {
            (date) -> Void in
            self.timeButton.setTitle(Utils.allInfoFromTime(date), forState: .Normal)
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
        if (content == "") {
            contentTextView.text = "详细"
            contentTextView.textColor = UIColor.lightGrayColor()
        } else {
            contentTextView.text = content
            contentTextView.textColor = UIColor.blackColor()
        }
    }
    
    @IBAction func saveTemplate(sender: AnyObject) {
        saveAlert = UIAlertController(title: "请输入名称", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        saveAlert.addTextFieldWithConfigurationHandler(nil)
        saveAlert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            try! self.realm.write {
                let contentText = self.contentTextView.textColor == UIColor.lightGrayColor() ? "" : self.contentTextView.text
                let template = RecordTemplate(value: [RecordTemplate().incrementaId(), self.saveAlert.textFields!.first!.text!, self.titleButton.titleForState(.Normal)!, contentText]);
                self.realm.add(template)
            }
        }))
        saveAlert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(saveAlert, animated: true, completion: nil)
    }
    
    @IBAction func addIndustry(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if (defaults.boolForKey(Utils.needBlackCheck)) {
            let checkDialogViewController = storyboard?.instantiateViewControllerWithIdentifier("CheckDialogViewController") as! CheckDialogViewController
            presentViewController(checkDialogViewController, animated: true, completion: nil)
        } else {
            
        }
//        try! self.realm.write {
//            let contentText = self.contentTextView.textColor == UIColor.lightGrayColor() ? "" : self.contentTextView.text
//            let industry = Industry(value: [Industry().incrementaId(), self.titleButton.titleForState(.Normal)!, contentText, showDate.timeIntervalSince1970, 0]);
//            self.realm.add(industry)
//        }
//        navigationController?.popViewControllerAnimated(true)
    }
}