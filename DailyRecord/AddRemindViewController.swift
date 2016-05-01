//
//  AddRemindViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/4/29.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit
import RealmSwift

class AddRemindViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    
    var remindId = 0
    let realm = try! Realm()
    var curRemind: Remind!
    var curComponents = NSDateComponents()
    var curRepeats = [false, false, false, false, false, false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        contentTextView.delegate = self
        contentTextView.textContainerInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        if remindId > 0 {
            curRemind = realm.objects(Remind).filter("id = %d", remindId).first
            enableSwitch.on = curRemind.enable
            contentTextView.text = curRemind.content
            curComponents.hour = curRemind.hour
            curComponents.minute = curRemind.minute
            repeatLabel.text = curRemind.getRepeatsDescription()
        } else {
            curComponents = NSCalendar.currentCalendar().components([.Hour, .Minute], fromDate: NSDate())
        }
        timeLabel.text = Utils.getHourAndMinute(curComponents)
        textViewDidEndEditing(contentTextView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        contentTextView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        contentTextView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        // 键盘弹起处理
        let frame: CGRect = textView.frame
        let offset: CGFloat = frame.origin.y - self.view.frame.size.height + 416
        if offset > 0  {
            self.view.frame = CGRectMake(0.0, -offset, self.view.frame.size.width, self.view.frame.size.height)
        }
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        // 键盘收起处理
        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        if textView.text == "" {
            textView.text = "标签"
            textView.textColor = UIColor.lightGrayColor()
        }
        textView.resignFirstResponder()
    }
    
    /// Force the text in a UITextView to always center itself.
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let textView = object as! UITextView
        var topCorrect = (textView.bounds.size.height - textView.contentSize.height * textView.zoomScale) / 2
        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect;
        textView.contentInset.top = topCorrect
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    @IBAction func confirm(sender: AnyObject) {
        let contentText = contentTextView.textColor == UIColor.lightGrayColor() ? "" : contentTextView.text
        if curRemind == nil {
            try! realm.write {
                let remind = Remind(value: [Remind().incrementaId(), enableSwitch.on, curComponents.hour, curComponents.minute, curRepeats[0], curRepeats[1], curRepeats[2], curRepeats[3], curRepeats[4], curRepeats[5], curRepeats[6], contentText])
                realm.add(remind)
            }
        } else {
            try! realm.write {
                curRemind.enable = enableSwitch.on
                curRemind.hour = curComponents.hour
                curRemind.minute = curComponents.minute
                curRemind.monday = curRepeats[0]
                curRemind.tuesday = curRepeats[1]
                curRemind.wednesday = curRepeats[2]
                curRemind.thursday = curRepeats[3]
                curRemind.friday = curRepeats[4]
                curRemind.saturday = curRepeats[5]
                curRemind.sunday = curRepeats[6]
                curRemind.content = contentText
            }
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func changeTime(sender: AnyObject) {
        DatePickerDialog().show("请选择时间", doneButtonTitle: "确定", cancelButtonTitle: "取消", defaultDate: NSCalendar.currentCalendar().dateFromComponents(curComponents)!, datePickerMode: .Time) {
            (date) -> Void in
            self.curComponents = NSCalendar.currentCalendar().components([.Hour, .Minute], fromDate: date)
            self.timeLabel.text = Utils.getHourAndMinute(self.curComponents)
        }
    }
    
    @IBAction func changeRepeat(sender: AnyObject) {
        let repeatDialogViewController = storyboard?.instantiateViewControllerWithIdentifier("RepeatDialogViewController") as! RepeatDialogViewController
        repeatDialogViewController.initWithClosure(repeatsViewClosure)
        repeatDialogViewController.curRepeats = curRepeats
        presentViewController(repeatDialogViewController, animated: true, completion: nil)
    }
    
    func repeatsViewClosure(repeats: [Bool], isConfirm: Bool) {
        dismissViewControllerAnimated(true, completion: nil)
        if isConfirm {
            curRepeats[0] = repeats[0]
            curRepeats[1] = repeats[1]
            curRepeats[2] = repeats[2]
            curRepeats[3] = repeats[3]
            curRepeats[4] = repeats[4]
            curRepeats[5] = repeats[5]
            curRepeats[6] = repeats[6]
            repeatLabel.text = Utils.getRepeatsDescription(curRepeats)
        }
    }
}