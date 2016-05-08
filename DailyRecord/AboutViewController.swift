//
//  AboutViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/2/13.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class AboutViewController: UIViewController, TTTAttributedLabelDelegate {
    
    @IBOutlet weak var link1: TTTAttributedLabel!
    @IBOutlet weak var link2: TTTAttributedLabel!
    @IBOutlet weak var link3: TTTAttributedLabel!
    @IBOutlet weak var link4: TTTAttributedLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        link1.enabledTextCheckingTypes = NSTextCheckingType.Link.rawValue
        link1.addLinkToURL(NSURL(string: link1.text!), withRange: NSRange(location: 0, length: (link1.text! as NSString).length))
        link1.delegate = self
        link2.enabledTextCheckingTypes = NSTextCheckingType.Link.rawValue
        link2.addLinkToURL(NSURL(string: link2.text!), withRange: NSRange(location: 0, length: (link2.text! as NSString).length))
        link2.delegate = self
        link3.enabledTextCheckingTypes = NSTextCheckingType.Link.rawValue
        link3.addLinkToURL(NSURL(string: link3.text!), withRange: NSRange(location: 0, length: (link3.text! as NSString).length))
        link3.delegate = self
        link4.enabledTextCheckingTypes = NSTextCheckingType.Link.rawValue
        link4.addLinkToURL(NSURL(string: link4.text!), withRange: NSRange(location: 0, length: (link4.text! as NSString).length))
        link4.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        webView.loadRequest(NSURLRequest(URL: url))
        self.view.addSubview(webView)
    }
}