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
    private var postsCollectionRef: CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postsCollectionRef = Firestore.firestore().collection("Posts")
        fetchPosts(cf: postsCollectionRef)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func fetchPosts(cf: CollectionReference){
        
        posts = Post.fetchPosts(cf: cf)
        tableView.reloadData()
    }
 
  /*  override func viewWillAppear(_ animated: Bool) {
        postsCollectionRef.getDocuments{ (snapshot, error) in
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
                    let docID = document.documentID
                    
                    let postUser = User(usernameUI: usern)
                    let newPost = Post(createdBy: usern, timeAgo: times, captionUI: cap, numOfLikesUI: nol, numOfCommentsUI: noc)
                    posts.append(newPost)
                }
                
            }
        }
    }*/
    
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

