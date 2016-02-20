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
    @IBOutlet weak var templateType: UILabel!
    @IBOutlet weak var templateContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if templateId != 0 {
            curTemplate = realm.objects(RecordTemplate).filter("id = %d", templateId).first
            templateTitle.text = curTemplate.title
            templateType.text = curTemplate.type
            templateContent.text = curTemplate.content
        }
        templateTitle.delegate = self;
        templateContent.delegate = self;
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
    
    @IBAction func confirm(sender: AnyObject) {
        if curTemplate == nil {
            
        } else {
            
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
}