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
        let userref = Database.database().reference().child("following").child(user.userID!)

        userref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }

            let users = snapshot.reversed().compactMap(User.init)
            completion(users)
        })
    }
    static func getPic(for user: User, completion: @escaping (UIImage) -> Void) {

        Storage.storage().reference(forURL: user.profileImageURL!).getData(maxSize:1048576, completion:{
            data,error in
            guard let imageData = data, error == nil else{
                return completion(UIImage())
            }
            let pic = UIImage(data: imageData)
            completion(pic!)
            
        })
    }
    
    static func getComments(for post: Post, completion: @escaping ([Comment]) -> Void) {
        let commentref = Database.database().reference().child("Comments").queryOrderedByKey().queryEqual(toValue: post.postID)

        commentref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }

            let comments = snapshot.reversed().compactMap(Comment.init)
            completion(comments)
        })
    }
    
    static func getPosts(for user: User, completion: @escaping ([Post]) -> Void) {
        let postref = Database.database().reference().child("posts").queryOrdered(byChild: "uid").queryEqual(toValue: user.userID!)

        postref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }

            let posts = snapshot.reversed().compactMap(Post.init)
            completion(posts)
        })
    }
    
    static func getType(for id: String, completion: @escaping (Int) -> Void) {
        
        Database.database().reference().child("users").queryOrderedByKey().queryEqual(toValue: id).getData(completion: {
            error, snapshot in
            if let error = error { print(error.localizedDescription); return completion(-1)}
            if snapshot.exists(){
                completion(0)
            }
            else{ completion(1)}
        })
    }
    
    static func getUser(for id: String, completion: @escaping (User) -> Void) {
        
        var user = User()
        Database.database().reference().child("users/\(id)").observeSingleEvent(of: .value, with: {
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
                    completion(user)
                }
                else {completion(user)}
            }
        })
        
        
        
    }
    
    static func getTrainer(for id: String, completion: @escaping (Trainer) -> Void) {
        
        var trainer = Trainer()
        

        Database.database().reference().child("Trainers/Approved/\(id)").getData(completion: {
            error, snapshot in
            if let error = error { completion(trainer) }
            if snapshot.exists(){
                if let trainerDict = snapshot.value as? [String: Any] {
                    let username = trainerDict["Username"] as? String
                    let name = trainerDict["name"] as? String
                    let email = trainerDict["Email"] as? String
         //           let followerCount = trainerDict["followerCount"] as? Int
         //           let profilepic = trainerDict["ProfilePic"] as? String
                    let age = trainerDict["age"] as? Int
                    
                    trainer = Trainer(username: username, name: name, email: email, age: age)
                    completion(trainer)
                }
            }
        })
    
    }
    
}
