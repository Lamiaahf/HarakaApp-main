//
//  Challenge.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 07/03/2021.
//

import UIKit
import Firebase

@objc class Challenge: NSObject{
    
    
    var createdBy: Trainer?
    var enddate: Date?
    var cName: String?
    var cDesc: String?
    var chalID: String?
    
    override init(){
        super.init()
    }
    init?(snapshot: DataSnapshot) {
        guard let cDict = snapshot.value as? [String:Any],
        let createdBy = cDict["CreatorID"] as? String,
        let end = cDict["Deadline"] as? Date,
        let name = cDict["Name"] as? String,
        let desc = cDict["Description"] as? String else { return nil }

        self.chalID = snapshot.key
        self.cDesc = desc
        self.cName = name
        self.enddate = end
        self.createdBy = Trainer()
        
        DBManager.getTrainer(for: createdBy){
            trainer in
            self.createdBy = trainer
        }
        
    }


}


