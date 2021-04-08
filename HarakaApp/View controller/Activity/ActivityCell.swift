//
//  ActivityCell.swift
//  HarakaApp
//
//  Created by lamia on 08/04/2021.
//

import UIKit
import Firebase

class ActivityCell: UITableViewCell {
    
    let ref = Database.database().reference()
    var activitys: Activity!

    @IBOutlet weak var AName: UILabel!
    @IBOutlet weak var ALocation: UILabel!
        
    @IBOutlet weak var ADate: UILabel!
    

    @IBOutlet weak var ACreatedByName: UILabel!
}
