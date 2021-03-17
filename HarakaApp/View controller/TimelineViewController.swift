//
//  TimelineViewController.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 15/02/2021.
//

import UIKit
import Firebase

class TimelineViewController: UITableViewController{
    
    var posts:[Post]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   fetchPosts()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    
/*    func fetchPosts(){
        
        posts = Post.fetchPosts()
        tableView.reloadData()
    }*/
 
    override func viewWillAppear(_ animated: Bool) {
        
        var timelinePosts = [Post]()
        timelinePosts.removeAll()
        self.posts?.removeAll()
        
        // create a variable referencing a collection from the database
        let postsCollectionRef = Firestore.firestore().collection("Posts")
        
        // get snapshot (contains documents), if not found will return error
        postsCollectionRef.getDocuments{ (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching documents: \(err)")
            }
            else{
                
                guard let snap = snapshot else { return }
                
                // enter loop for each document
                for document in snap.documents{
                    // get data inside document
                    let data = document.data()
                    // read fields 
                    let usern = data["username"] as? String ?? "Anon"
                    let times = data["timestamp"] as? Date ?? Date()
                    let cap = data["caption"] as? String ?? ""
                    let nol = data["numOfLikes"] as? Int ?? 0
                    let noc = data["numOfComments"] as? Int ?? 0
                  //  let docID = document.documentID
                    
                    let postUser = User(usernameUI: usern)
                    let newPost = Post(createdBy: postUser, timeAgo: times, captionUI: cap, numOfLikesUI: nol, numOfCommentsUI: noc)
                    timelinePosts.append(newPost)
                }
                self.posts = timelinePosts
                self.tableView.reloadData()
            }
        }
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

