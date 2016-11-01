//
//  Circle.swift
//  circles
//
//  Created by Casey Colby on 9/24/16.
//  Copyright © 2016 Casey Colby. All rights reserved.
//

import UIKit
@IBDesignable

class Circle: UIView {
    
    
    var startRadius: CGFloat = CGFloat(100)
    @IBInspectable var red: UIColor = UIColor.red
    @IBInspectable var blue: UIColor = UIColor.blue
    var position : CGPoint = CGPoint(x:0, y:0)
    var redsBlues: [Int] = [1, 1, 1, 2, 2, 2, 2]
    var drawColor : UIColor!
    
    override func draw(_ rect: CGRect) {
        
        var radiusRatios: [CGFloat] = [1, 130/110, 110/90, 90/75, 75/60, 60/45, 45/30]
        position = CGPoint(x: 0, y: self.frame.height/2)
    
        
        for i in 0...(radiusRatios.count-1) {
            switch redsBlues[i] {
                case 1:
                    drawColor = red
                case 2:
                    drawColor = blue
                default:
                    drawColor = red
            }
            
            position.x += 2*startRadius
            startRadius /= radiusRatios[i]
            drawCircle(circleColor: drawColor!)
        }
    }
    
    func drawCircle(circleColor:UIColor) {
        
        let bezierPath = UIBezierPath(arcCenter: position, radius: startRadius, startAngle: CGFloat(0), endAngle: CGFloat(360*M_PI/180), clockwise: true)
        let circleLayer = CAShapeLayer()
        circleLayer.path = bezierPath.cgPath
        circleLayer.fillColor = circleColor.cgColor
        
        layer.addSublayer(circleLayer)
    }
    
    
}
