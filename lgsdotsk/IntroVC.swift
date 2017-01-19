//
//  IntroViewController.swift
//  lgsdotsk
//
//  Created by Casey Colby on 11/1/16.
//  Copyright © 2016 ccolby. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class IntroViewController: UIViewController {

    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var containedViewRed: UIView!
    @IBOutlet weak var containedViewBlue: UIView!
    var tapIndex = 0
    @IBOutlet weak var instructionText: UILabel!
    
    @IBOutlet weak var pupAlone: UIImageView!
    @IBOutlet weak var redTestDot: UIImageView!
    @IBOutlet weak var blueTestDot: UIImageView!
    @IBOutlet weak var leftGreyReciever: UIImageView!
    @IBOutlet weak var rightGreyReceiver: UIImageView!
    
    @IBOutlet var redPan: UIPanGestureRecognizer!
    @IBOutlet var bluePan: UIPanGestureRecognizer!
    var snap: UISnapBehavior!
    var animator: UIDynamicAnimator!
    var collision: UICollisionBehavior!

    var trial = Trial()
    
    
    //MARK: Actions 
    
    @IBAction func tappedToContinue(_ sender: UITapGestureRecognizer) {
        tapIndex+=1
        
        switch tapIndex {
        case 1:
            UIView.animate(withDuration: 0.6, animations: {
                self.pupAlone.alpha = 1})
        case 2:
            UIView.animate(withDuration: 0.9, animations: {
            self.containedViewRed.alpha = 1})
        case 3:
            UIView.animate(withDuration: 0.9, animations: {
                self.containedViewBlue.alpha = 1})
        case 4:
            UIView.animate(withDuration: 0.7, animations: {
                self.containedViewBlue.alpha = 0
                self.containedViewRed.alpha = 0
                self.instructionText.isHidden = true
                self.pupAlone.isHidden = true
            })
            showTestDots()
        case _ where (tapIndex>=4 && rightGreyReceiver.center==blueTestDot.center && leftGreyReciever.center==redTestDot.center):
            self.performSegue(withIdentifier: "beginExperiment", sender: self)
            
        default:
            self.containedViewRed.alpha = 0
            self.containedViewBlue.alpha = 0
            self.view.alpha = 1
        }
        
    }
    
    
    func showTestDots() {
        redTestDot.isHidden = false
        blueTestDot.isHidden = false
        leftGreyReciever.isHidden = false
        rightGreyReceiver.isHidden = false
    }

   
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        sender.view?.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        if (rightGreyReceiver.frame.intersects(blueTestDot.frame)) {
            rightGreyReceiver.isHidden = true
            
            snap = UISnapBehavior(item: blueTestDot, snapTo: rightGreyReceiver.center)
            snap.damping = 0.1
            bluePan.isEnabled = false
            animator.addBehavior(snap)
            
        } else {
            rightGreyReceiver.isHidden = false
        }
        
        if (leftGreyReciever.frame.intersects(redTestDot.frame)){
            leftGreyReciever.isHidden = true
            
            snap = UISnapBehavior(item: redTestDot, snapTo: leftGreyReciever.center)
            snap.damping = 0.1 //oscillation
            redPan.isEnabled = false
            animator.addBehavior(snap)
            
        } else {
            leftGreyReciever.isHidden = false
        }

    }
    

    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containedViewRed.alpha = 0
        containedViewBlue.alpha = 0
        pupAlone.alpha = 0
        redTestDot.isHidden = true
        blueTestDot.isHidden = true
        leftGreyReciever.isHidden = true
        rightGreyReceiver.isHidden = true
        
        tapRecognizer.isEnabled = true
        tapRecognizer.numberOfTapsRequired = 2
        tapRecognizer.numberOfTouchesRequired = 2
        
        animator = UIDynamicAnimator(referenceView: view)

    }
    
    
    
    //MARK: Navigation
    
    override func prepare(for segue:UIStoryboardSegue, sender:Any?) {
        if let destination = segue.destination as? DotViewController {
            destination.baseTrial = self.trial
        }
        
    }
    
}

