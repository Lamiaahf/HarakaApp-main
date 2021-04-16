//
//  ActivityCell.swift
//  HarakaApp
//
//  Created by lamia on 08/04/2021.
//

import UIKit
import Firebase
import FirebaseStorage

class ActivityCell: UITableViewCell {
    
    let ref = Database.database().reference()
  //  var activitys: Activity!

    @IBOutlet weak var AName: UILabel!
    @IBOutlet weak var ALocation: UILabel!
    @IBOutlet weak var ADate: UILabel!
    @IBOutlet weak var ACreatedByName: UILabel!
    @IBOutlet weak var Actimage: UIImageView!



var  activi: Activity!{
    
    didSet{
        updateTimeline()
    }
}


func updateTimeline(){
    Storage.storage().reference(forURL: activi.AImage!).getData(maxSize: 1048576, completion: { [self] (data, error) in

        guard let imageData = data, error == nil else {
            return
        }
        self.AName.text = self.activi.Aname
        ALocation.text = self.activi.ALoca
        ADate.text = self.activi.ADateTime
        ACreatedByName.text = activi.createdByName
        Actimage.image = UIImage(data: imageData)

    })
}
  
}
