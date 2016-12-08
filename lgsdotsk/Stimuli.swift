//
//  Stimuli.swift
//  lgsdotsk
//
//  Created by Casey Colby on 10/20/16.
//  Copyright © 2016 ccolby. All rights reserved.
//

import Foundation
import UIKit

class Stimuli {
    
    //TODO: Get both conditions and orders
    
    var order : [NSObject] = []
    
    let order1 : [NSObject] = [
        Bundle.main.path(forResource: "Slide02", ofType: "png")! as NSObject,
        Bundle.main.path(forResource: "Slide03", ofType: "png")! as NSObject,
        Bundle.main.path(forResource: "Slide04", ofType: "png")! as NSObject,
        Bundle.main.path(forResource: "Slide05", ofType: "png")! as NSObject,
        Bundle.main.path(forResource: "Slide07", ofType: "png")! as NSObject,
        Bundle.main.path(forResource: "Slide08", ofType: "png")! as NSObject,
        Bundle.main.path(forResource: "Slide02", ofType: "png")! as NSObject,
        Bundle.main.path(forResource: "Slide03", ofType: "png")! as NSObject,
        Bundle.main.path(forResource: "Slide04", ofType: "png")! as NSObject
    ]
    
    let order2 : [NSObject] = [
        Bundle.main.path(forResource: "Slide08", ofType: "png")! as NSObject,
        Bundle.main.path(forResource: "Slide07", ofType: "png")! as NSObject,
        Bundle.main.path(forResource: "Slide05", ofType: "png")! as NSObject,
        Bundle.main.path(forResource: "Slide04", ofType: "png")! as NSObject,
        Bundle.main.path(forResource: "Slide03", ofType: "png")! as NSObject,
        Bundle.main.path(forResource: "Slide02", ofType: "png")! as NSObject,
        Bundle.main.path(forResource: "Slide08", ofType: "png")! as NSObject,
        Bundle.main.path(forResource: "Slide07", ofType: "png")! as NSObject,
        Bundle.main.path(forResource: "Slide06", ofType: "png")! as NSObject
    
    ]

    let orderT : [NSObject] = [
        Bundle.main.path(forResource: "Slide02", ofType: "png")! as NSObject,
        Bundle.main.path(forResource: "Slide03", ofType: "png")! as NSObject,
        Bundle.main.path(forResource: "Slide04", ofType: "png")! as NSObject
    ]
}

