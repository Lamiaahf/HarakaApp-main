//
//  Post.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 15/02/2021.
//

import UIKit

struct Post
{
    var createdBy: User
    var timeAgo: String?
    var caption: String?
    var image: UIImage?
    var numOfLikes: Int?
    var numOfComments: Int?
    
    static func fetchPosts() -> [Post]
    {
        var posts = [Post]()
        
      
        let mark = User(username: "Mark Zuckerberg", profileImage: UIImage(named: "markzuck"))
        let steve = User(username: "Steve Jobs", profileImage: UIImage(named: "stevejobs"))
        let azeem = User(username: "Azeem Azeez", profileImage: UIImage(named: "azeem"))
        let jazz = User(username: "Jazz Bin", profileImage: UIImage(named: "jazz"))
        //
        let post1 = Post(createdBy: azeem, timeAgo: "1 hr", caption: "A Successfull man is one, who can lay a firm foundation with the bricks other have thrown at him.", image: UIImage(named: "1"), numOfLikes: 12, numOfComments: 32)
        let post2 = Post(createdBy: mark, timeAgo: "2 hrs", caption: "Try not to become a person of success, but rather try to become a person of value!", image: UIImage(named: "4"), numOfLikes: 8, numOfComments: 12)
        let post3 = Post(createdBy: azeem, timeAgo: "3 hrs", caption: "Stand in faith even when you are having the hardesr time of your life", image: UIImage(named: "2"), numOfLikes: 8, numOfComments: 92)
        let post4 = Post(createdBy: steve, timeAgo: "5 hrs", caption: "New iPhone 12 release - 2020", image: UIImage(named: "5"), numOfLikes: 94, numOfComments: 8)
        let post5 = Post(createdBy: azeem, timeAgo: "8 hrs", caption: "No matter how small you start, start something that matters. Believe in your dreams and begin.", image: UIImage(named: "3"), numOfLikes: 99, numOfComments: 83)
        let post6 = Post(createdBy: jazz, timeAgo: "Yesterday", caption: "Study and Work in Europe! | Work Permit", image: UIImage(named: "6"), numOfLikes: 9, numOfComments: 82)
        
        posts.append(post1)
        posts.append(post4)
        posts.append(post2)
        posts.append(post5)
        posts.append(post3)
        posts.append(post6)
        
        return posts
    }
}

struct User
{
    var username: String?
    var profileImage: UIImage?
}

