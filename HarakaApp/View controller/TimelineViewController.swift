//
//  TimelineViewController.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 15/02/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class TimelineViewController: UITableViewController {
    
    var posts:[Post]?
    var ref:  DatabaseReference!
    var postrefs: [DataSnapshot]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        
        ref = Database.database(url:"https://haraka-73619-default-rtdb.firebaseio.com/").reference()
        fetchPosts()
        tableView.reloadData()
        }
    
    override func viewDidAppear(_ animated: Bool) {
        self.ref.observe(.value, with: { snapshot in
            
            if snapshot.value == nil { print("nothing found") }
            
            else{
                if(snapshot.exists()){
                        
                    for child in snapshot.children.allObjects as! [DataSnapshot]{
                        guard let postDict = child.value as?[String:Any] else{ return }
                        let usern = postDict["username"] as? String ?? ""
                        let times = postDict["timestamp"] as? String ?? ""
                        let cap = postDict["caption"] as? String ?? ""
                        let nol = postDict["numOfLikes"] as? Int ?? 0
                        let noc = postDict["numOfComments"] as? Int ?? 0
                        let id = postDict["id"] as? String ?? ""
                        
                        let postUser = User(usernameUI: usern, profileImage: UIImage(named:"figure.walk.circle"))
                        let newPost = Post(createdBy: postUser, timeAgo: times, captionUI: cap, numOfLikesUI: nol, numOfCommentsUI: noc, postID: id)
                        self.posts?.append(newPost)
                        
                    } // End of loop
                } // End of If (snapshot.exists)
                    
            } // End of else
            
        })
        fetchPosts()
        tableView.reloadData()
    }
    
    func fetchPosts(){
        
        // retrieve posts from database, may return error or snapshot (snapshot contains data)
    //    print(self.ref.child("posts").description())
        self.ref.getData(completion: { error,snapshot in
            
            if let error = error { print("nothing found") }
            
            else{
                if(snapshot.exists()){
                        
                    for child in snapshot.children.allObjects as! [DataSnapshot]{
                        guard let postDict = child.value as?[String:Any] else{ return }
                        let usern = postDict["username"] as? String ?? ""
                        let times = postDict["timestamp"] as? String ?? ""
                        let cap = postDict["caption"] as? String ?? ""
                        let nol = postDict["numOfLikes"] as? Int ?? 0
                        let noc = postDict["numOfComments"] as? Int ?? 0
                        let id = postDict["id"] as? String ?? ""
                        
                        let postUser = User(usernameUI: usern, profileImage: UIImage(named:"figure.walk.circle"))
                        let newPost = Post(createdBy: postUser, timeAgo: times, captionUI: cap, numOfLikesUI: nol, numOfCommentsUI: noc, postID: id)
                        self.posts?.append(newPost)
                        
                    } // End of loop
                } // End of If (snapshot.exists)
                    
            } // End of else
            
        }) // End of retrieving function
        
        
    } // End of fetchPosts method
    
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
    
}

