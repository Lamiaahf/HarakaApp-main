//
//  TimelineViewController.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 15/02/2021.
//

import UIKit
import Firebase

class TimelineViewController: UITableViewController {
    
    var posts:[Post]?
 //   var ref:  DatabaseReference!
 //   var ref = Database.database().reference()
    var postrefs: [DataSnapshot]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   fetchPosts()
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        
   //     ref = Database.database().reference()
        var ref:  DatabaseReference!
        ref = Database.database(url: "https://haraka-73619-default-rtdb.firebaseio.com/").reference()
        ref.child("posts").getData {(error, snapshot) in if let error = error {
            
        } else if snapshot.exists() {
            
            for child in snapshot.children{
                let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                let usern = postDict["username"] as? String ?? ""
                let times = postDict["timestamp"] as? String ?? ""
                let cap = postDict["caption"] as? String ?? ""
                let nol = postDict["numOfLikes"] as? Int ?? 0
                let noc = postDict["numOfComments"] as? Int ?? 0
                let id = postDict["id"] as? String ?? ""
                
                let postUser = User(usernameUI: usern, profileImage: UIImage(named:"figure.walk.circle"))
                let newPost = Post(createdBy: postUser, timeAgo: times, captionUI: cap, numOfLikesUI: nol, numOfCommentsUI: noc, postID: id)
                self.posts?.append(newPost)
            }
            self.tableView.reloadData()
            
        }else{
            
        }}
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    func setObservers(){

    }
    
}

extension TimelineViewController{
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = posts{
            return posts.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"PostCell", for: indexPath) as! PostCell
        cell.post = posts![indexPath.row]
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("your row number: \(indexPath.row)")
        
     //
        _ = tableView.cellForRow(at: indexPath)
        
    }
    
}

