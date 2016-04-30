//
//  RepeatDialogViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/4/30.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit
import RealmSwift

class RepeatDialogViewController: UIViewController {
    
    typealias sendRepeatsViewClosure = (repeats: [Bool], isConfirm: Bool)->Void
    var myClosure: sendRepeatsViewClosure?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initWithClosure(closure: sendRepeatsViewClosure){
        myClosure = closure
    }
}
