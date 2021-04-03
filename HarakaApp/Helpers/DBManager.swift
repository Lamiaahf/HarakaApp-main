//
//  DBManager.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 02/04/2021.
//

import Firebase

class DBManager {
    
    let ref = Database.database().reference()
    
    func getType(id: String) -> Int {
        
        var type = -1
        
        ref.child("users").queryOrderedByKey().queryEqual(toValue: id).getData(completion: {
            error, snapshot in
            if let error = error { print(error.localizedDescription); return}
            if snapshot.exists(){
                type = 0
            }
            else{ type = 1}
        })
        
        return type
    }
    
    func getUser(id: String) -> User {
        
        var user = User()
        ref.child("users/\(id)").observeSingleEvent(of: .value, with: {
            snapshot in
            if snapshot.exists(){
                if let userDict = snapshot.value as? [String: Any] {
                    let username = userDict["Username"] as? String
                    let name = userDict["Name"] as? String
                    let email = userDict["Email"] as? String
                    let followingCount = userDict["followingCount"] as? Int
                    let profilepic = userDict["ProfilePic"] as? String
                    let dob = userDict["DOB"] as? String
                    let uid = id
                    
                    user = User(username: username, profileimageurl: profilepic, name: name, email: email, followingCount: followingCount, DOB: dob, id: id)
                    
                }
            }
        })
        
        return user
        
    }
    
    func getTrainer(id: String) -> Trainer {
        
        var trainer = Trainer()
        

        ref.child("Trainers/Approved/\(id)").getData(completion: {
            error, snapshot in
            if let error = error { return }
            if snapshot.exists(){
                if let trainerDict = snapshot.value as? [String: Any] {
                    let username = trainerDict["Username"] as? String
                    let name = trainerDict["name"] as? String
                    let email = trainerDict["Email"] as? String
         //           let followerCount = trainerDict["followerCount"] as? Int
         //           let profilepic = trainerDict["ProfilePic"] as? String
                    let age = trainerDict["age"] as? Int
                    
                    trainer = Trainer(username: username, name: name, email: email, age: age)
                    
                }
            }
        })
        
        return trainer
    }
    
}
