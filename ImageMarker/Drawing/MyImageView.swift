//
//  MyImageView.swift
//  ImageMarker
//
//  Created by Yigang Zhou on 2020/1/15.
//  Copyright © 2020 Yigang Zhou. All rights reserved.
//

import UIKit

class MyImageView: UIImageView {
    
    fileprivate var lastPoint = CGPoint.zero
    fileprivate var brushWidth: CGFloat = 5.0
    
    var currentLabelText = ""
    var shouldDraw = false
    var delegate:DrawingDelegate?
    
    fileprivate var xs = [CGFloat]()
    fileprivate var ys = [CGFloat]()
    fileprivate var labels = [UILabel]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if !shouldDraw{ return }
        
        if let touch = touches.first {
            
            if touch.type != .pencil {
                return
            }
            
            let lastPoint = touch.location(in: self)
            self.lastPoint = lastPoint
            xs.append(lastPoint.x)
            ys.append(lastPoint.y)
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    
        if !shouldDraw{ return }
     
        if let touch = touches.first {
            
            if touch.type != .pencil {
                return
            }
            
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
    
    fileprivate func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContext(self.image!.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        self.image?.draw(in: self.bounds)

        context.move(to: fromPoint)
        context.addLine(to: toPoint)
        

        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(brushWidth)
        context.setStrokeColor(UIColor.red.cgColor)

        context.strokePath()
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    

    fileprivate func removeLabels(){
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
        
        UIGraphicsBeginImageContext(self.image!.size)
        guard let context = UIGraphicsGetCurrentContext() else {
           return
        }
        self.image?.draw(in: self.bounds)
        
        for i  in 1...ps.count - 1{
            context.move(to: point)
            context.addLine(to: ps[i])
            context.setLineCap(.round)
            context.setBlendMode(.normal)
            context.setLineWidth(brushWidth)
            context.setStrokeColor(UIColor.red.cgColor)
            context.strokePath()
            point = ps[i]
            xs.append(ps[i].x)
            ys.append(ps[i].y)
        }
        
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
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
    
    fileprivate func drawLabel(at:CGPoint){
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
