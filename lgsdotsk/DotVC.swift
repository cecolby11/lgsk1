//
//  DotViewController.swift
//  lgsdotsk
//
//  Created by Casey Colby on 10/20/16.
//  Copyright © 2016 ccolby. All rights reserved.
//

import UIKit
import RealmSwift

class DotViewController: UIViewController {

    @IBOutlet weak var dotDisplay: UIImageView!
    var i: Int = 0
    let stim = Stimuli()
    var baseTrial = Trial()
    var order = [UIImage]()
    var response = ""
    
    @IBOutlet weak var character1: UIButton!
    @IBOutlet weak var character2: UIButton!
    
    @IBOutlet weak var progressView: UIView!
    @IBOutlet var tapRec: UITapGestureRecognizer!
    
    @IBOutlet weak var leftPawButton: UIButton!
    @IBOutlet weak var rightPawButton: UIButton!
    
    //MARK: Experiment Setup
    
    func selectStimuli() {
        //shortened test version
        if baseTrial.subjectNumber == "s999" {
            order = stim.testorder
            baseTrial.order = 99
        } else {
        
            let indexLast = baseTrial.subjectNumber.index(before:baseTrial.subjectNumber.endIndex)
            let lastCh = baseTrial.subjectNumber[indexLast]//last character of subject number
            let evens : [Character] = ["0", "2", "4", "6", "8"]
        
            //Order det. by ODD/EVEN subj#
            if evens.contains(lastCh){
                order = stim.order1
                baseTrial.order = 1
            } else { //odds and default
                order = stim.order2
                baseTrial.order = 2
            }
        }
    }
    
    //Experiment Actions
    
    func wobbleButton(sender:UIButton) {
        //shrink
        sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        //bounce back to normal size
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform =
                            CGAffineTransform.identity}
            , completion: nil)
        sender.isEnabled = false
    }
    
    func nextImage() {
        i+=1
        print("i = \(i)") //to console
        NSLog("\n\n\ni=\(i), trial number:\(i+1)") //to aux file
        dotDisplay.image=order[i]
        character1.isEnabled = true
        character2.isEnabled = true
    }
    
    func endExperiment() {
        print("Experiment terminated successfully")
        self.performSegue(withIdentifier: "endExperiment", sender: self)
    }
    
    @IBAction func chooseCharacter(_ sender:UIButton) {
        wobbleButton(sender: sender)
        if i==order.count-1 {
            endExperiment()
        } else {
            //next image called when progressView is dismissed
            //show button which calls progress view
            switch sender{
                case character1:
                    response="A"
                    revealPawButton(button: leftPawButton)
                
                case character2:
                    response="B"
                    revealPawButton(button: rightPawButton)
                default:
                    response="NA"
            }
        }
    }
    
    
    //MARK: Progress Actions
    
    func revealPawButton(button: UIButton) {
        button.isEnabled = true
        button.isHidden = false
        pulseButton(button: button)
    }
    
    func hidePawButtons() {
        leftPawButton.isHidden = true
        rightPawButton.isHidden = true
    }
    
    @IBAction func showProgress() {
        writeTrialToRealm()
        view.viewWithTag(i+1)?.alpha = 1
        UIView.animate(withDuration: 0.5, animations: {self.progressView.alpha = 1})
    }
    
    @IBAction func tapToHideProgress(_ sender: UITapGestureRecognizer) {
        nextImage()
        hidePawButtons()
        UIView.animate(withDuration: 0.5, animations: {self.progressView.alpha = 0})
    }
    
    func pulseButton(button: UIButton) {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 1
        pulseAnimation.fromValue = 0.7
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.infinity
        button.layer.add(pulseAnimation, forKey: "layerAnimation")
    }

    
    //MARK: Realm
    
    func writeTrialToRealm() {

        let realm = try! Realm()
        
        try! realm.write {
            let newTrial = Trial()
            newTrial.subjectNumber = baseTrial.subjectNumber
            newTrial.condition = baseTrial.condition
            newTrial.order = baseTrial.order
            
            newTrial.trialNumber = i+1
            newTrial.response = response
            //newTrial.imageName = url.deletingPathExtension().lastPathComponent

            realm.add(newTrial)
        }
    }
    
    func preProcessData() {
        //TODO
    }
    

    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redirectLogToDocuments() //NSlog in aux file from this point forward
        
        selectStimuli()
        dotDisplay.image = order[i]

        progressView.alpha = 0
        leftPawButton.isHidden = true
        rightPawButton.isHidden = true
        
    }

    
    //MARK: Logging
    func redirectLogToDocuments() {
        
        let allPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = allPaths.first!
        let pathForLog = documentsDirectory.appending("/experimentLog.txt")
        
    }


    
    

}

