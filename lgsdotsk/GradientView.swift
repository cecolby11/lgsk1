//
//  GradientView.swift
//  lgsdotsk
//
//  Created by Casey Elizabeth Colby on 1/9/17.
//  Copyright © 2017 ccolby. All rights reserved.
//

import UIKit

@IBDesignable

class GradientView: UIView {

    @IBInspectable var darkColor: UIColor = UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1)
    @IBInspectable var lightColor: UIColor = UIColor(red: 223/255, green: 226/255, blue: 219/255, alpha: 1)
    
    override func draw(_ rect: CGRect) {
        
        let currentContext = UIGraphicsGetCurrentContext()
        
        let colors = [darkColor.cgColor, lightColor.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0,1.0]
        
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)
        
        let topLeft = CGPoint.zero
        let bottomLeft = CGPoint(x:0,y:self.bounds.height)
        
        
        currentContext?.drawLinearGradient(gradient!, start: topLeft, end: bottomLeft, options: [])
    }
}
