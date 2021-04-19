//
//  RoomsCellTableViewCell.swift
//  HarakaApp
//
//  Created by ohoud on 01/09/1442 AH.
//

import UIKit
import Firebase
import FirebaseStorage

class RoomCell: UICollectionViewCell {

    @IBOutlet weak var EImage: UIImageView!
    @IBOutlet weak var creatorName: UILabel!
     
 var OBJRoom : Room! {
 didSet{
 updateRoom() }
    
 }
    func updatecell(){
    EImage.alpha=1
        //creatorName.text = Room.ownerId
}
    func updateRoom(){
        Storage.storage().reference(forURL: OBJRoom.EventImage!).getData(maxSize: 1048576, completion: { [self] (data, error) in

            guard let imageData = data, error == nil else {
                return
            }
            if (EImage != nil) {
                self.EImage.image = UIImage(data: imageData)}
            else {return}
            creatorName.text = OBJRoom.ownerName
            
        
        })
        }
}
