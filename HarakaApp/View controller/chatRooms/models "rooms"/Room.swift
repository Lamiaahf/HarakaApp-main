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
    var EventImage:UIImageView?
  //  var ownerName: String?
    
        init(rId:String, rname:String,
             EImage:UIImageView)
             //,creatorN:String)
        {
        self.roomId=rId
        self.name=rname
        self.EventImage=EImage
       // self.ownerName=creatorN
    }
    

    init(array: [String: Any]){
        if let roomName = array["name"] as? String,
           let ownerIdx = array["creatorId"] as? String,
           let EventImages = array ["EventImage"] as? UIImageView
        {
         //  let creatorName = array["CreatorName"] as? String{
            self.name = roomName
            self.ownerId = ownerIdx
            self.EventImage = EventImages
           // self.ownerName = creatorName
        }
    }

}
