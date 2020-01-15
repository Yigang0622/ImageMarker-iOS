//
//  ViewController.swift
//  ImageMarker
//
//  Created by Yigang Zhou on 2020/1/15.
//  Copyright © 2020 Yigang Zhou. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    var imageView = UIImageView()
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var toolBar: UIToolbar!
    var drawingBoard:DrawingBoardView!
    
    var pathManager = PathManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.rootController = self
        messageLabel.alpha = 0
    }
    
    func showMessage(msg:String){
        self.view.bringSubviewToFront(messageLabel)
        self.messageLabel.text = msg
        UIView.animate(withDuration: 0.2, animations: {
            self.messageLabel.alpha = 1
        }) { (complete) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                  UIView.animate(withDuration: 0.2, animations: {self.messageLabel.alpha = 0})
            })
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    fileprivate func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
              
            self.pathManager = PathManager()
            drawingBoard = DrawingBoardView()
            drawingBoard.pathManager = pathManager

            self.view.addSubview(drawingBoard)


            drawingBoard.snp.makeConstraints { (make) in
              make.top.equalTo(self.view)
              make.bottom.equalTo(toolBar.snp.top)
              make.left.equalTo(self.view)
              make.right.equalTo(self.view)
            }
              
            drawingBoard.initImageScrollView(image: pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
   
    @IBAction func newPathClicked(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Path Name", message: nil, preferredStyle: .alert)
 
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            let name = alertController.textFields?[0].text
            self.drawingBoard.newPath(name: name!)
        }
        
 
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
       
        alertController.addTextField { (textField) in
            textField.placeholder = "name"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
       
    }
    
    @IBAction func exportClicked(_ sender: Any) {
        let exportUrl = pathManager.export()
        let activityViewController = UIActivityViewController(activityItems: [exportUrl],                                                          applicationActivities: [])

        //For iPad
        if let popoverController = activityViewController.popoverPresentationController {
          popoverController.sourceView = self.view
          popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
          popoverController.permittedArrowDirections = []
        }

        self.present(activityViewController, animated: true)
    }
    
    @IBAction func removePathClick(_ sender: Any) {
        
        
        if pathManager.paths.count == 0 {
            return
        }
        
        
        let optionMenu = UIAlertController(title: nil, message: "Which path to remove?", preferredStyle: .actionSheet)
               
        let names = pathManager.getPathNames()
        for i in 0...pathManager.paths.count - 1{
            let action = UIAlertAction(title: names[i], style: .default) { (action) in
                self.drawingBoard.removePath(at:i)
            }
             optionMenu.addAction(action)
        }
        
        if let popoverController = optionMenu.popoverPresentationController {
                 popoverController.sourceView = self.view
                 popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                 popoverController.permittedArrowDirections = []
        }

       
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(cancelAction)
               
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    
    @IBAction func addClick(_ sender: Any) {
        openGallery()
    }
    
    
    @IBAction func closeClick(_ sender: Any) {
        drawingBoard.removeFromSuperview()
    }
    
    
}

