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
    
    
    static func getFollowing(for user: String, completion: @escaping ([User]) -> Void) {
        let userref = Database.database().reference().child("following").child(user)

        userref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }


            
            let users = snapshot.reversed().compactMap(){
                snapsh in
                User.init(snapshot: snapsh, flag: true)
            }
            
            completion(users)
        })
    }
    
    static func getPic(for trainer: Trainer, completion: @escaping (UIImage) -> Void){
        Storage.storage().reference(forURL: trainer.profileImageURL!).getData(maxSize:1048576, completion:{
            data,error in
            guard let imageData = data, error == nil else{
                return completion(UIImage())
            }
            let pic = UIImage(data: imageData)
            completion(pic!)
            
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
    
    static func getPic(for id: String, completion: @escaping (UIImage) -> Void){
        
        Database.database().reference().child("users").queryOrderedByKey().queryEqual(toValue: id).observe(.childAdded, with:{
            snapshot in
            
            guard let dict = snapshot.value as? [String:Any] else {return completion(UIImage())}
            let url = dict["ProfilePic"] as? String
            
            Storage.storage().reference(forURL: url!).getData(maxSize:1048576, completion:{
                data,error in
                guard let imageData = data, error == nil else{
                    return completion(UIImage())
                }
                let pic = UIImage(data: imageData)
                completion(pic!)
                
            })
            
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
    
    static func isUserStarted(for ch: Challenge, completion: @escaping (Bool) -> Void){
        
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("ChallengeParticipants").child(ch.chalID!).queryOrderedByKey().queryEqual(toValue: uid).observe(.value, with: {
            snapshot in
            guard let currentTries = snapshot.value as? [String:Any] else {completion(false); return}
            
            for key in currentTries.keys {
                guard let dict = currentTries[key] as? [String:Any] else {completion(false); return}
                let s = dict["Score"] as? Double
                if dict["Score"] as? Double == 0 {completion(true); return}
                
            }
            completion(false)
        })
        
        
    }
    static func getChallenge(completion: @escaping (Challenge) -> Void) {
        let challref = Database.database().reference()
        var ch = Challenge()
        
        challref.child("Challenges").queryOrdered(byChild: "Deadline").queryLimited(toLast: 1).observeSingleEvent(of: .childAdded){
            (snapshot) in
            
            if snapshot.exists(){
                ch = Challenge(snapshot: snapshot)!
                completion(ch)
            }
            else{
                return completion(ch)
            }
            
            
        }
       // completion(ch)
    }
    
    static func getPosts(for user: User, completion: @escaping ([Post]) -> Void) {
        let postref = Database.database().reference().child("posts").queryOrdered(byChild: "uid").queryEqual(toValue: user.userID!)

        postref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return completion([])
            }

            let posts = snapshot.reversed().compactMap(){
                snapsh in
                Post.init(snapshot: snapsh, user:user)
            }
            
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
        Database.database().reference().child("users").child(id).observeSingleEvent(of: .value, with: {
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
                    
                   /* getPic(for: user){
                        pic in
                        user.profileImage = pic
                    }*/
                    completion(user)
                }
                else {completion(user)}
            }
        })
    }
    
    static func getTrainer(for id: String, completion: @escaping (Trainer) -> Void) {
        
        var trainer = Trainer()
        let tref =  Database.database().reference().child("Trainers/Approved/\(id)")
        tref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String:Any] else {
                return completion(Trainer())
            }
            let t = Trainer(snapshot: snapshot)
            completion(t!)
        })     
    
    }
    
}
