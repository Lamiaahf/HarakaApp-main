//
//  DBManager.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 02/04/2021.
//

import Firebase

class DBManager {
    
    let ref = Database.database().reference()
    
    func getUser(id: String) -> User {
        
        var user = User(u:"", p:UIImage())
        
        ref.child("users/\(id)").getData(completion: {
            error, snapshot in
            if let error = error { return }
            if snapshot.exists(){
                if let userDict = snapshot.value as? [String: Any] {
                    let username = userDict["Username"] as? String
                    let name = userDict["Name"] as? String
                    let email = userDict["Email"] as? String
                    let followingCount = userDict["followingCount"] as? Int
                    let profilepic = userDict["ProfilePic"] as? String
                    let dob = userDict["DOB"] as? String
                    
                    user = User(u: username, p: UIImage(contentsOfFile: profilepic!))
                }
            }
        })
        return user
        
    }
    
    func getTrainer(id: String) -> Trainer {
        
        var trainer = Trainer()
        
        return trainer
    }
    
}
