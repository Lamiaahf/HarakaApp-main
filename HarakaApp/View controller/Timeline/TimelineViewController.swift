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
    let ref: DatabaseReference = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        
        posts = []
        getPosts()
      //  fetchPosts()
        }
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func getPosts(){
        
        let current = User(Auth.auth().currentUser?.uid)
        
        DBManager.getPosts(for: current) { (posts) in
            for p in posts{ self.posts?.append(p)}
        }
        
        DBManager.getFollowing(for: current){
            (users) in
            for u in users{
                DBManager.getPosts(for: u){
                    for p in posts{
                        self.posts?.append(p)
                    }
                }
            }
        }
        
        self.tableView.reloadData()
    }

    func fetchPosts(){

        // retrieve posts from database, may return error or snapshot (snapshot contains data)

        ref.child("posts").observe(.childAdded){
        (snapshot) in
            if snapshot.exists(){
                if let postDict = snapshot.value as? [String: Any]{
                    if let uid = postDict["uid"] as? String{
                            let cap = postDict["caption"] as? String ?? ""
                            let times = postDict["timestamp"] as? String ?? ""
                            let nol = postDict["numOfLikes"] as? Int ?? 0
                            let noc = postDict["numOfComments"] as? Int ?? 0
                            let id = String(snapshot.key)
                        
                        //Get user from uid and store it inside the post object
                        let postUser = User(id:uid)
                        let newPost = Post(createdBy: postUser, timeAgo: times, caption: cap, numOfLikes: nol, numOfComments: noc, postID: id, liked:false)
                        
                        //Check for liked posts
                        self.checkLike(post: newPost)
                        self.posts?.append(newPost)
                        self.tableView.reloadData()
                        
                    }}
            }
    

        }
    }
    
    
     func checkLike(post: Post){
        
        //Get uid to check posts current user has liked
        let uid = Auth.auth().currentUser?.uid
        
        let ref = Database.database().reference()
        ref.child("PostLikes").child(post.postID!).observe(.childAdded){
            (snapshot) in
            if(snapshot.exists()){
                if let postDict = snapshot.value as? [String: Any]{
                    if(postDict.keys.contains(uid!)){
                        post.setLiked(flag: true)
                        self.tableView.reloadData()
                        }
                }
            }
        }
     }
    
    
    @IBAction func openComments(_ sender: UIButton) {
        self.performSegue(withIdentifier: "commentSegue", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "commentSegue") {
            if let destination = segue.destination as? CommentViewController {

               if let button:UIButton = sender as! UIButton? {
   //             destination.post = posts![button.tag]
                destination.setPost(p: posts![button.tag])
            
               }
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
        
        cell.commentButton.tag = indexPath.row
        cell.commentButton.addTarget(self, action: #selector(TimelineViewController.openComments(_:)) , for: UIControl.Event.touchUpInside)
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = posts![indexPath.row]
        let destinationVC = CommentViewController()
        destinationVC.post = selectedPost
        destinationVC.fetchComments()
    //    destinationVC.performSegue(withIdentifier: "commentSegue", sender: self)
        TimelineViewController().performSegue(withIdentifier: "commentSegue", sender: self)
        
    }*/
    
}

