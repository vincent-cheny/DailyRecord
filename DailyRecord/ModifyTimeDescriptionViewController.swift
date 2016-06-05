//
//  ModifyTimeDescriptionViewController.swift
//  DailyRecord
//
//  Created by ChenYong on 16/5/29.
//  Copyright © 2016年 LazyPanda. All rights reserved.
//

import UIKit

class ModifyTimeDescriptionViewController: UIViewController {
    
    @IBOutlet weak var time1: UILabel!
    @IBOutlet weak var time2: UILabel!
    @IBOutlet weak var time3: UILabel!
    @IBOutlet weak var time4: UILabel!
    @IBOutlet weak var time5: UILabel!
    @IBOutlet weak var time6: UILabel!
    @IBOutlet weak var stepper1: UIStepper!
    @IBOutlet weak var stepper2: UIStepper!
    @IBOutlet weak var stepper3: UIStepper!
    @IBOutlet weak var stepper4: UIStepper!
    @IBOutlet weak var stepper5: UIStepper!
    @IBOutlet weak var stepper6: UIStepper!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        time1.text = String(defaults.integerForKey(Utils.timeSetting1)) + ":00"
        time2.text = String(defaults.integerForKey(Utils.timeSetting2)) + ":00"
        time3.text = String(defaults.integerForKey(Utils.timeSetting3)) + ":00"
        time4.text = String(defaults.integerForKey(Utils.timeSetting4)) + ":00"
        time5.text = String(defaults.integerForKey(Utils.timeSetting5)) + ":00"
        time6.text = String(defaults.integerForKey(Utils.timeSetting6)) + ":00"
        stepper1.value = Double(defaults.integerForKey(Utils.timeSetting1))
        stepper2.value = Double(defaults.integerForKey(Utils.timeSetting2))
        stepper3.value = Double(defaults.integerForKey(Utils.timeSetting3))
        stepper4.value = Double(defaults.integerForKey(Utils.timeSetting4))
        stepper5.value = Double(defaults.integerForKey(Utils.timeSetting5))
        stepper6.value = Double(defaults.integerForKey(Utils.timeSetting6))
        stepper1.minimumValue = 1
        stepper1.maximumValue = stepper2.value - 1
        stepper2.minimumValue = stepper1.value + 1
        stepper2.maximumValue = stepper3.value - 1
        stepper3.minimumValue = stepper2.value + 1
        stepper3.maximumValue = stepper4.value - 1
        stepper4.minimumValue = stepper3.value + 1
        stepper4.maximumValue = stepper5.value - 1
        stepper5.minimumValue = stepper4.value + 1
        stepper5.maximumValue = stepper6.value - 1
        stepper6.minimumValue = stepper5.value + 1
        stepper6.maximumValue = 24
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stepper1Changed(sender: UIStepper) {
        time1.text = String(Int(sender.value)) + ":00"
        defaults.setInteger(Int(sender.value), forKey: Utils.timeSetting1)
        stepper2.minimumValue = stepper1.value + 1
    }
    
    @IBAction func stepper2Changed(sender: UIStepper) {
        time2.text = String(Int(sender.value)) + ":00"
        defaults.setInteger(Int(sender.value), forKey: Utils.timeSetting2)
        stepper1.maximumValue = stepper2.value - 1
        stepper3.minimumValue = stepper2.value + 1
    }
    
    @IBAction func stepper3Changed(sender: UIStepper) {
        time3.text = String(Int(sender.value)) + ":00"
        defaults.setInteger(Int(sender.value), forKey: Utils.timeSetting3)
        stepper2.maximumValue = stepper3.value - 1
        stepper4.minimumValue = stepper3.value + 1
    }
    
    @IBAction func stepper4Changed(sender: UIStepper) {
        time4.text = String(Int(sender.value)) + ":00"
        defaults.setInteger(Int(sender.value), forKey: Utils.timeSetting4)
        stepper3.maximumValue = stepper4.value - 1
        stepper5.minimumValue = stepper4.value + 1
    }
    
    @IBAction func stepper5Changed(sender: UIStepper) {
        time5.text = String(Int(sender.value)) + ":00"
        defaults.setInteger(Int(sender.value), forKey: Utils.timeSetting5)
        stepper4.maximumValue = stepper5.value - 1
        stepper6.minimumValue = stepper5.value + 1
    }
    
    @IBAction func stepper6Changed(sender: UIStepper) {
        time6.text = String(Int(sender.value)) + ":00"
        defaults.setInteger(Int(sender.value), forKey: Utils.timeSetting6)
        stepper5.maximumValue = stepper6.value - 1
    }
    
}