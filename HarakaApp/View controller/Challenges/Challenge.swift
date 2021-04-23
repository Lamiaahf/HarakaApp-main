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
    var enddate: String?
    var cName: String?
    var cDesc: String?
    var chalID: String?
    var challengeType: String?
     
    // To differentiate between user and trainer {0: User, 1: Trainer}
    var type: Int? //redesign this idea
    
    override init(){
        super.init()
    }
    init?(snapshot: DataSnapshot) {
        super.init()
        
        guard let cDict = snapshot.value as? [String:Any],
        let createdBy = cDict["CreatorID"] as? String,
        let end = cDict["Deadline"] as? String,
        let name = cDict["Name"] as? String,
        let desc = cDict["Description"] as? String else { return nil }
        let type = cDict["Type"] as? String

        self.chalID = snapshot.key
        self.cDesc = desc
        self.cName = name
        self.enddate = end
        self.createdBy = Trainer(tid: createdBy)
        self.challengeType = type
        
        
    }
    
    func isUserStarted() -> Bool {
        // DBManager(for: self) { boolean in self.isStarted = boolean}
        
        
        return false
    }


}


