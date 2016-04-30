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
    var repeats = [false, false, false, false, false, false, false]
    
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
            repeatLabel.text = curRemind.getRepeatDescription()
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
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
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
                let remind = Remind(value: [Remind().incrementaId(), enableSwitch.on, curComponents.hour, curComponents.minute, repeats[0], repeats[1], repeats[2], repeats[3], repeats[4], repeats[5], repeats[6], contentText])
                realm.add(remind)
            }
        } else {
            try! realm.write {
                curRemind.enable = enableSwitch.on
                curRemind.hour = curComponents.hour
                curRemind.minute = curComponents.minute
                curRemind.monday = repeats[0]
                curRemind.tuesday = repeats[1]
                curRemind.wednesday = repeats[2]
                curRemind.thursday = repeats[3]
                curRemind.friday = repeats[4]
                curRemind.saturday = repeats[5]
                curRemind.sunday = repeats[6]
                curRemind.content = contentTextView.text
            }
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
}