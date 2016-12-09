//
//  JumpTrialVC.swift
//  lgsdotsk
//
//  Created by Casey Elizabeth Colby on 12/9/16.
//  Copyright © 2016 ccolby. All rights reserved.
//

import Foundation
import UIKit

class JumpTrialViewController : UIViewController {
    
    
    @IBOutlet weak var trialLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    var i : Int = 0
    
    @IBAction func stepperAdjusted(_ sender: UIStepper) {
        trialLabel.text = String(Int(sender.value))
        i = (Int(sender.value) - 1)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stepper.maximumValue = 10
        stepper.minimumValue = 1
        stepper.stepValue = 1
        stepper.wraps = true
        
        //initial value based on current trial
        stepper.value = Double(i+1)
        trialLabel.text = String(i+1)
    }

}
