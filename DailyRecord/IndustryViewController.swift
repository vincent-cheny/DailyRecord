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
    
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var checkButton: UIBarButtonItem!
    
    typealias sendIndustryContentClosure = (content: String)->Void
    var myClosure: sendIndustryContentClosure?
    
    var industryType = ""
    var industryId = 0
    let realm = try! Realm()
    var saveAlert :UIAlertController!
    var showDate = NSDate()
    var curIndustry: Industry!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if industryId > 0 {
            curIndustry = realm.objects(Industry).filter("id = %d", industryId).first
            titleButton.setTitle(curIndustry.type, forState: .Normal)
            contentTextView.text = curIndustry.content
            showDate = NSDate(timeIntervalSince1970: curIndustry.time)
            titleButton.setTitleColor(UIColor.blackColor(), forState: .Disabled)
            titleButton.enabled = false
            checkButton.enabled = true
        } else {
            titleButton.setTitle(industryType, forState: .Normal)
        }
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
    
    func initWithClosure(closure: sendIndustryContentClosure){
        myClosure = closure
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
//        let defaults = NSUserDefaults.standardUserDefaults()
//        if defaults.boolForKey(Utils.needBlackCheck) {
//            let checkDialogViewController = storyboard?.instantiateViewControllerWithIdentifier("CheckDialogViewController") as! CheckDialogViewController
//            presentViewController(checkDialogViewController, animated: true, completion: nil)
//        } else {
//            
//        }
        let contentText = contentTextView.textColor == UIColor.lightGrayColor() ? "" : contentTextView.text
        if curIndustry == nil {
            try! realm.write {
                let industry = Industry(value: [Industry().incrementaId(), titleButton.titleForState(.Normal)!, contentText, showDate.timeIntervalSince1970, 0]);
                realm.add(industry)
            }
        } else {
            try! realm.write {
                curIndustry.type = titleButton.titleForState(.Normal)!
                curIndustry.content = contentText
                curIndustry.time = showDate.timeIntervalSince1970
            }
        }
        if myClosure != nil {
            myClosure!(content: curIndustry.content)
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func navigateCheck(sender: AnyObject) {
        let viewControllers = navigationController!.viewControllers
        let rootViewController = viewControllers[viewControllers.count - 2]
        if rootViewController is CheckViewController {
            navigationController?.popViewControllerAnimated(true)
        } else {
            let checkViewController = storyboard?.instantiateViewControllerWithIdentifier("CheckViewController") as! CheckViewController
            if curIndustry.bind_id > 0 {
                checkViewController.checkId = curIndustry.bind_id
            } else {
                checkViewController.industryId = curIndustry.id
            }
            navigationController?.pushViewController(checkViewController, animated: true)
        }
    }
}