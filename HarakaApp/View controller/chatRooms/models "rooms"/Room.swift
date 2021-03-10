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
    
    
    init(rId:String, rname:String , oId:String ){
        self.roomId=rId
        self.name=rname
        self.ownerId=oId
    }
    

    init(array: [String: Any]){
        if let roomName = array["name"] as? String, let ownerIdx = array["creatorId"] as? String{
            self.name = roomName
            self.ownerId = ownerIdx
        }
    }
}
