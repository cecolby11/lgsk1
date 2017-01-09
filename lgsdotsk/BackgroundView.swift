//
//  BackgroundView.swift
//  eventsk2
//
//  Created by Casey Colby on 5/28/16.
//  Copyright © 2016 Casey Colby. All rights reserved.
//

import UIKit

@IBDesignable

class BackgroundView: UIView {
    
    @IBInspectable var brightPurple: UIColor = UIColor(red: 194/255, green: 124/255, blue: 254/255, alpha: 1)
    
    override func draw(_ rect: CGRect) {
        
        
        let currentContext = UIGraphicsGetCurrentContext()
        
        let colors = [UIColor.white.cgColor, brightPurple.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0,0.6,1.0]
        
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)
        
        let topLeft = CGPoint.zero
        let bottomLeft = CGPoint(x:0,y:self.bounds.height)
        
        
        currentContext?.drawLinearGradient(gradient!, start: topLeft, end: bottomLeft, options: [])
    }
}
