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
    
    var alertController : UIAlertController!
    let brightGreen: UIColor = UIColor(red: 195/255, green:247/255, blue: 165/255, alpha:1)
    let brightPurple: UIColor = UIColor(red: 194/255, green: 124/255, blue: 254/255, alpha: 1)
    let darkColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
    let lightColor = UIColor(red: 223/255, green: 226/255, blue: 219/255, alpha: 1)
    
    
    //MARK: Actions
    
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
    
    @IBAction func clearPawPrintsTapped(_ sender: Any) {
        for x in 4...i{
            let image = view.viewWithTag(x)
            image?.removeFromSuperview()
        }
    }
    
    func showAlert(){
        //initialize controller
        alertController = UIAlertController(title: "Are you sure?", message: "Select 'Continue' to start a new experiment", preferredStyle: .alert)
        alertController.view.tintColor = self.darkColor
        
        
        //initialize actions
        let continueAction = UIAlertAction(title: "Continue", style: .default, handler: {action in
            self.performSegue(withIdentifier: "unwindToSetupVC", sender: self) //when save button pressed
        })
        
        //add actions
        alertController.addAction(continueAction)
        
        //present alert controller
        self.present(alertController, animated: true, completion: nil)
    }
    

    
    
    //MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        happyPupsView.image = UIImage(named: "pupstogether.png")
        UIView.animate(withDuration: 0.5, delay: 6.0, options: [], animations: {
            self.happyPupsView.loadGif(name: "pupstogether2")
        }, completion: nil)
    }
    
    
    //MARK: Navigation
    
    @IBAction func newSubjectTapped(_ sender: UIBarButtonItem) {
        showAlert()
    }
    
}
