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
    var brushWidth: CGFloat = 5.0
    var delegate:DrawingDelegate?
    var shouldDraw = false
    var currentLabelText = ""
    
    var xs = [CGFloat]()
    var ys = [CGFloat]()
    var labels = [UILabel]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if !shouldDraw{
            return
        }
        
        if let touch = touches.first {
            let lastPoint = touch.location(in: self)
            self.lastPoint = lastPoint
            xs.append(lastPoint.x)
            ys.append(lastPoint.y)
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        if !shouldDraw{
            return
        }
     
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            drawLine(from: lastPoint, to: currentPoint)
            lastPoint = currentPoint
            xs.append(lastPoint.x)
            ys.append(lastPoint.y)
            
            if let delegate = delegate{
                delegate.newPoint(point: lastPoint)
            }
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
        UIGraphicsEndImageContext()
    }
    
    func removeLabels(){
        for each in labels{
            each.removeFromSuperview()
        }
    }
    
    func drawPath(ps:[CGPoint], label:String){
        var point:CGPoint = ps[0]
        
        var xs = [CGFloat]()
        var ys = [CGFloat]()
        
        xs.append(point.x)
        ys.append(point.y)
        
        for i  in 1...ps.count - 1{
            drawLine(from: point, to: ps[i])
            point = ps[i]
            xs.append(ps[i].x)
            ys.append(ps[i].y)
        }
        
        currentLabelText = label
        drawLabel(at: CGPoint(x: xs.min()!, y: ys.max()!+10))
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if !shouldDraw{
            return
        }
        
        if let delegate = delegate{
            delegate.pathDrawEnded()
        }
        
        drawLabel(at: CGPoint(x: xs.min()!, y: ys.max()!+10))
        xs.removeAll()
        ys.removeAll()
        
    }
    
    func drawLabel(at:CGPoint){
        let label = UILabel(frame: CGRect(x: at.x, y: at.y, width: 100, height: 25))
        label.text = currentLabelText
        label.backgroundColor = UIColor.red
        label.textColor = UIColor.white
        label.textAlignment = .center
        self.addSubview(label)
               labels.append(label)
    }


}

protocol DrawingDelegate {
    func newPoint(point:CGPoint)
    func pathDrawEnded()
}
