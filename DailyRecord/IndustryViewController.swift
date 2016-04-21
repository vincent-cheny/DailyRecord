//
//  IndustryViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/2/23.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit

class IndustryViewController: UIViewController, UITextViewDelegate {
    
    var industry = ""
    
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        titleButton.setTitle(industry, forState: .Normal)
        timeButton.setTitle(Utils.allInfoFromTime(NSDate()), forState: .Normal)
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
        templateViewController.templateFilter = titleButton.titleLabel!.text!
        navigationController?.pushViewController(templateViewController, animated: true)
    }
}