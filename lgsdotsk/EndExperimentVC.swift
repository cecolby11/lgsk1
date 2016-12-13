//
//  EndExperimentVC.swift
//  lgsdotsk
//
//  Created by Casey Colby on 11/4/16.
//  Copyright © 2016 ccolby. All rights reserved.
//

import UIKit

class EndExperimentViewController: UIViewController {
    
    @IBOutlet weak var happyPupsView: UIImageView!
    @IBOutlet var tapRec: UITapGestureRecognizer!
    var i = 4
    
    @IBAction func tapReceived(_ sender: UITapGestureRecognizer) {
        //get touch location
           let position :CGPoint = sender.location(in: view)
        //create and add pawPrint at touch
            let pawPrint = UIImageView()
            pawPrint.image = UIImage(named: "paw.png")
            pawPrint.frame = CGRect(x: position.x, y: position.y, width: 50, height: 50)
            self.view.addSubview(pawPrint)
        //for removal later
            i+=1
            pawPrint.tag = i
    }

    @IBAction func clearPawPrints(_ sender: UIButton) {
        for x in 4...i{
            let image = view.viewWithTag(x)
            image?.removeFromSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        happyPupsView.image = UIImage(named: "pupstogether.png")
    }
    
}
