//
//  CustomTabBar.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 3/31/23.
//

import UIKit

//@IBDesignable
class CustomTabBar: UITabBar {
    
    private var shapeLayer: CALayer?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
     */
    
    let designManager = ColorAndFontManager.shared
    
    
    //draws tab bar
    override func draw(_ rect: CGRect) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.fillColor = designManager.orange.cgColor
        shapeLayer.lineWidth = 1.0
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }

        self.shapeLayer = shapeLayer
    }

    
    //provides Path using Bezier
    func createPath() -> CGPath {

        let heightCurveStarts: CGFloat = 50
        let path = UIBezierPath()
        
        // Start from left side
        path.move(to: CGPoint(x: 0, y: heightCurveStarts))
        
        // Draw left curve
        path.addQuadCurve(to: CGPoint(x: heightCurveStarts, y: 0),
                          controlPoint: CGPoint(x: 0, y: 0))
        
        // Draw top line
        path.addLine(to: CGPoint(x: frame.width - heightCurveStarts, y: 0))
        
        // Draw right curve
        path.addQuadCurve(to: CGPoint(x: frame.width, y: heightCurveStarts),
                          controlPoint: CGPoint(x: frame.width, y: 0))
        
        // Draw bottom line
        path.addLine(to: CGPoint(x: frame.width, y: frame.height))
        
        // Draw left line
        path.addLine(to: CGPoint(x: 0, y: frame.height))
        
        return path.cgPath
    }
    
        
}
