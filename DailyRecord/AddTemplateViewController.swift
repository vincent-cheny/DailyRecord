//
//  AddTemplateViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/2/18.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit
import RealmSwift

class AddTemplateViewController: UIViewController, UITextViewDelegate {
    
    var templateId = 0
    let realm = try! Realm()
    var curTemplate: RecordTemplate!
    
    @IBOutlet weak var templateTitle: UITextView!
    @IBOutlet weak var templateType: UIButton!
    @IBOutlet weak var templateContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if templateId != 0 {
            curTemplate = realm.objects(RecordTemplate).filter("id = %d", templateId).first
            templateTitle.text = curTemplate.title
            templateType.setTitle(curTemplate.type, forState: .Normal)
            templateContent.text = curTemplate.content
        } else {
            templateType.setTitle("黑业", forState: .Normal)
        }
        templateTitle.delegate = self;
        templateContent.delegate = self;
        textViewDidEndEditing(templateTitle);
        textViewDidEndEditing(templateContent);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        templateTitle.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        templateTitle.removeObserver(self, forKeyPath: "contentSize")
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
            if textView.restorationIdentifier == "TemplateTitle" {
                textView.text = "名称"
            } else if textView.restorationIdentifier == "TemplateContent" {
                textView.text = "详细"
            }
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    @IBAction func swithType(sender: AnyObject) {
        let alert = UIAlertController(title: "选择业习", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        addType(alert, type: "黑业")
        addType(alert, type: "黑业对治")
        addType(alert, type: "白业")
        addType(alert, type: "白业对治")
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func addType(alert: UIAlertController, type: String) {
        alert.addAction(UIAlertAction(title: type, style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.templateType.setTitle(type, forState: .Normal)
        }))
    }
    
    @IBAction func confirm(sender: AnyObject) {
        if templateTitle.textColor == UIColor.lightGrayColor() || templateTitle.text == "" {
            let alert = UIAlertController(title: "名称不能为空", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        let contentText = templateContent.textColor == UIColor.lightGrayColor() ? "" : templateContent.text
        if curTemplate == nil {
            try! realm.write {
                let template = RecordTemplate(value: [RecordTemplate().incrementaId(), templateTitle.text, templateType.titleForState(.Normal)!, contentText]);
                realm.add(template)
            }
        } else {
            try! realm.write {
                curTemplate.title = templateTitle.text
                curTemplate.type = templateType.titleForState(.Normal)!
                curTemplate.content = contentText
            }
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}