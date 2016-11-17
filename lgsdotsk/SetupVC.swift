//
//  SetupViewController.swift
//  lgsdotsk
//
//  Created by Casey Colby on 11/1/16.
//  Copyright © 2016 ccolby. All rights reserved.
//

import UIKit
import RealmSwift

class SetupViewController: UIViewController{
    
    var trial: Trial = Trial()
    var saveAction: UIAlertAction!
    var cancelAction: UIAlertAction!
    
    
    //MARK: Actions
    
    func validateFields() -> Bool {
        if trial.subjectNumber.isEmpty || trial.condition.isEmpty {
            let alertController = UIAlertController(title: "Validation Error", message: "All fields must be filled", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.destructive) { alert in
                alertController.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }


    
    
}
