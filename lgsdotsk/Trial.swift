//
//  Trial.swift
//  lgsdotsk
//
//  Created by Casey Colby on 11/10/16.
//  Copyright © 2016 ccolby. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Trial: Object {
    
    dynamic var subjectNumber = ""
    dynamic var condition = ""
    dynamic var order = 1 //odd/default (1), even(2)
    dynamic var created = NSDate()
    dynamic var trialNumber = 1
    
    dynamic var response = ""
    
    dynamic var strongWin = ""
    dynamic var weakWin = ""
    dynamic var averageWin = ""
    dynamic var X1biggestWin = ""
    dynamic var X2biggestWin = ""
    
    dynamic var strongResp = 0
    dynamic var weakResp = 0
    dynamic var averageResp = 0
    dynamic var X1biggestResp = 0
    dynamic var X2biggestResp = 0
}
