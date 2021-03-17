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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        
        posts = []
        fetchPosts()
   //     tableView.reloadData()
        }
    
    func fetchPosts(){
        
   //     var postArray:[Post] = []
   //     var indx = 0
        // retrieve posts from database, may return error or snapshot (snapshot contains data)
        let ref = Database.database().reference()
        ref.child("posts").observe(.childAdded){
        (snapshot) in
        if let postDict = snapshot.value as? [String: Any]{
            if let usern = postDict["username"] as? String {
                    let times = postDict["timestamp"] as? String ?? ""
                    let cap = postDict["caption"] as? String ?? ""
                    let nol = postDict["numOfLikes"] as? Int ?? 0
                    let noc = postDict["numOfComments"] as? Int ?? 0
                    let id = String(snapshot.key)
                    
                let postUser = User(u: usern, p: UIImage(systemName: "figure"))
                let newPost = Post(createdBy: postUser, timeAgo: times, captionUI: cap, numOfLikesUI: nol, numOfCommentsUI: noc, postID: id, liked:self.checkLike(postid: id))
             //       postArray.insert(newPost, at: indx)
                    self.posts?.append(newPost)
                  //  postArray.append(newPost)
                //    indx = indx+1
                    self.tableView.reloadData()
                
            }}
   //     self.posts = postArray
        
        }
    }
    
    func checkLike(postid: String) -> Bool {
        
        var uid = Auth.auth().currentUser?.uid
        var flag = false
        
        Database.database().reference().child("PostLikes").child(postid).queryOrdered(byChild: "uid").queryEqual(toValue: uid).getData(completion: {
            error, snapshot in
            if let error = error {return}
            if snapshot.exists() {
                flag = true
            }
        })
        return flag
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
    
}

