//
//  DrawingBoardView.swift
//  ImageMarker
//
//  Created by Yigang Zhou on 2020/1/15.
//  Copyright © 2020 Yigang Zhou. All rights reserved.
//

import UIKit
import SnapKit

class DrawingBoardView: UIView,UIScrollViewDelegate,DrawingDelegate {

    var scrollImg: UIScrollView = UIScrollView()
    var imageView:MyImageView!
    var imageSize:CGSize!
    var image:UIImage!
    var shouldZoom = true
    var currentContentOffset = CGPoint(x: 0, y: 0)
    var currentContentInset = UIEdgeInsets.zero
    
    var pathManager:PathManager?
    var zoomScale = CGFloat(1)
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init")
   
    }
    
    func initImageScrollView(image:UIImage)  {
        
        self.imageSize = image.size
        self.image = image
        
        self.addSubview(scrollImg)
        scrollImg.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        scrollImg.delegate = self
        scrollImg.backgroundColor = UIColor.lightGray
        scrollImg.alwaysBounceVertical = false
        scrollImg.alwaysBounceHorizontal = false
        scrollImg.showsVerticalScrollIndicator = true
        scrollImg.flashScrollIndicators()
        scrollImg.contentSize = imageSize
        scrollImg.minimumZoomScale = 0.1
        scrollImg.maximumZoomScale = 10.0
        
        reloadImageView()

        scrollImg.setZoomScale(0.5, animated: true)

    }
    
    func reloadImageView(){
        if imageView != nil {
             imageView.removeFromSuperview()
        }
       
        imageView = MyImageView(frame: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.delegate = self

        imageView.clipsToBounds = false
        scrollImg.addSubview(imageView)
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if shouldZoom{
            return imageView
        }else{
            return nil
        }
     }
    
    func removePath(at:Int){
        appDelegate.rootController!.showMessage(msg: "路径"+(pathManager?.paths[at].name)!+"已删除")
        pathManager?.paths.remove(at: at)
        reloadImageView()
        for each in pathManager!.paths{
            imageView.drawPath(ps: each.points, label: each.name)
        }
        scrollImg.setZoomScale(zoomScale, animated: false)
    }
     
    
    func newPoint(point: CGPoint) {
        pathManager?.addPoint(point: point)
    }
    
    func pathDrawEnded(){
        appDelegate.rootController!.showMessage(msg: "路径已保存")
        pathManager?.finishPath()
        shouldZoom = true
        imageView.shouldDraw = false
        scrollImg.isScrollEnabled = true
 
    }
    
    func newPath(name:String){
        print("new path",name)
         appDelegate.rootController!.showMessage(msg: "缩放已锁定\n请开始绘制路径"+name)
        pathManager?.newPath(name: name)
        scrollImg.contentOffset = currentContentOffset
        shouldZoom = false
        imageView.shouldDraw = true
        imageView.currentLabelText = name
        scrollImg.isScrollEnabled = false
        
 
//        scrollImg.contentSize = CGSize.zero
 
        
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        zoomScale = scrollView.zoomScale
     
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentContentOffset = scrollImg.contentOffset
        currentContentInset = scrollImg.contentInset
   
//        if !shouldZoom {
//            scrollImg.contentOffset = currentContentOffset
//        }else{
//            currentContentOffset = scrollImg.contentOffset
//        }
    }
//
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
