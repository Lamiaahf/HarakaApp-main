//
//  Rooms.swift
//  HarakaApp
//
//  Created by ohoud on 22/07/1442 AH.
//

import UIKit


    struct Room {
        
    


    var roomId:String?
    var name:String?
    var ownerId:String?
    
        var EventImage:String?
    
    
        init(rId:String, rname:String,
        EImage:String){
        self.roomId=rId
        self.name=rname
        self.EventImage=EImage
    }
    

    init(array: [String: Any]){
        if let roomName = array["name"] as? String,
           let ownerIdx = array["creatorId"] as? String{
           let EventImages = array ["EventImage"] as? String
            self.name = roomName
            self.ownerId = ownerIdx
            //self.EventImage = EventImages
        }
    }

}
