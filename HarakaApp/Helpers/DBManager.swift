//
//  DBManager.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 02/04/2021.
//

import Firebase
import FirebaseStorage

class DBManager {
    
    let ref = Database.database().reference()
    let storage = Storage.storage()
    
    
    static func getFollowing(for user: User, completion: @escaping ([User]) -> Void) {
        let userref = ref.child("following").child(user.uid)

        userref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }

            let users = snapshot.reversed().compactMap(User.init)
            completion(users)
        })
    }
    static func getPic(for user: User, completion: @escaping (UIImage) -> Void) {

        storage.reference(forURL: user.profileImageURL).getData(maxSize:1048576, completion:{
            data,error in
            guard let imageData = data, error == nil else{
                return completion(UIImage())
            }
            let pic = UIImage(data: imageData)
            completion(pic)
            
        })
    }
    
    static func getPosts(for user: User, completion: @escaping ([Post]) -> Void) {
        let postref = ref.child("posts").child(user.uid)

        postref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }

            let posts = snapshot.reversed().compactMap(Post.init)
            completion(posts)
        })
    }
    
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
