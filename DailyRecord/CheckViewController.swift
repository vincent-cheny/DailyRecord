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
    
    var curCheck: Industry!
    var checkType = ""
    var checkId = 0
    let realm = try! Realm()
    var showDate = NSDate()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if checkId > 0 {
            curCheck = realm.objects(Industry).filter("id = %d", checkId).first
            titleButton.setTitle(curCheck.type, forState: .Normal)
            checkContentTextView.text = curCheck.content
            showDate = NSDate(timeIntervalSince1970: curCheck.time)
            titleButton.setTitleColor(UIColor.blackColor(), forState: .Disabled)
            titleButton.enabled = false
        } else {
//            titleButton.setTitle(industry, forState: .Normal)
        }
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
}
