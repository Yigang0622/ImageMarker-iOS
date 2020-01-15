//
//  Path.swift
//  ImageMarker
//
//  Created by Yigang Zhou on 2020/1/15.
//  Copyright © 2020 Yigang Zhou. All rights reserved.
//

import UIKit
import SwiftyJSON

class Path: NSObject {
    
    var points = Array<CGPoint>()
    var id = -1;
    var name = "path"
    
    init(id:Int, name:String) {
        super.init()
        self.name = name
        self.id = id
    }
    
    func addPoint(point:CGPoint){
        points.append(point)
    }
    
    func hasPoint() -> Bool{
        return points.count != 0
    }
    
    func getJson() -> JSON {
        var arr = [JSON]()
        for each in points{
            var json: JSON =  ["x":each.x, "y": each.y]
            arr.append(json)
        }
        var json: JSON =  ["name":name, "id": id, "points":arr]
        return json
    }

}
