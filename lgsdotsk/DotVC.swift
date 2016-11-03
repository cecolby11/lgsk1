//
//  DotViewController.swift
//  lgsdotsk
//
//  Created by Casey Colby on 10/20/16.
//  Copyright © 2016 ccolby. All rights reserved.
//

import UIKit

class DotViewController: UIViewController {

    @IBOutlet weak var dotDisplay: UIImageView!
    var i: Int = 0
    let stim = Stimuli()
    
    @IBOutlet weak var character1: UIButton!
    @IBOutlet weak var character2: UIButton!
    
    @IBOutlet weak var progressView: UIView!
    @IBOutlet var tapRec: UITapGestureRecognizer!
    
    @IBOutlet weak var leftPawButton: UIButton!
    @IBOutlet weak var rightPawButton: UIButton!
    
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
        i+=1
        print("i = \(i)") //to console
        NSLog("\n\n\ni=\(i), trial number:\(i+1)") //to aux file
        dotDisplay.image=stim.order1[i]
        character1.isEnabled = true
        character2.isEnabled = true
    }
    
    func endExperiment() {
        print("Experiment terminated successfully")
        self.performSegue(withIdentifier: "endExperiment", sender: self)
    }
    
    @IBAction func chooseCharacter(_ sender:UIButton) {
        wobbleButton(sender: sender)
        if i==stim.order1.count-1 {
            endExperiment()
        } else {
            //next image called when progressView is dismissed
            //show button which calls progress view
            switch sender{
                case character1:
                    print("left guy")
                    revealPawButton(button: leftPawButton)
                case character2:
                    print("right guy")
                    revealPawButton(button: rightPawButton)
                default:
                    print("nothing")
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

    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redirectLogToDocuments() //NSlog in aux file from this point forward
        
        dotDisplay.image = stim.order1[i]

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

