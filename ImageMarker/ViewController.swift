//
//  ViewController.swift
//  ImageMarker
//
//  Created by Yigang Zhou on 2020/1/15.
//  Copyright © 2020 Yigang Zhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate{

    var imageView = UIImageView()
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var vWidth = self.view.frame.width
        var vHeight = self.view.frame.height
        
        imageView = MyImageView(frame: CGRect(x: 0, y: 0, width: 1280, height: 720))
        imageView.image = UIImage(named: "pokemon")
        imageView.contentMode = .scaleAspectFit
    
        imageView.isUserInteractionEnabled = true
        
        var scrollImg: UIScrollView = UIScrollView()
        scrollImg.delegate = self
        scrollImg.frame = CGRect(x: 0, y: 0, width: vWidth, height: vHeight)
        scrollImg.backgroundColor = UIColor(red: 90, green: 90, blue: 90, alpha: 0.90)
        scrollImg.alwaysBounceVertical = false
        scrollImg.alwaysBounceHorizontal = false
        scrollImg.showsVerticalScrollIndicator = true
        scrollImg.flashScrollIndicators()
        scrollImg.contentSize = CGSize(width: 1280, height: 720)
        scrollImg.backgroundColor = UIColor.black

        scrollImg.minimumZoomScale = 0.1
        scrollImg.maximumZoomScale = 10.0
        

        self.view.addSubview(scrollImg)

        imageView.layer.cornerRadius = 11.0
        imageView.clipsToBounds = false
        scrollImg.addSubview(imageView)
        
        scrollImg.setZoomScale(0.5, animated: true)
        scrollImg.contentSize = CGSize(width: 0, height: 0)
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func touch(){
        
    }

     
   
    
    
   

}

