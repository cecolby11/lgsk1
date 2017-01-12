//
//  DotViewController.swift
//  lgsdotsk
//
//  Created by Casey Colby on 10/20/16.
//  Copyright © 2016 ccolby. All rights reserved.
//

import UIKit
import GameplayKit //for fast and uniform shuffle
import RealmSwift

@IBDesignable

class DotViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var containerView: UIView!
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
    
    //progress variables
    var tag = 1
    var numberPaws : Int!
    var position : CGPoint!
    var offsetY : CGFloat = 50
    var randomX : Int = 0
    var isDotDisplayShowing = true
    
    //MARK: Experiment Setup
    
    func selectStimuli() { //by condition
        //3 trial short version for testing/development
        if baseTrial.subjectNumber == "s999" {
            if baseTrial.condition == "sg" {
                stim.shuffled = [stim.sgArr[0], stim.sgArr[1], stim.sgArr[2]]
            }
            if baseTrial.condition == "pl" {
               stim.shuffled = [stim.plArr[0], stim.plArr[1], stim.plArr[2]]
            }
        } else {
        //randomize order of full array of stimuli
            if baseTrial.condition == "sg" {
              stim.shuffled = stim.sgArr.randomized() as! [NSObject]
            }
            if baseTrial.condition == "pl" {
               stim.shuffled = stim.plArr.randomized() as! [NSObject]
            }
        }
    }
    
    
    //MARK: Paw Progress Setup
    
    func createPaw(offsetX: CGFloat, offsetY: CGFloat) {
        position.y = position.y + offsetY //update position Y, keep original position X and pick offset
        let pawView = UIImageView()
        pawView.image = UIImage(named: "paw.png")
        pawView.frame = CGRect(x:position.x + offsetX, y: position.y, width: CGFloat((14.0/Double(numberPaws))*50), height: CGFloat((14.0/Double(numberPaws))*50))
        pawView.alpha = 0.01
        pawView.tag = tag
        progressView.addSubview(pawView)
        tag+=1
    }

    func drawPaws() {
        offsetY = (self.progressView.frame.height - 80)/CGFloat(numberPaws)
        position = CGPoint(x:progressView.center.x, y:progressView.frame.maxY - 40)
        for i in 1...numberPaws {
            if tag % 2 == 0 {
                createPaw(offsetX: 8, offsetY: -offsetY)
            }
            else if tag % 3 == 0 {
                createPaw(offsetX: -7, offsetY: -offsetY)
            }
            else {
                createPaw(offsetX: -17, offsetY: -offsetY)
            }
        }
    }
    
    func dotDisplayFlip(){
        if (isDotDisplayShowing) {
            
            //hide Dots show Progress
            UIView.transition(from: dotDisplay,
                              to: progressView,
                                      duration: 1.2,
                                      options: [.transitionFlipFromLeft, .showHideTransitionViews],
                                      completion:nil)
            hidePawButtons()
            hideCharacters()
        } else {
            
            //show Dots show Progress
            UIView.transition(from: progressView,
                                      to: dotDisplay,
                                      duration: 1.2,
                                      options: [.transitionFlipFromRight, .showHideTransitionViews],
                                      completion: {finished in
                                        self.showCharacters()})
        }
        isDotDisplayShowing = !isDotDisplayShowing
    }
    
        func hidePawButtons() {
        leftPawButton.isHidden = true
        rightPawButton.isHidden = true
    }
    
    func hideCharacters() {
        character1.isHidden = true
        character2.isHidden = true
    }
    
    func showCharacters() {
        character1.isHidden = false
        character2.isHidden = false
    }
    
    
    
    //MARK: Experiment Actions
    
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
        if i==stim.shuffled.count-1 {
            endExperiment()
        } else {
            i+=1
            dotDisplay.image = UIImage(contentsOfFile: stim.shuffled[i] as! String)
            character1.isEnabled = true
            character2.isEnabled = true
            print("i=\(i)")
        }
    }
        
    
    func endExperiment() {
        NSLog("Experiment terminated successfully")
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
                    character2.isEnabled = false
                
                case character2:
                    response="B"
                    revealPawButton(button: rightPawButton)
                    character1.isEnabled = false
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
    

    @IBAction func showProgress() {
        writeTrialToRealm()
        for index in 1...i+1 {
            view.viewWithTag(index)?.alpha = 1
        }
        dotDisplayFlip()
        //UIView.animate(withDuration: 0.5, animations: {self.progressView.alpha = 1})
    }
    
    @IBAction func tapToHideProgress(_ sender: UITapGestureRecognizer) {
        if isDotDisplayShowing == false {
            nextImage()
            dotDisplayFlip()
        }
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
        
        let path = stim.shuffled[i]
        let url = NSURL.fileURL(withPath: path as! String)
        let fileName = url.deletingPathExtension().lastPathComponent

        NSLog("trial number \(i+1), \(fileName)") //to aux file
        NSLog("subject response : \(response)")

        let realm = try! Realm()
        
        try! realm.write {
            let newTrial = Trial()
            //common
            newTrial.subjectNumber = baseTrial.subjectNumber
            newTrial.condition = baseTrial.condition
            //trial-specific
            newTrial.trialNumber = i+1
            newTrial.response = response
            newTrial.imageName = fileName
            
            preprocessData(currentTrial: newTrial)
            
            realm.add(newTrial)
        }
    }
    
    func preprocessData(currentTrial: Trial) {
        //get imageType
        switch currentTrial.imageName {
        case "Slide02", "Slide03", "Slide04","Slide05":
            currentTrial.imageType = "AllT"
        case "Slide22", "Slide23", "Slide24","Slide25":
            currentTrial.imageType = "AllF"
        case "Slide17", "Slide18", "Slide19","Slide20":
            currentTrial.imageType = "ATWFlg"
        case "Slide12", "Slide13", "Slide14","Slide15":
            currentTrial.imageType = "ATWFsm"
        case "Slide27", "Slide28", "Slide29", "Slide30":
            currentTrial.imageType = "ATWFsm2"
        case "Slide07", "Slide08", "Slide09","Slide10":
            currentTrial.imageType = "ATWT"
        default: break
        }

        if baseTrial.condition == "pl" {
            //hypotheses predictions
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
                case "ATWFsm2":
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
            if response == currentTrial.strongpx {
                currentTrial.strongResp = 1
            }
            if response == currentTrial.weakpx {
                currentTrial.weakResp = 1
            }
            if response == currentTrial.averagepx {
                currentTrial.averageResp = 1
            }
            if response == currentTrial.X1biggestpx {
                currentTrial.X1biggestResp = 1
            }
        }
        
        if baseTrial.condition == "sg" {
            //correct answer
            switch currentTrial.imageName {
            case "Slide02", "Slide03", "Slide04", "Slide05", "Slide07", "Slide08", "Slide09", "Slide10", "Slide12", "Slide13", "Slide18", "Slide19", "Slide20", "Slide27", "Slide28":
                currentTrial.sgcorrectpx = "R"
            case "Slide14","Slide15","Slide17","Slide22","Slide23","Slide24","Slide25","Slide29","Slide30":
                currentTrial.sgcorrectpx = "B"
            default: break
            }
            
            //subject correct?
            if response == currentTrial.sgcorrectpx {
                currentTrial.sgcorrectResp = 1
            }
        }
    }
    
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redirectLogToDocuments() //NSlog in aux file from this point forward
        
        selectStimuli()
        character1.isExclusiveTouch = true
        character2.isExclusiveTouch = true
        
        dotDisplay.image = UIImage(contentsOfFile: stim.shuffled[i] as! String)

        //progressView.alpha = 0
        numberPaws = stim.shuffled.count
        drawPaws()
        leftPawButton.isHidden = true
        rightPawButton.isHidden = true
        
        dotDisplay.roundedCorners()
        progressView.roundedCorners()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        containerView.shadow()
    }

    //MARK: Logging
    func redirectLogToDocuments() {
        let allPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = allPaths.first!
        _ = documentsDirectory.appending("/experimentLog.txt")
        
    }


}

extension Array {
    func randomized() -> [Any] {
        let list = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: self)
        return list
    }
}


extension UIView {
    func roundedCorners() {
        self.layer.cornerRadius = 16.0
        self.clipsToBounds = true
    }
    
    func shadow(){
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5
    }
}

