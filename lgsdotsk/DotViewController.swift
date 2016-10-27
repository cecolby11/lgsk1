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
    
    
    
    //MARK: Actions
    
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
            nextImage()
        }
        
        switch sender{
            case character1:
                print("left guy")
            case character2:
                print("right guy")
            default:
                print("nothing")
        }
    }
    
    
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redirectLogToDocuments() //NSlog in aux file from this point forward
        
        dotDisplay.image = stim.order1[i]
    }

    
    
    //MARK: Logging
    func redirectLogToDocuments() {
        
        let allPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = allPaths.first!
        let pathForLog = documentsDirectory.appending("/experimentLog.txt")
        
        freopen(pathForLog.cString(using: String.Encoding.ascii)!, "a+", stderr)
    }


    
    

}

