//
//  RepeatDialogViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/4/30.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit

class RepeatDialogViewController: UIViewController {
    
    @IBOutlet weak var mondaySwitch: UISwitch!
    @IBOutlet weak var tuesdaySwitch: UISwitch!
    @IBOutlet weak var wednesdaySwitch: UISwitch!
    @IBOutlet weak var thursdaySwitch: UISwitch!
    @IBOutlet weak var fridaySwitch: UISwitch!
    @IBOutlet weak var saturdaySwitch: UISwitch!
    @IBOutlet weak var sundaySwitch: UISwitch!
    
    typealias sendRepeatsViewClosure = (repeats: [Bool], isConfirm: Bool)->Void
    var myClosure: sendRepeatsViewClosure?
    var curRepeats = [false, false, false, false, false, false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mondaySwitch.on = curRepeats[0]
        tuesdaySwitch.on = curRepeats[1]
        wednesdaySwitch.on = curRepeats[2]
        thursdaySwitch.on = curRepeats[3]
        fridaySwitch.on = curRepeats[4]
        saturdaySwitch.on = curRepeats[5]
        sundaySwitch.on = curRepeats[6]
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
    
    @IBAction func switchMonday(sender: UISwitch) {
        curRepeats[0] = sender.on
    }
    
    @IBAction func switchTuesday(sender: UISwitch) {
        curRepeats[1] = sender.on
    }
    
    @IBAction func switchWednesday(sender: UISwitch) {
        curRepeats[2] = sender.on
    }
    
    @IBAction func switchThursday(sender: UISwitch) {
        curRepeats[3] = sender.on
    }
    
    @IBAction func switchFriday(sender: UISwitch) {
        curRepeats[4] = sender.on
    }
    
    @IBAction func switchSaturday(sender: UISwitch) {
        curRepeats[5] = sender.on
    }
    
    @IBAction func switchSunday(sender: UISwitch) {
        curRepeats[6] = sender.on
    }
    
    @IBAction func confirm(sender: AnyObject) {
        if myClosure != nil {
            myClosure!(repeats: curRepeats, isConfirm: true)
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        if myClosure != nil {
            myClosure!(repeats: [Bool](), isConfirm: false)
        }
    }
    
}
