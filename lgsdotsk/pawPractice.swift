//
//  pawPractice.swift
//  lgsdotsk
//
//  Created by Casey Colby on 12/15/16.
//  Copyright © 2016 ccolby. All rights reserved.
//

import UIKit

class PawPractice : UIViewController {
    
    let stim = Stimuli()
    let tag = 1
    
    func newPaw() {
        let newPaw = UIImageView()
        newPaw.image = UIImage(named: "paw.png")
        view.addSubview(newPaw)
        tag+=1
        
        let centerX = NSLayoutConstraint(item: newPaw, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let spaceY = NSLayoutConstraint(item: newPaw, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: , attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        
        view.addConstraints([centerX, spaceY])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let numPaws = stim.order.count
        for i in 1...numPaws {
            newPaw()
        }
        
    
    }
    
    
    
    
    
}
