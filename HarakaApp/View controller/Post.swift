//
//  Post.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 15/02/2021.
//

import UIKit
import Firebase

struct Post
{
    var createdBy: User
    var timeAgo: Date?
    var captionUI: String?
 //   var image: UIImage?
    var numOfLikesUI: Int?
    var numOfCommentsUI: Int?
    
   /*
    static func fetchPosts() -> [Post]
    {
        var posts = [Post]()
        
        let cf = Firestore.firestore().collection("Posts")
        cf.getDocuments{ (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching documents: \(err)")
            }
            else{
                guard let snap = snapshot else { return }
                for document in snap.documents{
                    let data = document.data()
                    let usern = data["username"] as? String ?? "Anon"
                    let times = data["timestamp"] as? Date ?? Date()
                    let cap = data["caption"] as? String ?? ""
                    let nol = data["numOfLikes"] as? Int ?? 0
                    let noc = data["numOfComments"] as? Int ?? 0
               //     let docID = document.documentID
                    
                    let postUser = User(usernameUI: usern)
                    let newPost = Post(createdBy: postUser, timeAgo: times, captionUI: cap, numOfLikesUI: nol, numOfCommentsUI: noc)
                    posts.append(newPost)
                }
                
            }
        }
        
        return posts
      /*
        let mark = User(usernameUI: "Mark Zuckerberg")
        let steve = User(usernameUI: "Steve Jobs")
        let azeem = User(usernameUI: "Azeem Azeez")
        let jazz = User(usernameUI: "Jazz Bin")
        //
        let post1 = Post(createdBy: azeem, timeAgo: "1 hr", captionUI: "A Successfull man is one, who can lay a firm foundation with the bricks other have thrown at him.", numOfLikesUI: 12, numOfCommentsUI: 32)
        let post2 = Post(createdBy: mark, timeAgo: "2 hrs", captionUI: "Try not to become a person of success, but rather try to become a person of value!", numOfLikesUI: 8, numOfCommentsUI: 12)
        let post3 = Post(createdBy: azeem, timeAgo: "3 hrs", captionUI: "Stand in faith even when you are having the hardesr time of your life", numOfLikesUI: 8, numOfCommentsUI: 92)
        let post4 = Post(createdBy: steve, timeAgo: "5 hrs", captionUI: "New iPhone 12 release - 2020", numOfLikesUI: 94, numOfCommentsUI: 8)
        let post5 = Post(createdBy: azeem, timeAgo: "8 hrs", captionUI: "No matter how small you start, start something that matters. Believe in your dreams and begin.", numOfLikesUI: 99, numOfCommentsUI: 83)
        let post6 = Post(createdBy: jazz, timeAgo: "Yesterday", captionUI: "Study and Work in Europe! | Work Permit", numOfLikesUI: 9, numOfCommentsUI: 82)
        
        posts.append(post1)
        posts.append(post4)
        posts.append(post2)
        posts.append(post5)
        posts.append(post3)
        posts.append(post6)
        */
        
    }*/
}

struct User
{
    var usernameUI: String?
 //   var profileImage: UIImage? 
    
}

