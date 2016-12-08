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
            stim.order = stim.orderT
            baseTrial.order = 99
        } else {
        
            let indexLast = baseTrial.subjectNumber.index(before:baseTrial.subjectNumber.endIndex)
            let lastCh = baseTrial.subjectNumber[indexLast]//last character of subject number
            let evens : [Character] = ["0", "2", "4", "6", "8"]
        
            //Order det. by ODD/EVEN subj#
            if evens.contains(lastCh){
                stim.order = stim.order1
                baseTrial.order = 1
            } else { //odds and default
                stim.order = stim.order2
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
        if i==stim.order.count-1 {
            endExperiment()
        } else {
            i+=1
            dotDisplay.image = UIImage(contentsOfFile: stim.order[i] as! String)
            character1.isEnabled = true
            character2.isEnabled = true
        }
    }
        
    
    func endExperiment() {
        print("Experiment terminated successfully")
        self.performSegue(withIdentifier: "endExperiment", sender: self)
    }
    
    @IBAction func chooseCharacter(_ sender:UIButton) {
        wobbleButton(sender: sender)
            //next image called when progressView is dismissed
            //show button which calls progress view
            switch sender{
                case character1:
                    response="R"
                    revealPawButton(button: leftPawButton)
                
                case character2:
                    response="B"
                    revealPawButton(button: rightPawButton)
                default:
                    response="NA"
            }
    }
    
    
    //MARK: Game Actions
    
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
        
        let path = stim.order[i]
        let url = NSURL.fileURL(withPath: path as! String)
        let fileName = url.deletingPathExtension().lastPathComponent
        print(fileName)
        NSLog("trial number \(i+1), \(fileName)") //to aux file
        NSLog("subject response : \(response)")

        let realm = try! Realm()
        
        try! realm.write {
            let newTrial = Trial()
            //common
            newTrial.subjectNumber = baseTrial.subjectNumber
            newTrial.condition = baseTrial.condition
            newTrial.order = baseTrial.order
            //trial-specific
            newTrial.trialNumber = i+1
            newTrial.response = response
            newTrial.imageName = fileName
            
            preprocessData(currentTrial: newTrial)
            
            realm.add(newTrial)
        }
    }
    
    func preprocessData(currentTrial: Trial) {
        //imageType
        switch currentTrial.imageName {
        case "Slide02", "Slide03", "Slide04","Slide05":
            currentTrial.imageType = "AllT"
        case "Slide22", "Slide23", "Slide24","Slide25":
            currentTrial.imageType = "AllF"
        case "Slide17", "Slide18", "Slide19","Slide20":
            currentTrial.imageType = "ATWFlg"
        case "Slide12", "Slide13", "Slide14","Slide15":
            currentTrial.imageType = "ATWFsm"
        case "Slide07", "Slide08", "Slide09","Slide10":
            currentTrial.imageType = "ATWT"
        default: break
        }
        //hypotheses px
        switch currentTrial.imageType {
            case "AllT":
                currentTrial.strongpx = "R"
                currentTrial.weakpx = "R"
                currentTrial.averagepx = "R"
                currentTrial.X1biggestpx = "R"
            case "AllF":
                currentTrial.strongpx = "B"
                currentTrial.weakpx = "B"
                currentTrial.averagepx = "B"
                currentTrial.X1biggestpx = "B"
            case "ATWFlg":
                currentTrial.strongpx = "B"
                currentTrial.weakpx = "B"
                currentTrial.averagepx = "R"
                currentTrial.X1biggestpx = "B"
            case "ATWFsm":
                currentTrial.strongpx = "B"
                currentTrial.weakpx = "B"
                currentTrial.averagepx = "R"
                currentTrial.X1biggestpx = "R"
            case "ATWT":
                currentTrial.strongpx = "B"
                currentTrial.weakpx = "R"
                currentTrial.averagepx = "R"
                currentTrial.X1biggestpx = "R"
            default: break
        }
            //response consistent with hypotheses?
        switch response {
            case currentTrial.strongpx:
                currentTrial.strongResp = 1
            case currentTrial.weakpx:
                currentTrial.weakResp = 1
            case currentTrial.averagepx:
                currentTrial.averageResp = 1
            case currentTrial.X1biggestpx:
                currentTrial.X1biggestResp = 1
            default: break
        }
        
        
    }
    
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redirectLogToDocuments() //NSlog in aux file from this point forward
        
        selectStimuli()
        dotDisplay.image = UIImage(contentsOfFile: stim.order[i] as! String)

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

