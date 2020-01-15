//
//  MyImageView.swift
//  ImageMarker
//
//  Created by Yigang Zhou on 2020/1/15.
//  Copyright © 2020 Yigang Zhou. All rights reserved.
//

import UIKit

class MyImageView: UIImageView {
    
    
    var lastPoint = CGPoint.zero
    var brushWidth: CGFloat = 10.0

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            let lastPoint = touch.location(in: self)
            self.lastPoint = lastPoint
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
     
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            drawLine(from: lastPoint, to: currentPoint)
            lastPoint = currentPoint
        }
    }
    
  
    
    
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        // 1
        UIGraphicsBeginImageContext(self.image!.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        self.image?.draw(in: self.bounds)

        // 2
        context.move(to: fromPoint)
        context.addLine(to: toPoint)

        // 3
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(UIColor.red.cgColor)

        // 4
        context.strokePath()

        // 5
        self.image = UIGraphicsGetImageFromCurrentImageContext()
//        self.alpha = 1.0f
        UIGraphicsEndImageContext()
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touch Ended")
    }


}
