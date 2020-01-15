//
//  PathManager.swift
//  ImageMarker
//
//  Created by Yigang Zhou on 2020/1/15.
//  Copyright © 2020 Yigang Zhou. All rights reserved.
//

import UIKit
import SwiftyJSON

class PathManager: NSObject {
    
    var paths = Array<Path>()
    
    var currentPath:Path!
    
    var currntId = 1;
    
    func newPath(name:String){
        currentPath = Path(id:currntId, name: name)
        currntId += 1
    }
    
    func finishPath(){
        if currentPath.hasPoint() {
            paths.append(currentPath)
        }
    }
    
    func addPoint(point:CGPoint) {
        if currentPath == nil {
            print("You have not added a new path")
            return
        }
        currentPath.addPoint(point: point)
    }
    
    func removePath(at:Int){
        paths.remove(at: at)
    }
    
    func export() -> URL{
        print("Path count", paths.count)
        print(getJson().rawString()!)
        
        
        let file = "export.json"

        let text = getJson().rawString()!
        
        var url = URL.init(fileURLWithPath: "x")

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(file)
            url = fileURL
            //writing
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {/* error handling here */}
        }
        
        return url
        
        
    }
    
    func getPathNames() -> [String]{
        return paths.map { $0.name }
    }
    
    func getJson() -> JSON {
        var arr = [JSON]()
        for each in paths{
            arr.append(each.getJson())
        }
        return JSON(arr)
    }
    

}
